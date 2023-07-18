-module( dc ).
- compile ( nowarn_export_all ).
- compile ( export_all ).


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

employee ( DC ) -> % drop off overall , then pick up a clean one ( if none
    DC!{dropOffOverall},
    DC!{self(), pickUpOverall},
    receive
        {ok} ->
            ok
        end.


dryCleanMachine ( DC ) -> % dry clean item ( if none are available , wait ) ,
    DC!{self(), dryCleanITem},
    receive
        {ok} -> ok
    end,
    timer:sleep(1000),
    dryCleanMachine(DC).

start (E , M ) -> % E = no . of employees , M = no . of machines
    DC =spawn(? MODULE , dryCleanerLoop ,[0 ,0]) ,
    [ spawn(? MODULE , employee ,[DC]) || _ <- lists : seq (1 , E ) ],
    [ spawn(? MODULE , dryCleanMachine ,[DC]) || _ <- lists : seq (1 , M ) ].
