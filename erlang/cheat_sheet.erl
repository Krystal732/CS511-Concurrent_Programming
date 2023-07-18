%ERLANG EB7 LIST OPERATIONS
sum([H|T]) ->
    if
        T == [] -> H;
        true -> H + sum(T)
    end.
maximum([H|T]) -> maximum(H, T).
maximum(X, []) -> X;
maximum(X, [H|T]) -> maximum(max(H, X), T).
zip([H|T], [A|B]) -> zip([{H,A}], T, B).
zip(L, [], []) -> L;
zip(L, [H|T], [A|B]) -> zip(L++[{H,A}], T, B).
append([], [], R) -> reverse(R);
append([], [H|T], R) -> append([], T, [H|R]);
append([H|T], L2, R) -> append(T, L2, [H|R]).
append(L1, L2) -> append(L1, L2, []). 
reverse([], L) -> L;
reverse([H|T], L) -> reverse(T, [H|L]).
reverse(L) -> reverse(L, []).
even([], L) -> L;
even([H|T], L) -> 
    if 
        (H rem 2) == 0 -> even(T, L ++ [H]);
        true -> even(T, L)
    end.
even(L) -> even(L, []).
take(0, _, L) -> L;
take(N, [H|T], L) -> take(N-1, T, L ++ [H]).
take(N, L) -> take(N, L, []).
drop(0, L) -> L;
drop(N, [_|T]) -> drop(N-1, T).
map(_, [], L) -> L;
map(F, [H|T], L) -> map(F, T, L ++ [F(H)]).
map(F, L) -> map(F, L, []).
filter(_, [], L) -> L;
filter(F, [H|T], L) ->
    if 
        F(H) == true -> filter(F, T, L ++ [H]).
        true -> filter(F, T, L)
    end.
filter(F, L) -> filter(F, L, []).
fold(_, [], A) -> A;
fold(F, [H|T], A) -> fold(F, T, F(H, A)).
fold(F, [H|T]) ->  fold(F, T, H).

%ERLANG BINARY TREE OPERATIONS
sizet({empty}) ->
    0;
sizet({node,_D,LT,RT}) ->
    1+sizet(LT)+sizet(RT).
mirror({empty}) ->
    {empty};
mirror({node,D,LT,RT}) ->
    {node,D,mirror(RT),mirror(LT)}.
map(_F,{empty}) ->
    {empty};
map(F,{node,D,LT,RT}) ->
    {node,F(D),map(F,LT),map(F,RT)}.
fold(_F,A,{empty}) ->
    A;
fold(F,A,{node,D,LT,RT}) ->
    F(D,fold(F,A,LT),fold(F,A,RT)).
pre({empty}) ->
    [];
pre({node,D,LT,RT}) ->
    [D | pre(LT)++ pre(RT)].
ino({empty}) ->
    [];
ino({node,D,LT,RT}) ->
    ino(LT) ++ [D]  ++ ino(RT).
pos({empty}) ->
    [];
pos({node,D,LT,RT}) ->
    pos(LT) ++ pos(RT) ++ [D].
height({empty}) ->
    0;
height({node, _D, LT, RT}) ->
    1+max(height(LT), height(RT)).
maxt({empty}) ->
    error(empty_tree);
maxt({node, D, {empty}, {empty}}) -> 
    D;
maxt({node, D, LT, {empty}}) -> 
    max(D, maxt(LT));
maxt({node, D, {empty}, RT}) ->  
    max(D, maxt(RT));
maxt({node, D, LT, RT}) -> 
    max(D, max(maxt(LT), maxt(RT))).
mint({empty}) ->
    error(empty_tree);
mint({node, D, {empty}, {empty}}) -> 
    D;
mint({node, D, LT, {empty}}) -> 
    min(D, mint(LT));
mint({node, D, {empty}, RT}) ->  
    min(D, mint(RT));
mint({node, D, LT, RT}) -> 
    min(D, min(mint(LT), mint(RT))).
is_bst({empty})->
    true;
is_bst({node, _D, {empty}, {empty}}) -> 
    true;
is_bst({node, D, LT, {empty}}) -> 
    D > maxt(LT) and is_bst(LT);
is_bst({node, D, {empty}, RT}) ->  
    D < mint(RT) and is_bst(RT);
is_bst({node, D, LT, RT}) -> 
    D > maxt(LT) and is_bst(LT) and 
    (D < mint(RT) and is_bst(RT)).
sumTree({empty}) -> 0;
sumTree({node, N, LT, RT}) -> 
    sumTree(RT) + sumTree(LT) + N.


%EB8

%turnstile
start ( N ) -> % % Spawns a counter and N turnstile clients
    C = spawn (? MODULE , counter_server ,[0]) ,
    [ spawn (? MODULE , turnstile ,[C ,50 ]) || _ <- lists : seq (1 , N )] ,
    C .
