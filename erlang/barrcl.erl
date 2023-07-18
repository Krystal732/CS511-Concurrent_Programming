-module(barrcl).
-compile(nowarn_export_all).
-compile(export_all).


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
