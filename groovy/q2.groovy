//Robert Brandl, Krystal Hong


/*
Quiz 2 - 9 Feb 2023

You may not add print statements nor additional semaphores.
Add ONLY acquire and release operations to the following code so that every expression in the following set of regular expresions has an interleaving that can print it:

abc*abc*abc*abc*abc*abc*....

Note: c* stands for zero or more c's

*/

import java.util.concurrent.Semaphore
Semaphore a = new Semaphore(1)
Semaphore b = new Semaphore(0)
Semaphore c = new Semaphore(0)

Thread.start { // P
    while (true) {
    a.acquire()
	print("a")
    b.release()
    }
}
Thread.start { // Q 
    while (true) {
    b.acquire()
	print("b")
    c.release()
    }
}
Thread.start { // R
    while (true) {
    c.acquire()
	print("c")
    c.release()
    
    }
}
Thread.start { // S
    while (true) {
        c.acquire()
        a.release()
    }
}
