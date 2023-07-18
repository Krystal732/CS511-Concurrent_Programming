
// Quiz 4
// 23 Feb 2023
// One-time-use barrier

// Name 1: Krystal Hong
// Name 2: Robert Brandl

class Barrier {
    int size;

    Barrier(int size) {
	this.size=size
    }


    public synchronized void reached(){
		size--
		while(size >0){
			wait()
		}
		notifyAll()
	}
    
}

Barrier b = new Barrier(3)

Thread.start {// P
    println "1"
    b.reached()
    println "a"
}

Thread.start {// Q
    println "2"
    b.reached()
    println "b"
}

Thread.start {// R
    println "3"
    b.reached()
    println "c"
}
