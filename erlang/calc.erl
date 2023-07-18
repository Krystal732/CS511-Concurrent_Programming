%%% Stub for Quiz 6


-module(calc).
-compile(nowarn_export_all).
-compile(export_all).

env() -> #{"x"=>3, "y"=>7}. %% Sample environment

e1() -> %% Sample calculator expression
    {add, 
     {const,3},
     {divi,
      {var,"x"},
      {const,4}}}.

e2() -> %% Sample calculator expression
    {add, 
     {const,3},
     {divi,
      {var,"x"},
      {const,0}}}.

e3() -> %% Sample calculator expression
    {add, 
     {const,3},
     {divi,
      {var,"r"},
      {const,4}}}.

eval({const,N},_E) ->
    N;

eval({var,Id},E) ->
    {O, N} = maps:find(Id, E),
    case O of
        ok -> N;
        _ -> throw(unbound_identifier_error)
    end;

eval({add,E1,E2},E) ->
    E1 + E2;

eval({sub,E1,E2},E) ->
    E1 - E2;

eval({mult,E1,E2},E) ->
    E1 * E2;

eval({divi,E1,E2},E) ->
    E1/E2.

