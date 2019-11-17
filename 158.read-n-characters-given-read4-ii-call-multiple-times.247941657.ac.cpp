// Forward declaration of the read4 API.
int read4(char *buf);

class Solution {
    std::queue<char> chars;
public:
    /**
     * @param buf Destination buffer
     * @param n   Number of characters to read
     * @return    The number of actual characters read
     */
    int read(char *buf, int n) {
        // If vector.count < n, we need to call read4() and insert those elements into our vector, until it contains at least n elements.
        // pop n elements from the front of our vector and write those to the buffer.
        while (chars.size() < n) {
            char readChars[4];
            int numRead = read4(readChars);
            for (int i = 0; i < numRead; i++) {
                char readChar = readChars[i];
                chars.push(readChar);
            }
            if (numRead < 4) {
                break;
            }
        }
        int numAvailable = min((int)chars.size(), n);
        for (int i = 0; i < numAvailable; i++) {
            buf[i] = chars.front();
            chars.pop();
        }
        return numAvailable;
    }
};
