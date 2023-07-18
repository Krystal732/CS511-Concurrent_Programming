
-module(eb8).
-compile(nowarn_export_all).
-compile(export_all).
%%%EXERCISE 1
%%% turnstile
%%% turnstile should send {bump} message to the counter thread so the counter can increment its local counter
%%%  counter should send back value of counter to the process

% start ( N ) -> % % Spawns a counter and N turnstile clients
%     C = spawn (? MODULE , counter_server ,[0]) ,
%     [ spawn (? MODULE , turnstile ,[C ,50 ]) || _ <- lists : seq (1 , N )] ,
%     C .

% counter_server ( State ) -> % % State is the current value of the counter
%     receive
%         {bump, From} -> From!{State+1}, counter_server(State+1)
%     end.


% turnstile (_C , 0 ) ->
%     io:format("~w trunstile ended~n", [self()]);


% turnstile (C , N ) when N > 0-> % % C is the PID of the counter , and N the number of  times the turnstile turns
%     C!{bump, self()},
%     receive
%         {State} -> io:format("~w incremented the counter to ~w~n", [self(), State])
%     end,
%     turnstile(C, N-1).









%%% EXERCISE 2
%%% concatenate strings
%%% {start}: client wishes to send a number of strings to be concatenated;
% • {add,S}: concatenate string S to the current result;
% • {done,From}: done sending strings, send back result to From

% check guessing game for how ot spawn servlets for each client

% start () ->
%     S = spawn (? MODULE , server ,[]) ,
%     [ spawn (? MODULE , client ,[S]) || _ <- lists : seq (1 ,10) ].
%     % spawn (?MODULE, client, [S]).
% client ( S ) -> % %
%     S!{ start , self () } ,
%     receive
%         {ok, ServLet} -> ok
%     end,
%     % io:format("Client: ~p, ServLet: ~p ~n", [self(), ServLet]),
%     ServLet!{ add , " h " , self () } ,
%     ServLet!{ add , " e " , self () } ,
%     ServLet!{ add , " l " , self () } ,
%     ServLet!{ add , " l " , self () } ,
%     ServLet!{ add , " o " , self () } ,
%     ServLet!{ done , self () } ,
%     receive
%         { Str } ->
%         io : format ( " Done : ~p ~s ~n " ,[ self () , Str ])
%     end.
% server () ->
%     receive
%         % {start, _From} -> server_session("")
%         {start, From} -> ServLet = spawn(?MODULE, servlet, [""]),
%             From!{ok, ServLet},
%             server()
%     end. 

% servlet(S) ->
%     receive 
%         {add, C, _From} -> servlet(S ++ C);
%         {done, From} -> From!{S} %server()
%     end.






%%% EXERCISE 3
%%% continue/counter
%%% Each time the server receives the message “counter” it should display on the screen the number of
% times that it received the “continue” message since the last time it received the “counter” message.

% 2. Modify your solution so that the server, instead of printing the number on the screen, sends it back to
% the client which then prints the number of the screen himself.


% start () ->
%     S = spawn (? MODULE , server ,[0]) ,
%     spawn (?MODULE, client, [S]).
% client(S) ->%0 = continue, 1 = counter
%     R = rand:uniform(2),
%     S!{R, self()}, 
%     receive
%         {ok} -> ok;
%         {N} -> io:format("~w continues~n", [N])
%     end,
%     client(S).

% server(N) ->
%     receive
%         {1, From} -> From!{ok},server(N+1);
%         % {2} -> io:format("~w continues~n", [N]), server(N)
%         {2, From} -> From!{N}, server(N)
%     end.








%%% EXERCISE 4
%%% timer
% start ( Freq ) ->
%     L = [ spawn (? MODULE , client ,[]) || _ <- lists : seq (1 ,10) ] ,
%     spawn (? MODULE , timer ,[ Freq , L] ).

% timer ( Freq , L ) ->
%     timer : sleep ( Freq ) ,
%     [ Pid !{ tick } || Pid <- L] ,
%     timer ( Freq     , L ).

% client () ->
%     receive
%         { tick } -> io:format("tick~n"),
%         client ()
%     end.



%%% EXERCISE 5
%%% timer with empty list

%%% HELP WITH WHAT TO DO AFTER CLIENT REGISTERS 153
start (Freq) ->
    Timer = spawn (?MODULE , timer ,[Freq ,[]]),
    [spawn (?MODULE , client ,[Timer]) || _ <- lists : seq (1 ,10)].

timer (Freq ,L) ->
    receive 
        {register, From} ->
            NewL = [From | L]
        after 0 ->
            NewL = L
    end,
    timer : sleep (Freq),
    [Pid!{tick} || Pid <- L],
    timer (Freq ,NewL).