counter_server ( State ) -> % % State is the current value of the counter
    receive
        {bump, From} -> From!{State+1}, counter_server(State+1)
    end.
turnstile (_C , 0 ) ->
    io:format("~w trunstile ended~n", [self()]);
turnstile (C , N ) when N > 0->
    C!{bump, self()},
    receive
        {State} -> io:format("~w incremented the counter to ~w~n", [self(), State])
    end,
    turnstile(C, N-1).

%concat string w servlets
start () ->
    S = spawn (? MODULE , server ,[]) ,
    [ spawn (? MODULE , client ,[S]) || _ <- lists:seq (1,10)].
    % spawn (?MODULE, client, [S]).
client ( S ) -> % %
    S!{ start , self () } ,
    receive
        {ok, ServLet} -> ok
    end,
    % io:format("Client: ~p, ServLet: ~p ~n", [self(), ServLet]),
    ServLet!{ add , " h " , self () } ,
    ServLet!{ add , " e " , self () } ,
    ServLet!{ add , " l " , self () } ,
    ServLet!{ add , " l " , self () } ,
    ServLet!{ add , " o " , self () } ,
    ServLet!{ done , self () } ,
    receive
        { Str } ->
        io : format ( " Done : ~p ~s ~n " ,[ self () , Str ])
    end.
server () ->
    receive
        % {start, _From} -> server_session("")
        {start, From} -> ServLet = spawn(?MODULE, servlet, [""]),
            From!{ok, ServLet},
            server()
    end. 
servlet(S) ->
    receive 
        {add, C, _From} -> servlet(S ++ C);
        {done, From} -> From!{S} %server()
    end.


%contiue/counter
start () ->
    S = spawn (? MODULE , server ,[0]) ,
    spawn (?MODULE, client, [S]).
client(S) ->%0 = continue, 1 = counter
    R = rand:uniform(2),
    S!{R, self()}, 
    receive
        {ok} -> ok;
        {N} -> io:format("~w continues~n", [N])
    end,
    client(S).

server(N) ->
    receive
        {1, From} -> From!{ok},server(N+1);
        % {2} -> io:format("~w continues~n", [N]), 
        % server(N)
        {2, From} -> From!{N}, server(N)
    end.

%timer w empty list
start (Freq) ->
    Timer = spawn (?MODULE , timer ,[Freq ,[]]),
    [spawn(?MODULE,client,[Timer])||_<-lists:seq(1,10)].
timer (Freq ,L) ->
    receive 
        {register, From} -> NewL = [From | L]
        after 0 -> NewL = L
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


%bar w getting late

start (P , J ) ->
    S = spawn (? MODULE , server ,[0, 0, false]) ,
    [ spawn (? MODULE , patriots ,[S]) || _ <- lists : seq (1 , P )] ,
    [ spawn (? MODULE , jets ,[S]) || _ <- lists : seq (1 , J )],
    spawn(?MODULE, itGotLate, [3000, S]).
itGotLate(Time, S) ->
    timer:sleep(Time),
    R = make_ref(),
    S!{self(), R, itGotLate},
    receive
        {S,R,ok} ->
            done
    end.
patriots ( S ) -> % Reference to PID of server
    S!{ self () , patriots }.
jets ( S ) -> % Reference to PID of server
    Ref = make_ref () ,
    S!{ self () , Ref , jets } ,
    receive
        {S , Ref , ok } ->
        ok
    end .
server ( Patriots, false ) ->
    receive
        { _From , patriots } ->
        server ( Patriots +1);
        { From , Ref , jets } when Patriots >1 ->
        From !{ self () , Ref , ok } ,
        server ( Patriots -2);
        {From, R, itGotLate} -> From!{self(), R, ok},
        server(Patriots, true)
    end .
server(Patriots, true) ->
        receive
        { _From , patriots } ->
        server ( Patriots +1);
        { From , Ref , jets } ->
        From !{ self () , Ref , ok } ,
        server ( Patriots);
    end .



%guessing game
start() ->
    S = spawn(?MODULE,server_loop,[]),
    [spawn(?MODULE,client,[S]) || _ <- lists:seq(1,1000)].
client(S) ->
    S!{self(),start},
    receive
        {ok,Servlet} ->
            client_loop(Servlet,rand:uniform(100))
    end.
client_loop(Servlet, G) ->
    Servlet!{G,self()},
    receive
        {youGotIt,T} ->
            io:format("~w got it in ~w tries~n",[self(),T]);
        {tryAgain} ->
            client_loop(Servlet,rand:uniform(100))
    end.
server_loop() ->
    receive 
        {From, start} ->
            Servlet = spawn(?MODULE,servlet,[rand:uniform(100),0]),
            From!{ok,Servlet},
            server_loop()
    end.
