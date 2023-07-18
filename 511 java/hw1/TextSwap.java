/*
    Krystal Hong
    I pledge my honor that I have abided by the Stevens Honor System.
*/
import java.io.*;
import java.util.*;


public class TextSwap {

    private static String readFile(String filename, int chunkSize) throws Exception {
        String line;
        StringBuilder buffer = new StringBuilder();
        File file = new File(filename);
	// The "-1" below is because of this:
	// https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline
    if (((file.length() - 1) / chunkSize) > 26)
        {throw new Exception("Chunk size too small"); };
	if ((file.length()-1) % chunkSize!=0)
	    { throw new Exception("File size must be a multiple of the chunk size"); };
        BufferedReader br = new BufferedReader(new FileReader(file));
        while ((line = br.readLine()) != null){
            buffer.append(line);
        }
        br.close();
        return buffer.toString();
    }
    private static Interval[] getIntervals(int numChunks, int chunkSize) {
        // TODO: Implement me!
        Interval[] chunks = new Interval[numChunks];
        int count = 0;
        for (int i = 0; i < numChunks; i++) { //loop through numchunks and add intervals to array
            chunks[i] = new Interval(count, count + chunkSize);
            count += chunkSize;            
        }
        return chunks;
    }

    private static List<Character> getLabels(int numChunks) {
        Scanner scanner = new Scanner(System.in);
        List<Character> labels = new ArrayList<Character>();
        int endChar = numChunks == 0 ? 'a' : 'a' + numChunks - 1;
        System.out.printf("Input %d character(s) (\'%c\' - \'%c\') for the pattern.\n", numChunks, 'a', endChar);
        for (int i = 0; i < numChunks; i++) {
            labels.add(scanner.next().charAt(0));
        }
        scanner.close();
        // System.out.println(labels);
        return labels;
    }

    private static char[] runSwapper(String content, int chunkSize, int numChunks) {
        List<Character> labels = getLabels(numChunks);
        Interval[] intervals = getIntervals(numChunks, chunkSize);
        // TODO: Order the intervals properly, then run the Swapper instances.
        char[] buffer = new char[chunkSize * numChunks]; //buffer to store return string
        
        for (int i = 0; i < labels.size(); i++) { 
            int order = labels.get(i) - 'a'; //subtract 'a' to get the int of what order it should be in
            Swapper t = new Swapper(intervals[order], content, buffer, i * chunkSize); //create threads
            t.run();
        }
        return buffer;
        
    }

    private static void writeToFile(String contents, int chunkSize, int numChunks) throws Exception {
        char[] buff = runSwapper(contents, chunkSize, contents.length() / chunkSize);
        PrintWriter writer = new PrintWriter("output.txt", "UTF-8");
        writer.print(buff);
        writer.close();
    }

     public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Usage: java TextSwap <chunk size> <filename>");
            return;
        }
        String contents = "";
        int chunkSize = Integer.parseInt(args[0]);
        
        try {
            contents = readFile(args[1],chunkSize);
            writeToFile(contents, chunkSize, contents.length() / chunkSize);

        } catch (Exception e) {
            // System.out.println("Error with IO.");
            System.out.println(e);
            return;
        }
        
    }
}
