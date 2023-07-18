-module(pc).
-compile(nowarn_export_all).
-compile(export_all).


start()->
    RS = spawn(?MODULE, resource, [0, Cap, 0, 0]),
    [spawn(?MODULE, producer, [RS]) || <- lists:seq(1, NofP)]
    [spawn(?MODULE, consumer, [RS]) || <- lists:seq(1, NofC)]


producer(RS) ->
    RS!{startProduce, self()},
    receive
        {ok} -> ok
    end,
    timer:sleep(rand:uniform(100)),
    RS!{stopProduce}.

resource(Size, Cap, SP, SC) ->
    receive
        {startProduce, From} when Size + SP < Cap ->
            From!{ok},
            resource(Size ,Cap, SP+1, SC);
        {stopProduce, From} ->
            resource(Size+1, Cap, SP-1, SC);
        {startConsume, From} when Size - SC > 0 ->
            From!{ok},
            resource(Size, Cap, SP, SC+1);
        {startConsume} ->
            resource(Size-1, Cap, SP, SC-1)
    end.