servlet(N,T) ->
    receive
        {Guess,From} when Guess==N ->
            From!{youGotIt};
        {Guess,From} when Guess/= N ->
            From!{tryAgain},
            servlet(N, T+1)
    end.






%semaphore

make_sem(N) ->
    spawn(?MODULE,sem_loop,[N]).   
acquire(S) ->
    S!{acquire,self()},
    receive
	{ok} ->
	  ok
    end.
release(S) ->
   S!{release}.
sem_loop(0) ->
    receive
        {release} -> sem_loop(1)
    end;
sem_loop(N) when N>0 ->
    receive
        {release} -> sem_loop(N+1);
        {acquire, From} -> From!{ok}, 
            sem_loop(N-1)
    end.
start() ->
    S = sem:make_sem(0),
    spawn(?MODULE,client1,[S]),
    spawn(?MODULE,client2,[S]),
    ok.  
client1(S) ->
    sem:acquire(S),
    io:format("a"),
    io:format("b").
client2(S) ->
    io:format("c"),
    io:format("d"),
    sem:release(S).


%cyclic barrier


make(N) ->
    spawn(?MODULE,coordinator,[N,N,[]]).
reached(B) ->
    B!{reached,self()},
    receive
	ok ->
	    ok
    end.
coordinator(N,0,L) ->
    [PID!ok || PID <- L], 
    coordinator(N, N, []);
coordinator(N,M,L) when M>0 ->
    receive
        {reached, From} ->
            coordinator(N, M-1, [From|L])
    end.
start() ->
    B = barr:make(3),
    spawn(?MODULE,client1,[B]),
    spawn(?MODULE,client2,[B]),
    spawn(?MODULE,client3,[B]),
    ok.
client1(B) ->
    io:format("a"),
    barr:reached(B),
    io:format("1").
client2(B) ->
    io:format("b"),
    barr:reached(B),
    io:format("2").
client3(B) ->
    io:format("c"),
    barr:reached(B),
    io:format("3").


%dry cleaners
dryCleanerLoop ( Clean , Dirty ) -> % % Clean , Dirty are counters
    receive
        {dropOffOverall} ->
            dryCleanerLoop(Clean, Dirty+1);
        {From, pickUpOverall} when Clean>0->
            From!{ok},
            dryCleanerLoop(Clean-1, Dirty);
        {From, dryCleanITems} when Dirty>0 ->
            From!{ok},
            dryCleanerLoop(Clean+1, Dirty-1)
    end.
employee ( DC ) -> % drop off overall , then pick up a clean one 
    DC!{dropOffOverall},
    DC!{self(), pickUpOverall},
    receive
        {ok} ->
            ok
        end.
dryCleanMachine(DC)->%dry clean item(if none are available,wait)
    DC!{self(), dryCleanITem},
    receive
        {ok} -> ok
    end,
    timer:sleep(1000),
    dryCleanMachine(DC).
start (E , M ) -> % E=no. of employees , M = no . of machines
    DC =spawn(? MODULE , dryCleanerLoop ,[0 ,0]) ,
    [spawn(?MODULE,employee,[DC])||_<-lists:seq(1,E)],
    [spawn(?MODULE,dryCleanMachine,[DC])||_<-lists:seq(1,M)].


%producers/consumers

start ( Cap , NofP , NofC ) ->
    RS = spawn (? MODULE , resource , [ 0 , Cap ,0 ,0]),
    [spawn(?MODULE,producer,[RS])||_<-lists:seq(1,NofP)],
    [spawn(?MODULE,consumer,[RS])||_<-lists:seq(1,NofC)],
    ok .
% % client code
producer ( RS ) ->
    startProduce ( RS ) ,
    % % produce
    stopProduce ( RS ).
consumer ( RS ) ->
    startConsume ( RS ) ,
    % % consume
    stopConsume ( RS ).
% % PC code
startProduce ( RS ) ->
    RS ! { startProduce , self () } ,
    receive
        { ok } ->
            ok
    end .
stopProduce ( RS ) ->
    RS ! { stopProduce } .
startConsume ( RS ) ->
    RS ! { startConsume , self () } ,
    receive
        { ok } -> ok
    end .
stopConsume ( RS ) ->
    RS ! { stopConsume } .
resource ( Size , Cap , SP , SC ) ->
    receive
    { startProduce , From } when Size + SP < Cap ->
        From ! { ok } ,
        resource ( Size , Cap , SP +1 , SC );
    { stopProduce } ->
        resource ( Size +1 , Cap , SP -1 , SC );
    { startConsume , From } when Size - SC > 0 ->
        From ! { ok } ,
        resource ( Size , Cap , SP , SC +1);
    { stopConsume } ->
        resource ( Size -1 , Cap , SP , SC -1)
    end .
