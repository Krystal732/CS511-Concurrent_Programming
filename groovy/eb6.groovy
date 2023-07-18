import java.util.concurrent.locks.*
//IMPLEMENT SEMAPHORES USING MONITORS

// class Semaphore{
//     int permits
//     Semaphore(int init){
//         permits = init
//     }

//     public synchronized void acquire(){
//         while (permits = 0){
//             wait()
//         }
//         permits--
//     }

//     public synchronized void release(){
//         permits++
//         notify()
//     }
// }


//EXEERCISE 1
//same as eb5 exercise 1 
//1 jet fan for every 2 partriots

// class Bar {
//     // your code here
//     int p = 0 //num of patriots
//     public synchronized jets(){
//         while(p<2){
//             wait()
//         }
//         print"j"
//         p-=2
//     }
//     public synchronized patriots(){
//         print"p"
//         p++
//         notify()
//     }
// }
// Bar b = new Bar();
// 100. times {
//     Thread.start {// jets
//         b.jets();
//     }
// }
// 100. times {
//     Thread.start {// patriots
//         b.patriots ();
//     }
// }




//EXERCISE 2
// class TWS {
//     int state = 1;
//     static final Lock lock = new ReentrantLock ();
//     static final Condition first = lock.newCondition ();
//     static final Condition second = lock.newCondition ();
//     static final Condition third = lock.newCondition ();

//     void one() {
//         lock.lock();
//         try {
//             while (state != 1){
//                 first.await();
//             }
//             println"1"
//             state = 2;
//             second.signal();
//         } finally {
//             lock.unlock ();
//         }

//     }

//     void two () {
//         lock.lock();
//         try {
//             while (state != 2){
//                 second.await();
//             }
//             println"2"
//             state = 3;
//             third.signal ();
//         } finally {
//             lock.unlock ();
//         }
//     }

//     void three() {
//         lock.lock();
//         try {
//             while (state != 3){
//                 third.await();
//             }
//             println"3"
//             state = 1;
//             first.signal ();
//         } finally {
//             lock.unlock ();
//         }
//     }
// }

// TWS hi = new TWS()

// 20.times{ 
//     Thread.start{
//         int w = new Random().nextInt(3)
//         switch (w){
//             case 0: hi.one() ; break
//             case 1: hi.two() ; break
//             default: hi.three();
//         }

//     }
// }

// Thread.start{
//     hi.one()
// }

// // Thread.start{
// //     hi.three()
// // }

























//EXERCISE 3

// class Barrier {
//     int size;

//     Barrier(int size) {
// 	this.size=size
//     }


//     public synchronized void reached(){
// 		size--
// 		while(size >0){
// 			wait()
// 		}
// 		notifyAll()
// 	}
    
// }

// Barrier b = new Barrier(3)

// Thread.start {// P
//     println "1"
//     b.reached()
//     println "a"
// }

// Thread.start {// Q
//     println "2"
//     b.reached()
//     println "b"
// }

// Thread.start {// R
//     println "3"
//     b.reached()
//     println "c"
// }

















//EXERCISE  4 

/*
2 tracks, 0: n->s     1: s->n
passenger trains:
can only stop at station if no other trains on same track


freight trains:
can be loaded if no train at station (neither tracks)

*/
// import java.util.concurrent.locks.*;

// class TrainStation {
//     static final Lock lock = new ReentrantLock ();
//     static final Condition north = lock.newCondition ();
//     static final Condition south = lock.newCondition ();
//     static final Condition freight = lock.newCondition()
//     boolean n = false
//     boolean s = false

//     void acquireNorthTrackP () {
//         lock.lock()
//         try {
//             while (n == true){
//                 north.await();
//             }
//             n = true
//         } finally {
//             lock.unlock ();
//         }

//     }
//     void releaseNorthTrackP () {
//         lock.lock()
//         try {
//             n = false
//             freight.signal()
//             north.signal()

//         } finally {
//             lock.unlock ();
//         }        
//     }
//     void acquireSouthTrackP () {
//         lock.lock()
//         try {
//             while (s == true){
//                 south.await();
//             }
//             s = true
//         } finally {
//             lock.unlock ();
//         }
//     }
//     void releaseSouthTrackP () {
//         lock.lock()
//         try {
//             s = false
//             south.signal()
//             freight.signal()

//         } finally {
//             lock.unlock ();
//         } 
//     }
//     void acquireTracksF () {
//         lock.lock()
//         try {
//             while (s == true & n == true){
//                 freight.await();
//             }
//             if (n == true){ //south free
//                 s = true
//                 while (n == true){
//                     north.await();
//                 }
//             }
//             if (s == true){ //north free
//                 n = true
//                 while (s == true){
//                     south.await();
//                 }
//             }
//         } finally {
//             lock.unlock ();
//         }

