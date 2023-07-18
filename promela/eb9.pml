//non progress

//spin -run -DNP -l eb9.pml
//spin -run -DNP -l -r eb9.pml

// bool wantP = false ;
// bool wantQ = false ;

// active proctype P () {
//     do
//         :: wantP = true ;
//         do
//         :: wantQ == false -> break
//         :: else
//         od ;
// progress1 :
//     wantP = false
//     od
// }
// active proctype Q () {
//     do
//         :: wantQ = true ;
//         do
//         :: wantP == false -> break
//         :: else
//         od ;
// progress2 :
//     wantQ = false
//     od
// }


// byte turn = 1;

// active proctype P(){
//     do
//         :: do
//             :: turn ==1 -> break;
//             ::else
//             od;
// progressP:
//             turn = 2
//     od
// }



// active proctype Q(){
//     do
//         :: do
//             :: turn ==2 -> break;
//             ::else
//             od;
// progressQ:
//             turn = 1
//     od
// }
// EXERCISE 1
// verify always between 0 and 200

// byte x = 0;

// active proctype add(){
//     do 
//         :: atomic{x < 200 -> x++;  assert(x <= 200 && x >= 0)}
//     od
// }
// active proctype sub(){
//     do 
//         :: atomic{x > 0 -> x--; assert(x <= 200 && x >= 0)}
//     od
// }
// active proctype zero(){
//     do 
//         :: atomic{x == 200 -> x = 0; assert(x <= 200 && x >= 0)}
//     od
// }


// //EXERCISE 2
// byte turn = 1;

// active proctype P(){
//     do 
//         ::do
//             :: turn == 1 -> break;
//             :: else
//         od;
//         printf("P went in /n");
//         assert(turn == 1);
//         turn = 2
//     od
// }

// active proctype Q(){
//     do 
//         ::do
//             :: turn == 2 -> break;
//             :: else
//         od;
//         printf("Q went in \n");
//         assert(turn == 2);
//         turn = 1
//     od
// }



//EXERCISE 3
//entry/exit want


// bool wantp = false ;
// bool wantq = false ;
// byte cs =0;

// active proctype P () {
//     do
//         :: wantp = true ;
//             do
//                 :: ! wantq -> break ;
//             od ;
//         cs ++;
//         assert ( cs ==1);
//         cs --;
//         wantp = false 
//     od
// }

// active proctype Q () {
//     do
//         :: wantq = true ;
//             do
//                 :: ! wantp -> break ;
//             od ;
//         cs ++;
//         assert ( cs ==1);
//         cs --;
//         wantq = false 
//     od
// }


//DECKER

// bool wantp = false ;
// bool wantq = false ;
// byte turn = 1;
// byte cs =0;

// active proctype P () {
//     do
//         :: wantp = true ;
//             do
//                 :: ! wantq -> break ;
//                 :: else ->
//                     if
//                         :: ( turn == 2) ->
//                             wantp = false ;
//                             do
//                                 :: turn ==1 -> break
//                                 :: else
//                             od ;
//                             wantp = true
//                         :: else /* leaves if , if turn < >2 */
//                     fi
//             od ;
// progressP:
//         cs ++;
//         assert ( cs ==1);
//         cs --;
//         wantp = false ;
//         turn = 2
//     od
// }

// active proctype Q () {
//     do
//         :: wantq = true ;
//             do
//                 :: ! wantp -> break ;
//                 :: else ->
//                     if
//                         :: ( turn == 1) ->
//                             wantq = false ;
//                             do
//                                 :: turn ==2 -> break
//                                 :: else
//                             od ;
//                             wantq = true
//                         :: else /* leaves if , if turn < >2 */
//                     fi
//             od ;

// progressQ:
//         cs ++;
//         assert ( cs ==1);
//         cs --;
//         wantq = false ;
//         turn = 1
//     od
// }




//EXERCISE 4





//EXERCISE 5
// guarantees mutual exclusion

// bool flag [2];
// bool turn;
// byte critical = 0;

// active [2] proctype user ()
// {
//     flag [ _pid ] = true;
//     turn = _pid;
//     // turn = _pid;
//     // flag [ _pid ] = true;
//     ( flag [1 - _pid ] == false || turn == 1 - _pid );

// // crit : skip // critical section
//     critical++;
//     assert(critical == 1);
//     critical--;

//     flag [ _pid ] = false;
// }



//EXERCISE 6
// no longer guarantees mutex, assertion error


//EXERCISE 7
//bakery

//assertion error violation
// looked at example but why? not atomic?

//if get assertion error how can i tell if it actually is mutually exlusive

