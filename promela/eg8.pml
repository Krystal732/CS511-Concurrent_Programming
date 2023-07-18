byte n=0;
byte finished = 0;

active [2] proctype P() {
 byte i;
 byte temp;
 for(i:1..10){
    temp = n;
    n = temp + 1
 }
 finished++;
}

active proctype Finish() {
 finished == 2;
 printf("n = %d\n", n);
 assert(n>2);
}
