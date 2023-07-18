-module(server).

-export([start_server/0]).

-include_lib("./defs.hrl").

-spec start_server() -> _.
-spec loop(_State) -> _.
-spec do_join(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_leave(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_new_nick(_State, _Ref, _ClientPID, _NewNick) -> _.
-spec do_client_quit(_State, _Ref, _ClientPID) -> _NewState.

start_server() ->
    catch(unregister(server)),
    register(server, self()),
    case whereis(testsuite) of
	undefined -> ok;
	TestSuitePID -> TestSuitePID!{server_up, self()}
    end,
    loop(
      #serv_st{
	 nicks = maps:new(), %% nickname map. client_pid => "nickname"
	 registrations = maps:new(), %% registration map. "chat_name" => [client_pids]
	 chatrooms = maps:new() %% chatroom map. "chat_name" => chat_pid
	}
     ).

loop(State) ->
    receive 
	%% initial connection
	{ClientPID, connect, ClientNick} ->
	    NewState =
		#serv_st{
		   nicks = maps:put(ClientPID, ClientNick, State#serv_st.nicks),
		   registrations = State#serv_st.registrations,
		   chatrooms = State#serv_st.chatrooms
		  },
	    loop(NewState);
	%% client requests to join a chat
	{ClientPID, Ref, join, ChatName} ->
	    NewState = do_join(ChatName, ClientPID, Ref, State),
	    loop(NewState);
	%% client requests to join a chat
	{ClientPID, Ref, leave, ChatName} ->
	    NewState = do_leave(ChatName, ClientPID, Ref, State),
	    loop(NewState);
	%% client requests to register a new nickname
	{ClientPID, Ref, nick, NewNick} ->
	    NewState = do_new_nick(State, Ref, ClientPID, NewNick),
	    loop(NewState);
	%% client requests to quit
	{ClientPID, Ref, quit} ->
	    NewState = do_client_quit(State, Ref, ClientPID),
	    loop(NewState);
	{TEST_PID, get_state} ->
	    TEST_PID!{get_state, State},
	    loop(State)
    end.

%% executes join protocol from server perspective
do_join(ChatName, ClientPID, Ref, State) ->
	%check if chatroom exists
	case maps:get(ChatName, State#serv_st.chatrooms, false) of
		false -> %dne then make it and run do_join again
			NewChatPID = spawn(chatroom, start_chatroom, [ChatName]),
			NewState = State#serv_st{chatrooms = maps:put(ChatName, NewChatPID, State#serv_st.chatrooms), registrations=maps:put(ChatName,[],State#serv_st.registrations)},
			do_join(ChatName, ClientPID, Ref, NewState);
		ChatroomPID -> %exists then tell chat that client is joining, update registrations
			Nick = maps:get(ClientPID, State#serv_st.nicks),
			ChatroomPID!{self(), Ref, register, ClientPID, Nick},
			State#serv_st{registrations = maps:put(ChatName, maps:get(ChatName, State#serv_st.registrations) ++ [ClientPID], State#serv_st.registrations)}
	end.

%% executes leave protocol from server perspective
do_leave(ChatName, ClientPID, Ref, State) ->
	{ok, ChatPID} = maps:find(ChatName, State#serv_st.chatrooms),
	{ok, List_ClientPIDs} = maps:find(ChatName, State#serv_st.registrations),
	% NewState = State#serv_st{registrations = maps:put(ChatName, lists:delete(ClientPID, List_ClientPIDs, State#serv_st.registrations))},
	NewState = State#serv_st{registrations = maps:put(ChatName, lists:delete(ClientPID, List_ClientPIDs),  State#serv_st.registrations)},
	ChatPID!{self(), Ref, unregister, ClientPID},
	ClientPID!{self(), Ref, ack_leave},

    NewState.




%% executes new nickname protocol from server perspective
do_new_nick(State, Ref, ClientPID, NewNick) ->
	case lists:member(NewNick,maps:values(State#serv_st.nicks)) of
		true -> ClientPID!{self(), Ref, err_nick_used}, State;
		false -> 
			NewState = State#serv_st{nicks = maps:update(ClientPID, NewNick, State#serv_st.nicks)},
			lists:foreach(
				fun(ChatName) -> 
				case lists:member(ClientPID, maps:get(ChatName, State#serv_st.registrations)) of
					true -> ChatPID = maps:get(ChatName, State#serv_st.chatrooms),
						ChatPID!{self(), Ref, update_nick,ClientPID, NewNick};
					false -> ok
				end
			end, maps:keys(State#serv_st.registrations)),
			ClientPID!{self(), Ref, ok_nick},
			NewState
		end.
	% 		%send message to all chatrooms which client belongs to
	% 		ChatMap = maps:filtermap( fun(_, V) -> lists:member(ClientPID, V) end, State#serv_st.registrations), 
	% 		SendFun = fun(K,_) -> 
	% 			{ok,ChatPID} = maps:find(K, State#serv_st.chatrooms), 
	% 			ChatPID!{self(), Ref, update_nick,ClientPID, NewNick} end,
	% 		maps:foreach(SendFun, ChatMap),
	% 		ClientPID!{self(), Ref, ok_nick},
	% 		NewState
	% end.


%% executes client quit protocol from server perspective
do_client_quit(State, Ref, ClientPID) ->
	%remove client from nicknames
	NewNicks = maps:remove(ClientPID, State#serv_st.nicks),
	%tell each chatroom which has the client registered that it is leaving
	% case lists:member(NewNick,maps:values(State#serv_st.nicks)) of
	% 	true -> ClientPID!{self(), Ref, err_nick_used}, State;
	% 	false -> 
	% 		NewState = State#serv_st{nicks = maps:update(ClientPID, NewNick, State#serv_st.nicks)},
	% 		lists:foreach(
	% 			fun(ChatName) -> 
	% 			case lists:member(ClientPID, maps:get(ChatName, State#serv_st.registrations)) of
	% 				true -> ChatPID = maps:get(ChatName, State#serv_st.chatrooms),
	% 					ChatPID!{self(), Ref, update_nick,ClientPID, NewNick};
	% 				false -> ok
	% 			end
	% 		end, maps:keys(State#serv_st.registrations))


	ChatMap = maps:filtermap( fun(_, V) -> lists:member(ClientPID, V) end, State#serv_st.registrations), 
	SendFun = fun(K,_) -> 
		{ok,ChatPID} = maps:find(K, State#serv_st.chatrooms), 
		ChatPID!{self(), Ref, unregister,ClientPID} end,
	maps:foreach(SendFun, ChatMap),

	% remove client from servers registrations
	RemoveFun = fun(_, V) ->
		lists:delete(ClientPID, V) end,
	NewRegistrations = maps:map(RemoveFun, ChatMap),
	ClientPID!{self(), Ref, ack_quit},
	State#serv_st{nicks = NewNicks, registrations = NewRegistrations}.
