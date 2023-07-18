-module(eb7).
-compile(nowarn_export_all).
-compile(export_all).

%%%EXERCISE 1
%%%1 > {A , B} = {2 ,3}.
%%%2 > B .
%%%
%%%result: 3
%%%


%%%EXERCISE 2
%%%3 > {A , C} = {2 ,5}.
%%%4 > {A , D} = {6 ,6}.
%%%
%%%result after ex1: exception error: no match of right hand side value {6,6}
%%%


%%%EXERCISE 3
%%%output of each line
%%%
%%% A =2+3.
%%% 5
%%%
%%% B=A-1.
%%% 4
%%%
%%% A=B+1.
%%% 5
%%% 
%%% A=B.
%%% exception error: no match of right hand side value 4
%%% 


%%%EXERCISE 4
%%%output of each line
%%%
%%% f(A).
%%% ok
%%% 
%%% A=B.
%%% 4
%%% 
%%% f().
%%% ok
%%% 


%%%EXERCISE 5
%mult/2. Multiploes its two numeric arguments
mult(X,Y) ->
    X*Y.

% double/1. Returns the double of the numeric argument
double(X) ->
    float(X).



%%% when to use ; or . (append helper)
%%% for the bt funcs is there reason we didnt use if statment, wrote func instead
%%% erlang 1 slide 30


% distance/2. consumers two tuples representing coords and return euclidean dist
distance({X,Y}, {A,B}) ->
    math:sqrt((Y-B)*(Y-B) + (X-A)*(X-A)).

%my_and/2. Use if.
my_and(X,Y) ->
    if 
        X == true -> 
            if
                Y == true -> true;
                true -> false
            end;
        true -> false
    end.


% my_or/2 Use if.
my_or(X,Y) ->
    if 
        X == true -> true;
        Y == true -> true;
        true -> false
    end.

%my_not/1 Use if.
my_not(X) ->
    if 
        X == true -> false;
        true -> true
    end.


%%% EXERCISE 6
fibonacci(X) ->
    if
        (X == 1) or (X == 2)-> 1;
        true -> fibonacci(X - 1) + fibonacci(X - 2)
    end.


fibonacciTR_help (X, A, B) ->
    if 
        X == 0 -> A;
        X == 1 -> B;
        true ->fibonacciTR_help(X - 1, B, A + B)
    end.
fibonacciTR(X) ->
    fibonacciTR_help(X, 0, 1).


%%%EXERCISE 7
%%%sum/1 sums up all nums in a list

sum([H|T]) ->
    if
        T == [] -> H;
        true -> H + sum(T)
    end.

% Maximum/1 computes the max on non-empy list of nums
maximum([H|T]) -> maximum(H, T).
maximum(X, []) -> X;
maximum(X, [H|T]) -> maximum(max(H, X), T).


% zip/2 zips two lists
zip([H|T], [A|B]) -> zip([{H,A}], T, B).
zip(L, [], []) -> L;
zip(L, [H|T], [A|B]) -> zip(L++[{H,A}], T, B).


% append/2 appends the two lists (maynot use ++)
append([], [], R) -> reverse(R);
append([], [H|T], R) -> append([], T, [H|R]);
append([H|T], L2, R) -> append(T, L2, [H|R]).
append(L1, L2) -> append(L1, L2, []). 


%reverse/1
reverse([], L) -> L;
reverse([H|T], L) -> reverse(T, [H|L]).
reverse(L) -> reverse(L, []).


%evenL/1 returns the sublist of even numbers in a given list
even([], L) -> L;
even([H|T], L) -> 
    if 
        (H rem 2) == 0 -> even(T, L ++ [H]);
        true -> even(T, L)
    end.
even(L) -> even(L, []).

%take/2 returns the first N elements of L
take(0, _, L) -> L;
take(N, [H|T], L) -> take(N-1, T, L ++ [H]).
take(N, L) -> take(N, L, []).

% drop/2 drops fist N elements of L
drop(0, L) -> L;
drop(N, [_|T]) -> drop(N-1, T).


%%% EXERCISE 8
%%% test: take_2_test...*failed*

%%%EXERCISE 9
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


%%% EXERCISE 10 
%%% Binary Tree operations

sumTree({empty}) -> 0;
sumTree({node, N, LT, RT}, S) -> sumTree(LT, 0) + sumTree(RT, 0) + S.
sumTree({node, N, LT, RT}) -> sumTree({node, N, LT, RT}, N).