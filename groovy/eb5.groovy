import java.util.concurrent.Semaphore

//EXERCISE 1
//one Jets fan can enter for every two Patriots fans.

// Semaphore t = new Semaphore(0)
// Semaphore ok = new Semaphore(1)
// boolean late = false
// Thread.start{ //it got late
//     sleep(500)
//     late = true
//     t.release()
//     t.release()
// }
// 100.times {
//     j= Thread.start { // Jets
//         ok.acquire()
//         if(!late){
//             t.acquire()
//             t.acquire()
//         }
//         print "J" // fan goes into bar
//         ok.release()


//     }
// }
// 100.times{
//     p=Thread.start { // Patriots
//        print "P" // fan goes into bar
//        t.release()
//     }
// }














//EXERCISE 2
// n feeding lots, no more than n animals can feed at any given time
// feeding area can be used by both cats and dogs, it cannot be used by both at the same time 
// free from deadlock but not necessarily from starvation


// Semaphore lot = new Semaphore(5)
// Semaphore mutex = new Semaphore(1)
// int n = 0

// int dibs = 0 //cat = 1, dog = 2



// 20.times{
//     Thread.start { // Cat
//         mutex.acquire()
//         if(n==0){
//             dibs = 1
//         }
//         if(dibs == 1){
//                 n++
//             lot.acquire()
//             print("C")// access feeding lot
//             mutex.release()
//             // eat
//             mutex.acquire()
//             n--
//             print("K")
//             lot.release()
//             if(n==0){ //last cat
//                 // dibs.release()
//                 n = 0
//                 print("!")
//             }
//             // exit feeding lot

//         }
//         mutex.release()

        
//     }
// }
// 20.times {
//     Thread.start { // Dog
//         mutex.acquire()
//         if(n==0){
//             // dibs.acquire()
//             dibs = 2
//         }
//         if (dibs==2){
//             n++
//             lot.acquire()
//             print("D")// access feeding lot
//             mutex.release()
//             // eat
//             mutex.acquire()
//             n--
//             print "E"
//             lot.release()
//             if(n==0){ //last dog
//                 // dibs.release()
//                 n = 0
//                 print("!")

//             }

//         }
//         mutex.release()
        
//         // exit feeding lot
//     }
// }





















//EXERCISE 3
/*
East = 0
West = 1
capacity = N

goes to a coast and fills capacity
then go to other coast and waits for all passengers to get off
repeat
*/



// Declare semaphores here

// capacity = 5
// Semaphore[] c = [new Semaphore(0), new Semaphore(0)]
// Semaphore[] c_on = [new Semaphore(0), new Semaphore(0)]
// Semaphore[] c_off = [new Semaphore(0), new Semaphore(0)]
// Semaphore[] c_all_off = [new Semaphore(0), new Semaphore(0)]
// Thread.start { // Ferry
//     int coast=0;
//     while (true) {
//         // allow passengers on
//         capacity.times{c[coast].release()}

//         capacity.times{c_on[coast].acquire()}
//         // move to opposite coast
//         coast = 1-coast;
//         // wait for all passengers to get off
//         capacity.times{c_off[coast].release()}
//         capacity.times{c_all_off[coast].acquire()}
//         }
// }
// 50.times {
//     Thread.start { // Passenger on East coast
//         // get on
//         c[0].acquire()
//         println"East pass on"

//         c_on[0].release()
//         // get off at opposite coast
//         c_off[1].acquire()
//         println"East pass off"
//         c_all_off[1].release()
//     }
// }
// 50.times {
//     Thread.start { // Passenger on West coast
//         // get on
//         c[1].acquire()
//         println"West on"
//         c_on[1].release()
//         // get off at opposite coast
//         c_off[0].acquire()
//         println"West pass off"
//         c_all_off[0].release()
//     }
// }












//EXERCISE 4
/*
4 diff exercise machines
loaded w same weight discs, there are MAX_WEIGHTS of them
each client has a routine [(exercise, weigts), (), (), ...]
after finishing an exercise, client returns weights

*/





// MAX_WEIGHTS = 10;
// GYM_CAP = 50;

// // Declare semaphores here
// Semaphore capacity = new Semaphore(GYM_CAP) 
// Semaphore weights = new Semaphore(1) //mutex so only 1 client can change # of weights available
// Semaphore go  = new Semaphore(1) //mutex to go start exercise
// machine = [new Semaphore(1), new Semaphore(1), new Semaphore(1), new Semaphore(1)] // machine 
// m_available = [true, true, true, true] //check machine availability


// def make_routine(int no_exercises) { // returns a random routine
//     Random rand = new Random ();
//     int size = rand.nextInt(no_exercises);
//     def routine = [];
//     size.times {
//         routine.add(new Tuple(rand.nextInt (4),rand.nextInt(MAX_WEIGHTS )));
//     }
//     return routine;
// }

// 100. times {
//     int id = it;

