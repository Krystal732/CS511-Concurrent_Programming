import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.concurrent.CountDownLatch;

public class Customer implements Runnable {
    private Bakery bakery;
    private Random rnd;
    private List<BreadType> shoppingCart;
    private int shopTime;
    private int checkoutTime;
    private CountDownLatch doneSignal;
    
    /**
     * Initialize a customer object and randomize its shopping cart
     */
    public Customer(Bakery bakery, CountDownLatch l) {
        // TODO

        this.rnd = new Random();

        this.bakery = bakery; 
        shopTime = rnd.nextInt(123)+50;
        checkoutTime = rnd.nextInt(123)+50;
        doneSignal = l;
        shoppingCart = new ArrayList<BreadType>();

        this.fillShoppingCart();
    }

    /**
     * Run tasks for the customer
     */
    public void run() {
        // TODO
        // System.out.println("hi");
        try { //sleep for shoptime
            Thread.sleep(this.shopTime);
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }
        // System.out.println("hey");
        // System.out.println(shoppingCart.get(0));
        for (BreadType bread : shoppingCart) { //take bread 
            if(bread == BreadType.RYE){
                try {
                    bakery.rye.acquire();
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                bakery.takeBread(BreadType.RYE);
                bakery.rye.release();

            }
            else if(bread == BreadType.SOURDOUGH){
                try {
                    bakery.sour.acquire();
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                bakery.takeBread(BreadType.SOURDOUGH);
                bakery.sour.release();
                
            }
            else{
                try {
                    bakery.wonder.acquire();
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                bakery.takeBread(BreadType.WONDER);
                bakery.wonder.release();
                
            }
        }
        
        try { //sleep for checkout time
            Thread.sleep(this.checkoutTime);
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }

        try {
            bakery.cashier.acquire();
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        

        bakery.addSales(getItemsValue()); //add to sales

        
        bakery.cashier.release();


        doneSignal.countDown();
        
    }

    /**
     * Return a string representation of the customer
     */
     
    public String toString() {
        return "Customer " + hashCode() + ": shoppingCart=" + Arrays.toString(shoppingCart.toArray()) + ", shopTime=" + shopTime + ", checkoutTime=" + checkoutTime;
    }

    /**
     * Add a bread item to the customer's shopping cart
     */


    private boolean addItem(BreadType bread) {
        // do not allow more than 3 items, chooseItems() does not call more than 3 times
        if (shoppingCart.size() >= 3) {
            return false;
        }
        shoppingCart.add(bread);
        return true;
    }

    /**
     * Fill the customer's shopping cart with 1 to 3 random breads
     */
    private void fillShoppingCart() {
        int itemCnt = 1 + this.rnd.nextInt(3);
        while (itemCnt > 0) {
            addItem(BreadType.values()[rnd.nextInt(BreadType.values().length)]);
            itemCnt--;
        }
    }

    /**
     * Calculate the total value of the items in the customer's shopping cart
     */
    private float getItemsValue() {
        float value = 0;
        for (BreadType bread : shoppingCart) {
            value += bread.getPrice();
        }
        return value;
    }
}
