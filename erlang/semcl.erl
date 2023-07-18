-module(semcl).
-compile(nowarn_export_all).
-compile(export_all).

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
