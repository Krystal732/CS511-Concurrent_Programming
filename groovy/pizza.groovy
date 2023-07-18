import java.util.concurrent.locks.*


class Pizza {
    int lp = 0, sp = 0
    static final Lock lock = new ReentrantLock ();
    static final Condition pSP = lock.newCondition ();
    static final Condition LorS = lock.newCondition ();
    void purchaseSmallPizza () {
        // complete
        lock.lock()
        try{
            while(sp == 0){
                pSP.await()
            }
            printState("buy small")
            sp--
        } finally{
            lock.unlock()
        }
    }
    void purchaseLargePizza () {
        // complete
        lock.lock()
        try{
            while(lp == 0 & sp < 2){
                LorS.await()
            }
            if (lp>0){
                l--
                printState("buy large")
            }else{
                s = s-2
                printState("buy large")
            }


        }finally{
            lock.unlock()
        }

    }
    void bakeSmallPizza () {
        // complete
        lock.lock()
        try{
            sp++
            printState("baked small")
            pSP.signal()
            LorS.signal()
        } finally{
            lock.unlock()
        }
    }
    void bakeLargePizza () {
        // complete
        lock.lock()
        try{
            lp++
            printState("baked large")
            LorS.signal()
        }finally{
            lock.unlock()
        }
    }

    private printState(String prefix) {
        println prefix+" -> small "+sp+"; large "+lp
    }

}

Pizza p = new Pizza()


100.times { // 100 clients
    Thread.start {
    if ((new Random()).nextInt(2)== 0)
     { p.purchaseSmallPizza() }
     else 
     { p.purchaseLargePizza() }
    }
}

10.times { // 10 bakers
    Thread.start {
        10.times { // 10 pizzas each baker
            if ((new Random()).nextInt(2)== 0)
            { p.bakeSmallPizza() }
            else 
            { p.bakeLargePizza() }
        }
    }
}
