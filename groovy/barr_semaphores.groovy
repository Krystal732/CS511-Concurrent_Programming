//Krystal Hong and Robert Brandl
import java.util.concurrent.Semaphore
// One-time use barrier
// Barrier size = N
// Total number of threads in the system = N

final int N=3
int t=0
Semaphore barrier = new Semaphore(0)
Semaphore mutex = new Semaphore(1)

Semaphore b2 = new Semaphore(0)
Semaphore m2 = new Semaphore(1)

c = new int[N]
N.times {
    int id = it
    Thread.start {
	while (true) {
	    // barrier arrival protocol
		// through.acquire()
	    mutex.acquire()
	    c[id]++
	    if (t<N) {
		t++
		if (t==N) {
			t =0 

		    N.times { barrier.release() }
		}
	    }
	    mutex.release()
	    // barrier
	    println id+" got to barrier. c="+c[id]
	    barrier.acquire() 

		// wait.acquire()

		// through.release();
		println id+" went through. c="+c[id]	
		m2.acquire()

		if (t<N){
			t++
			if (t==N){
			t =0
			N.times{b2.release()}
			}
		}
		m2.release()
		b2.acquire()
		
		}
    }
}