client (T) ->
    T!{register,self()},
    receive
    {tick} ->
        io : format ("Tick : ~p~n",[self()]),
        client (T)
    end.



%%% EXERCISE 6
%%% Prime?
%%% sever receives n and sends back bool if prime
%%% 
%%% ad-hoc? generic server?

% start() ->
%     S = spawn(?MODULE, server, []),
%     spawn(?MODULE, client, [rand:uniform(100), S]).


% isPrime(0, _)-> false;
% isPrime(1, _)-> false;
% isPrime(2, _)-> true;
% isPrime(N, N) -> true;
% isPrime(N, I) ->
%     case (N rem I) == 0 of
%         true -> false;
%         _ -> isPrime(N, I+1)
%     end.    

% server() ->
%     receive
%         {N} -> io:format("~p is prime: ~p", [N,isPrime(N, 2)])
%     end.

% client(N, S) ->
%     S!{N}.





%%% EXERCISE 7
%%% bar with jets and patriots
%%% 1 jet per 2 pats
%%% 


%%% why jets need to reveive ok
 
% start (P , J ) ->
%     S = spawn (? MODULE , server ,[0]) ,
%     [ spawn (? MODULE , patriots ,[S]) || _ <- lists : seq (1 , P )] ,
%     [ spawn (? MODULE , jets ,[S]) || _ <- lists : seq (1 , J )].

% patriots ( S ) -> % Reference to PID of server
%     S!{ self () , patriots }.

% jets ( S ) -> % Reference to PID of server
%     Ref = make_ref () ,
%     S!{ self () , Ref , jets } ,
%     receive
%         {S , Ref , ok } ->
%         ok
%     end .

% server ( Patriots ) ->
%     receive
%         { _From , patriots } ->
%         server ( Patriots +1);
%         { From , Ref , jets } when Patriots >1 ->
%         From !{ self () , Ref , ok } ,
%         server ( Patriots -2)
%     end .


%%% pt2: it got late

% start (P , J ) ->
%     S = spawn (? MODULE , server ,[0, 0, false]) ,
%     [ spawn (? MODULE , patriots ,[S]) || _ <- lists : seq (1 , P )] ,
%     [ spawn (? MODULE , jets ,[S]) || _ <- lists : seq (1 , J )],
%     spawn(?MODULE, itGotLate, [3000, S]).

% itGotLate(Time, S) ->
%     timer:sleep(Time),
%     R = make_ref(),
%     S!{self(), R, itGotLate},
%     receive
%         {S,R,ok} ->
%             done
%     end.

% patriots ( S ) -> % Reference to PID of server
%     S!{ self () , patriots }.

% jets ( S ) -> % Reference to PID of server
%     Ref = make_ref () ,
%     S!{ self () , Ref , jets } ,
%     receive
%         {S , Ref , ok } ->
%         ok
%     end .

% server ( Patriots, false ) ->
%     receive
%         { _From , patriots } ->
%         server ( Patriots +1);
%         { From , Ref , jets } when Patriots >1 ->
%         From !{ self () , Ref , ok } ,
%         server ( Patriots -2);
%         {From, R, itGotLate} -> From!{self(), R, ok},
%         server(Patriots, true)
%     end .

% server(Patriots, true) ->
%         receive
%         { _From , patriots } ->
%         server ( Patriots +1);
%         { From , Ref , jets } ->
%         From !{ self () , Ref , ok } ,
%         server ( Patriots);
%     end .





%%%EXXERCISE 8
%%% 

% start() ->
%     S = spawn(?MODULE,server_loop,[]),
%     [spawn(?MODULE,client,[S]) || _ <- lists:seq(1,1000)].

% client(S) ->
%     S!{self(),start},
%     receive
%         {ok,Servlet} ->
%             client_loop(Servlet,rand:uniform(100))
%     end.

% client_loop(Servlet, G) ->
%     Servlet!{G,self()},
%     receive
%         {youGotIt,T} ->
%             io:format("~w got it in ~w tries~n",[self(),T]);
%         {tryAgain} ->
%             client_loop(Servlet,rand:uniform(100))
%     end.

% server_loop() ->
%     receive 
%         {From, start} ->
%             Servlet = spawn(?MODULE,servlet,[rand:uniform(100),0]),
%             From!{ok,Servlet},
%             server_loop()
%     end.

% servlet(N,T) ->
%     receive
%         {Guess,From} when Guess==N ->
%             From!{youGotIt};
%         {Guess,From} when Guess/= N ->
%             From!{tryAgain},
%             servlet(N, T+1)
%     end.