// byte np = 0;
// byte nq = 0;
// byte cs =0;
// byte temp = 0;

// active proctype P () {
//     do
//         ::  np = 1;
//             np = nq + 1 ;
//             // temp = nq + 1;
//             // np = temp;

//             do
//                 :: (nq == 0|| np <= nq) -> break ;
//             od ;
//             cs ++;
//             assert ( cs ==1);
//             cs --;
//             np = 0 
//     od
// }

// active proctype Q () {
//     do
//         ::  nq = 1
//             nq = np + 1 ;
//             // temp = np + 1;
//             // nq = temp;
//             do
//                 :: (np == 0|| nq < np) -> break ;
//             od ;
//             cs ++;
//             assert ( cs ==1);
//             cs --;
//             nq = 0 
//     od
// }


// byte n=0;

// active proctype P(){
//     int i = 0;
//     for (i: 1..1000){
//         n++;
//     }
//     // assert(n == 1000);
// }





//EXERCISE 8
//Extension of Dekker

// bool flags[3];
// byte turn;
// byte cs =0;

// proctype P () {
//     byte myId = _pid-1;

//     byte left = (myId + 2) % 3;
//     byte right = (myId + 1) % 3;
//     do
//         :: flags[myId] = true ;
//             do
//                 :: (flags[left] || flags[right]) -> 
//                     if
//                         :: ( turn == left) ->
//                             flags[myId] = false ;
//                             // turn = myId;
//                             do
//                                 :: turn == myId -> break
//                                 :: else
//                             od ;
//                             flags[myId] = true
//                         :: else /* leaves if*/
//                     fi
//                 :: else -> break
//             od ;
//             cs ++;
//             assert ( cs ==1);
//             cs --;

//             turn = right ;
//             flags[myId] = false
//     od
// }

// init{
//     turn=0;
//     byte i;
//     for(i:0..2){flags[i] = false;}
//     atomic{
//         for(i:0..2) {run P();}
//     }
// }




//bonellis version


// bool flags[3];
// byte turn;
// byte cs =0;

// proctype P () {
//     byte myId = _pid-1;

//     byte left = (myId + 2) % 3;
//     byte right = (myId + 1) % 3;
//     flags[myId] = true ;
//     do
//         :: (!flags[left] && !flags[right]) -> break;
//         :: else ->
//             if
//                 :: ( turn == left) ->
//                     flags[myId] = false ;
//                     turn = myId;
//                     flags[myId] = true;
//                 :: else /* leaves if*/
//             fi
//     od
//     cs ++;
//     assert ( cs ==1);
//     cs --;

//     turn = right ;
//     flags[myId] = false
// }

// init{
//     turn=0;
//     byte i;
//     for(i:0..2){flags[i] = false;}
//     atomic{
//         for(i:0..2) {run P();}
//     }
// }






//EXERCISE 9
// inline acquire ( sem ) {
//     atomic {
//         sem >0;
//         sem --
//     }
// }
// inline release ( sem ) {
//     sem ++
// }





//EXERCISE 11
// car wash

// # define N 3 /* Number of Washing Machines */
// # define C 10 /* Number of Cars */

// byte permToProcess [N]
// byte doneProcessing [N]
// byte station0 = 1
// byte station1 = 1
// byte station2 = 1

// byte cars [N]


// inline acquire ( s ) {
//     atomic {
//         s >0 -> s --
//     }
// }

// inline release ( s ) {
//     s ++
// }

// proctype Car () {
//  /* complete */
//     byte myId = _pid-1;

//     acquire(station0);
//     //car at s0
//     release(permToProcess[0]);
//     acquire(doneProcessing[0]);
//     //leaving s0
//     release(station0);

//     acquire(station1);
//     //car at s1
//     release(permToProcess[1]);
//     acquire(doneProcessing[1]);
//     //leaving s1
//     release(station1);

//     acquire(station2);
//     //car at s2
//     release(permToProcess[2]);
//     acquire(doneProcessing[2]);
//     //leaving s2
//     release(station2);
// }

// proctype Machine ( int i ) {
//     /* complete */

//     do
//         ::  acquire(permToProcess[i]);
//             //process car
//             cars[i] ++;
//             assert(cars[i] == 1);
//             cars[i] --;

//             release(doneProcessing[i])
//     od
// }

// init {
//     byte i ;

//     for ( i :0..( N -1)) {
//         permToProcess [i] =0;
//         doneProcessing [i] =0;
//         cars[i] =0;
//     }

//     atomic {
//         for ( i :1..( C )) {
//             run Car ();
//         }
//         for ( i :0..( N -1)) {
//             run Machine ( i );
//         }
//     }
// }