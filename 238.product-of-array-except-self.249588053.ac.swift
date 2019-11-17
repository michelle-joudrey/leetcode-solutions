class Solution {
    // 1, 1*2, 1*2*3, 1*2*3*4
    // 2*3*4, 1*3*4, 1*2*4, 1*2*3

    // Two arrays
    // 1, 1*2, 1*2*3, 1*2*3*4   L
    // 1*2*3*4, 2*3*4, 3*4, 4   R

    // Get product to the left of i, and product to the right, combine them.
    // If index doesn't exist, use "1"

    // i = 0, L[i-1] = 1,     R[i+1] = 2*3*4, p = 1*2*3*4 = 2*3*4
    // i = 1, L[i-1] = 1,     R[i+1] = 3*4, p = 1*3*4
    // i = 2, L[i-1] = 1*2,   R[i+1] = 4, p = 1*2*4
    // i = 3, L[i-1] = 1*2*3, R[i+1] = 1, p = 1*2*3
    
    // Can we do this in O(1) space?
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        var output = [Int](repeating: 0, count: nums.count)
        // First pass: Do left side multiplications.
        // (0,1): 1, (1,2): 1, (2, 3): 1*2, (3, 4): 1*2*3
        //              ^----------------^
        // Notice that digit gets used in the *next* iteration.
        var p = 1
        for (i, n) in nums.enumerated() {
            output[i] = p
            p *= n
        }
        
        // Second pass: Do right side multiplications
        // (0, 1): 4*3*2, (1, 2): 4*3, (2, 3): 4, (3, 4): 1
        //                                     ^------^
        // Note that digit gets used in the *next* iteration.
        p = 1
        for (i, n) in nums.enumerated().reversed() {
            output[i] *= p
            p *= n
        }        
        return output
    }
}
