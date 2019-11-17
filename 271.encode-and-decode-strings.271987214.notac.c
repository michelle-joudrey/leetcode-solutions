/** Encodes a list of strings to a single string */
char* encode(char** strs, int strsSize) {
    // For streaming strings over the network...
    // You could encode the strings as such:
    // struct {
    //    size: Int
    //    bytes: char *
    // }
    // This way, you know how many chars you need to queue up 
    // while waiting for additional strings.
    // 
}

/**
 * Decodes a single string to a list of strings.
 *
 * Return an array of size *returnSize.
 * Note: The returned array must be malloced, assume caller calls free().
 */
char** decode(char* s, int* returnSize) {
    
}

// Your functions will be called as such:
// char* s = encode(strs, strsSize);
// decode(s, &returnSize);
