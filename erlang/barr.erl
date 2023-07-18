-module(barr).
-compile(nowarn_export_all).
-compile(export_all).

make(N) ->
    spawn(?MODULE,coordinator,[N,N,[]]).

reached(B) ->
    B!{reached,self()},
    receive
	ok ->
	    ok
    end.

% coordinator(N,M,L)
% N is the size of the barrier
% M is the number of processes YET to arrive at the barrier
% L is a list of the PIDs of the processes that have already arrived at the barrier 

coordinator(N,0,L) ->
    [PID!ok || PID <- L], coordinator(N, N, []);
coordinator(N,M,L) when M>0 ->
    receive
        {reached, From} -> coordinator(N, M-1, [From|L])
    end.