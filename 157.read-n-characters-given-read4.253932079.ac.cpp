// Forward declaration of the read4 API.
int read4(char *buf);

class Solution {
public:
    /**
     * @param buf Destination buffer
     * @param n   Number of characters to read
     * @return    The number of actual characters read
     */
    char extra[4];
    int numExtraChars = 0;
    int extraStart = 0;
    
    int read(char *buf, int n) {
        int numCharsWritten = 0;
        // We'll have an "extra" char array to hold reads, because we
        // don't know if buf can even hold 4 chars... we wouldn't want to cause a buffer overflow.
        
        while (numCharsWritten != n) {
            // If extra contains chars, we should move those chars to buf (as long as numMoved < n)
            // abcd efgh ijk
            int numCharsToWrite = min(n - numCharsWritten, numExtraChars);
            for (int i = 0; i < numCharsToWrite; i++) {
                buf[numCharsWritten] = extra[extraStart + i];
                numCharsWritten++;
            }
            // Keep track of where in extra we should continue next time (e.g. index 3)
            extraStart += numCharsToWrite;
            numExtraChars -= numCharsToWrite;
            
            if (numCharsWritten == n) {
                return n;
            }
            // If additional chars are needed, "reload" extra with 4 more chars.            
            extraStart = 0;
            numExtraChars = read4(extra);
            if (numExtraChars == 0) {
                return numCharsWritten;
            }
        }
        return 0;
    }
};