//     }
//     void releaseTracksF () {
//         lock.lock()
//         try{
//             n = s = false
//             north.signal()
//             south.signal()
//             freight.signal()
//         } finally{
//             lock.unlock()
//         }
//     }   
// }

// TrainStation s = new TrainStation ();

// 100. times{
//     Thread.start { // Passenger Train going North
//         s.acquireNorthTrackP ();
//         print "NPT"+Thread.currentThread (). getId();
//         s.releaseNorthTrackP ();
//     }
// }

// 100. times{
//     Thread.start { // Passenger Train going South
//         s.acquireSouthTrackP ();
//         print "SPT"+ Thread.currentThread (). getId ();
//         s.releaseSouthTrackP ()
//     }
// }

// 10. times {
//     Thread.start { // Freight Train
//         s.acquireTracksF ();
//         print "FT "+ Thread.currentThread (). getId();
//         s.releaseTracksF ();
//     }
// }




//EXERCISE 5
class Grid {
    int numConsumers = 0, numProducers = 0
    final int N = 5
    synchronized void startConsuming () {
        while (numProducers < (numConsumers+1) || numProducers == 0){
            wait()
        }
        numConsumers++
        println("started consuming, # of consumers: " + numConsumers + " , number of producers: " + numProducers)
    }
    synchronized void stopConsuming () {
        numConsumers--
        println("stopped consuming, # of consumers: " + numConsumers + " , number of producers: " + numProducers)
        notifyAll()
    }
    synchronized void startProducing () {
        while((numProducers + 1)> N){
            wait()
        }
        numProducers++
        println("started producing, # of consumers: " + numConsumers + " , number of producers: " + numProducers)
    }
    synchronized void stopProducing () {
        while (numProducers == numConsumers){
            wait()
        }
        numProducers--
        notifyAll()
        println("stopped producing, # of consumers: " + numConsumers + " , number of producers: " + numProducers)
    }
}
Grid g = new Grid()
10.times{
    Thread.start{
    g.startConsuming ();
    sleep(100)
    g.stopConsuming ();
}
}
10.times{
    Thread.start{
        g.startProducing ();
        sleep(100)
        g.stopProducing ();
    }
}




















//EXERCISE 6 


// import java.util.concurrent.locks.*;

// class Pizza {
//     private int s;
//     private int l;
//     private int waitings;
//     private int waitingl;
//     private final int counter_size;

//     final Lock lock = new ReentrantLock()
//     final Condition small = lock.newCondition()
//     final Condition largeOrTwoSmall = lock.newCondition()
//     final Condition enoughSpaceOnCounter = lock.newCondition()

//     Pizza(int size) {
//         s=0
//         l=0
//         waitings=0
//         waitingl=0
//         counter_size=size
//     }
//     private printState() {
//         println "small "+s+"; large "+l+"; want small "+waitings+"; want large "+waitingl
//     }
//     void purchaseSmallPizza() {
//         lock.lock()
//         try {
//             while (s==0) {
//                 waitings++
//                 printState()
//                 small.await()
//                 waitings--
//             }
//             s--
//             enoughSpaceOnCounter.signal()
//             printState()
//         } finally {
//             lock.unlock()
//         }

//     }
//     void purchaseLargePizza() {
//         lock.lock()
//         try {
//             while (l==0 && s<2) {
//                 waitingl++
//                 printState()
//                 largeOrTwoSmall.await()
//                 waitingl--
//             }
//             if (l>0) {
//                 l--
//                 enoughSpaceOnCounter.signal()    
//                 printState()
//             } else {
//                 s=s-2
//                 enoughSpaceOnCounter.signal()    
//                 enoughSpaceOnCounter.signal()    
//                 printState()
//             }    
//         } finally {
//             lock.unlock()
//         }
//     }
//     void bakeSmallPizza() {
//         lock.lock()
//         try {
//             while (s+l==counter_size) {
//                 enoughSpaceOnCounter.await()
//             }
//             s++
//             small.signal()
//             if (s>1) {
//                 largeOrTwoSmall.signal()
//             }
//             printState()
//         } finally {
//         lock.unlock()
//         }
//     }
//     void bakeLargePizza() {
//         lock.lock()
//         try {
//             while (s+l==counter_size) {
//                 println "counter full, sleeping..."
//                 enoughSpaceOnCounter.await()
//                 println "awake..."
//             }
//             l++
//             largeOrTwoSmall.signal()
//             printState()
//         } finally {
//             lock.unlock()
//         }
//     }
// }

// Pizza p = new Pizza(12)

// 100.times {
//     int id = it
//     Thread.start {
// if ((new Random()).nextInt(2)== 0) { 
//     p.purchaseSmallPizza()
// } else { 
//     p.purchaseLargePizza()
// }
//     }
// }

// 10.times {
//     Thread.start {
// 10.times {   
//    if ((new Random()).nextInt(2)== 0) {
// p.bakeSmallPizza()
//    } else {
// p.bakeLargePizza()
//    }
// }
//     }

// }
