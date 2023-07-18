public class Swapper implements Runnable {
    private int offset;
    private Interval interval;
    private String content;
    private char[] buffer;

    public Swapper(Interval interval, String content, char[] buffer, int offset) {
        this.offset = offset;
        this.interval = interval;
        this.content = content;
        this.buffer = buffer;
    }

    @Override
    public void run() {
        String subString = content.substring(interval.getX(), interval.getY()); //get substring between the interval
        for (int i = 0; i < subString.length(); i++){ //put each char in the substring into the buffer starting at offset
            char c = subString.charAt(i);        
            buffer[offset] = c;
            offset++;
        }
    }
}