import java.util.concurrent.Semaphore

// EXERCISE 1
// A printed beore F and F printed before C
Semaphore a = new Semaphore (0)
Semaphore b = new Semaphore (0)
Thread.start { // P
    print("A");
    a.release()
    print("B");
    b.acquire()
    print("C");
}
Thread.start { // Q
    print("E");
    a.acquire()
    print("F");
    b.release()
    print("G");
}


// //EXERCISE 2
// Semaphore a = new Semaphore (0)
// Semaphore b = new Semaphore (0)
// //LASER
// Thread.start { // P
//     b.acquire()
//     print("A")
//     print("S")
//     a.release()
//     }
    
// Thread.start { // Q
//     print("L")
//     b.release()
//     a.acquire()
//     print("E")
//     print("R")
//     }

//EXERCISE 3
// R I O OK OK OK

// Semaphore i = new Semaphore (0)
// Semaphore o = new Semaphore (0)
// Semaphore ok = new Semaphore(0)

// Thread.start { // P
//     print("R");
//     i.release()
//     ok.acquire()
//     print("OK");
//     ok.release()
// }
// Thread.start { // Q
//     i.acquire()
//     print("I");
//     o.release()
//     ok.acquire()
//     print("OK");
//     ok.release()
// }
// Thread.start { // R
//     o.acquire()
//     print("O");
//     ok.release()
//     print("OK");
// }


// EXERCISE 4
//What are the possible final values for x?: 0, 1, 3
//Is it possible to use semaphores to restrict the set of possible values of x to be just two possible values?

// Semaphore add = new Semaphore(0)

// int y = 0, z = 0; 
// Thread.start { // P
//     int x;
//     add.acquire()
//     x = y + z;
// }

// Thread.start { // Q
//     y = 1;
//     add.release()
//     z = 2;
// }


//EXERCISE 5
// F <= A       H <= E       C <= G

// Semaphore f = new Semaphore(0)
// Semaphore h = new Semaphore(0)
// Semaphore c = new Semaphore(0)

// Thread.start {
//     while (true) {
//         print("A");
//         f.release()
//         print("B");
//         c.acquire()
//         print("C");
//         print("D");
//     }
// }
// Thread.start {
//     while (true) {
//         print("E");
//         h.release()
//         f.acquire()
//         print("F");
//         print("G");
//         c.release()
//     }
// }

// Thread.start {
//     while (true) {
//         h.acquire()
//         print("H");
//         print("I");
//     }
// }


//EXERCISE 6 
//We wish operation opCof C be executed only after A has executed opA and B has executed opB

// Semaphore a = new Semaphore(0)
// Semaphore b = new Semaphore(0)

// Thread.start { // A
//     opA;
//     a.release()
// }
// Thread.start { // B
//     opB;
//     b.release()
// }
// Thread.start { // C
//     a.acquire()
//     b.acquire()
//     opC;
// }


//EXERCISE 7
//Use semaphores to guaranteee that at all times the number of A’s and B’s differs at most in 1.

//Modify the solution so that the only possible output is ABABABABAB...

// Semaphore a = new Semaphore(1)
// Semaphore b = new Semaphore(1) //change to 0 for sol 2

// Thread.start { // P
//     while (true) {
//         a.acquire()
//         print("A");
//         b.release()
//     }
// }

// Thread.start { // Q
//     while (true) {
//         b.acquire()
//         print("B");
//         a.release()
//     }
// }

//EXERCISE 8
// calculate the value n2 which is the sum of the first n + 1 odd numbers. 
//The processes share the variables n and n2 which are initialized as follows: n = 50 and n2 = 0. 
//The expected result is 2601 since the sum of the first 51 odd numbers is 2601

// Semaphore added = new Semaphore(0)
// Semaphore subbed = new Semaphore(1)

// int n2=0
// int n=50
// P = Thread.start {
//     while (n > 0) {
//         added.acquire()
//         n = n-1
//         subbed.release()
//     }
// }
// Thread.start {
//     while (true) {
//         subbed.acquire()
//         n2 = n2 + 2*n + 1
//         added.release()
//     }
// }
// P.join()
// // if your code prints 2600 you might need an extra line of code here ...
// print(n2)



// //aaabaaabaaab...

// Semaphore a = new Semaphore (3)
// Semaphore b = new Semaphore (0)

// Thread.start { //P
//     while (true) {
//         a.acquire()
//         print "a"
//         b.release()
//     }
// }

// Thread.start { //Q
//     while (true) {
//         b.acquire()
//         b.acquire()
//         b.acquire()
//         print "b"
//         a.release()
//         a.release()
//         a.release()
//     }
// }



//aaa(b or c)aaa(b+c)aaa(b+c)

Semaphore a = new Semaphore (3)
Semaphore b = new Semaphore (0)
Semaphore c = new Semaphore (1)
Thread.start { //P
    while (true) {
        a.acquire()
        print "a"
        b.release()
    }
}

Thread.start { //Q
    while (true) {
        c.acquire()
        b.acquire()
        b.acquire()
        b.acquire()
        c.release()
        print "b"
        a.release()
        a.release()
        a.release()
    }
}

Thread.start { //R
    while (true) {
        c.acquire()
        b.acquire()
        b.acquire()
        b.acquire()
        c.release()
        print "c"
        a.release()
        a.release()
        a.release()
    }
}











