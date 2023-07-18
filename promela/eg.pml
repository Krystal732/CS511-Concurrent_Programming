byte c=0;
proctype P() {
 byte i;
 byte tmp;
 do
  :: i>9 -> break;
  :: else -> i++; tmp=c; c=tmp+1;
 od
}

proctype Q() {
 byte i;
 byte tmp;
 do
  :: i>9 -> break;
  :: else -> i++; tmp=c; c=tmp+1;
 od
}

init {
 atomic {
  run P();
  run Q();
 }
 _nr_pr==1;
  printf("c=%d\n",c)
}