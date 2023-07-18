byte turn = 0;
bool flags[2];

proctype mep(int n){
    do //while true
        :: flags[n] = true;
            do //while(turn != me)
                :: turn == n -> break
                :: else -> 
                    do //while(flag[1-me])
                        :: !flags[1-n] -> break
                        :: else
                    od;
                    turn = n;
            od;
        printf("%d went in \n", n);
        flags[n] = false;
        printf("%d went out \n", n);
    od
}

init {
    byte i ;
    for ( i :0..(1)) {
        flags [i] = false;
    }
    atomic{
        run mep(1);
        run mep(0);
    }

}