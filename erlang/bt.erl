-module(bt).
-compile(nowarn_export_all).
-compile(export_all).
%% -export([t1/0]).
-author("E.B.").

%%% Playing with tuples and atoms 
%%% Encoding binary trees.

%%% Idea
%%% Empty tree: {empty}
%%% Non-empty tree: {node,Data,LT,RT}

%%% Example.

   %%   33
   %%  /  \
   %% 22  14
   %%    /  \
   %%   12   54

t1() ->
    {node,33,
     {node,22,{empty},{empty}},
     {node,14,
      {node,12,{empty},{empty}},
      {node,54,{empty},{empty}}}}.

sizet({empty}) ->
    0;
sizet({node,_D,LT,RT}) ->
    1+sizet(LT)+sizet(RT).
% c(bt).
% bt:sizet(bt:t1()).
%the _ shows the compiler that we know we not using D


add({empty}) ->
    0;
add({node,D,LT,RT}) ->
    D+add(LT)+add(RT).

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

%% height - warm up
height({empty}) ->
    0;
height({node, _D, LT, RT}) ->
    1+max(height(LT), height(RT)).

%% max - maximum element in non-empty tree
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

%% min - minimum element in non-empty tree
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

%% is_bst - tree is a binary search tree
is_bst({empty})->
    true;
is_bst({node, _D, {empty}, {empty}}) -> 
    true;
is_bst({node, D, LT, {empty}}) -> 
    D > maxt(LT) and is_bst(LT);
is_bst({node, D, {empty}, RT}) ->  
    D < mint(RT) and is_bst(RT);
is_bst({node, D, LT, RT}) -> 
    D > maxt(LT) and is_bst(LT) and (D < mint(RT) and is_bst(RT)).



% sumTree({empty}, S) -> S;
% sumTree({node, N, LT, RT}, S) -> sumTree(LT, N + sumTree(RT, 0) + sumTree(LT, 0)) + S.
% sumTree({node, N, LT, RT}) -> sumTree({node, N, LT, RT}, 0).

sumTree({empty}) -> 0;
sumTree({node, N, LT, RT}) -> sumTree(RT) + sumTree(LT) + N.