//     Thread.start { // Client
//         def routine = make_routine (20); // random routine of 20 exercises
//         // enter gym
//         capacity.acquire()
//         routine.size (). times {
//             // complete exercise on machine
//             while(true){
//                 if(MAX_WEIGHTS >= routine[it][1] && m_available[it]){
//                     go.acquire() //go to machine and take weights
//                     m_available[it] = false
//                     MAX_WEIGHTS -= routine[it][1]
//                     machine[routine[it][0]].acquire() 
//                     go.release()
//                     break;

//                 }

//             }
            

//             println "$id is performing:"+routine[it][0] + "--"+ routine[it][1]; //do exercise

//             weights.acquire()//return weights
//             MAX_WEIGHTS += routine[it][1]
//             weights.release()
//             println "$id is leaving:"+routine[it][0] + "++"+ routine[it][1];
//             machine[routine[it][0]].release()//leave machine
//             m_available[it] = true
//         }
//         //leaves gym
//         capacity.release()
//     }   
// }












//EXERCISE 5 
/*
Machine can start working on car once the car is in place
car can only leave station once it knows the machine has finished its work
at most 1 car in each station
car cannot advance if occupied by another car
*/




// Semaphore station0 = new Semaphore(1) //mutex for the stations
// Semaphore station1 = new Semaphore(1)
// Semaphore station2 = new Semaphore(1)
// permToProcess = [new Semaphore(0), new Semaphore(0), new Semaphore(0)] // list of semaphores for machines
// doneProcessing = [new Semaphore(0), new Semaphore(0), new Semaphore(0)] // list of semaphores for machines

// 100. times {
//     int id = it
//     Thread.start { // Car
//         // Go to station 0
//         station0.acquire()
//         println("car"+ id+ "at s0")
//         permToProcess[0].release()
//         doneProcessing[0].acquire()
//         println("car"+ id+ "leaving s0")
//         station0.release()

//         // Move on to station 1
//         station1.acquire()
//         println("car"+id+ "at s1")
//         permToProcess[1].release()
//         doneProcessing[1].acquire()
//         println("car"+id+ "leaving s1")
//         station1.release()

//         // Move on to station 2
//         station2.acquire()
//         println("car"+ id+ "at s2")
//         permToProcess[2].release()
//         doneProcessing[2].acquire()
//         println("car"+ id+ "leaving s2")
//         station2.release()
//     }
// }

// 3.times {
//     int id = it; // iteration variable
//     Thread.start { // Machine at station id
//         while (true) {
//             // Wait for car to arrive
//             permToProcess[id].acquire()
//             // Process car when it has arrived
//             sleep(100)
//             doneProcessing[id].release()
//         }
//     }
// }














//EXERCISE 6
/*
Vehicles crossing between 2 endpoints (0, 1)
Multiple vehicles can cross at same time if in same direcion


*/


// Declare semaphores here
noOfCarsCrossing = [0,0]; // list of ints
Semaphore dibs = new Semaphore(1)
mutex = [new Semaphore(1, true), new Semaphore(1, true)]


r = new Random ();
100. times {
    int id = it; // iteration variable

    int myEndpoint = r.nextInt (2); // pick a random direction
    Thread.start { // Car
        // entry protocol
        mutex[myEndpoint].acquire()
        if(noOfCarsCrossing[myEndpoint] == 0){
            dibs.acquire()
        }
        noOfCarsCrossing[myEndpoint]++
        println id + " is crossing in direction " + myEndpoint + " current total num of cars crossing " + noOfCarsCrossing[myEndpoint]// cross crossing

        mutex[myEndpoint].release()


        mutex[myEndpoint].acquire()
        noOfCarsCrossing[myEndpoint]--
        if(noOfCarsCrossing[myEndpoint] == 0){
            dibs.release()
        }
        mutex[myEndpoint].release()

        // exit protocol
    }
}
















//EXERCISE 7

/*
2 tracks, 0: n->s     1: s->n
passenger trains:
can only stop at station if no other trains on same track


freight trains:
can be loaded if no train at station (neither tracks)
cant leave loading machine until done loading


*/





// Semaphore permToLoad = new Semaphore(0);
// Semaphore doneLoading = new Semaphore(0);
// Semaphore freight = new Semaphore(1)
// track =[new Semaphore(1, true), new Semaphore(1, true)]

// 100. times {
//     int id = it; // iteration variable
//     int dir = (new Random ()). nextInt (2);
//     Thread.start { // Freight Train travelling in direction dir
//         freight.acquire()
//         track[dir].acquire()
//         track[1-dir].acquire()
//         println "freight train " + id + " on track " + dir 
//         freight.release()
//         permToLoad.release()
//         //load
//         doneLoading.acquire()
//         println "freight train " + id + " leaving track " + dir 
//         track[dir].release()
//         track[1-dir].release()
//     }
// }
// 100. times {
//     int id = it; // iteration variable
//     int dir = (new Random ()). nextInt (2);
//         Thread.start { // PassengerTrain travelling in direction dir
//             track[dir].acquire()
//             println "passenger train " + id + " on track " + dir 
//             println "passenger train " + id + " leaving track " + dir 
//             track[dir].release()
//         }
// }
// Thread.start { // Loading Machine
//     while (true) {
//         permToLoad.acquire ();
//         println"loading freight train"// load freight train
//         doneLoading.release ();
//     }
// }

