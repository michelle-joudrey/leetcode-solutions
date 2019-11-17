class Solution {
    // For 'Single Number I', XORing all the numbers together worked because
    // the XOR operator acts like addition, and each bit in the result acts like a counter,
    // so when the same bit appears 2k times, the result for that bit is zero.
    
    // To generalize this approach, we can keep a count of how many times each bit occurs,
    // and only keep those that occur 3k + 1 times.
    
    func singleNumber(_ nums: [Int]) -> Int {
        // Count how many times each bit occurs.
        // The least-significant bit is stored at index 0.
        var counters = [Int](repeating: 0, count: Int.bitWidth)
        for num in nums {
            var mask = 1
            for index in 0..<Int.bitWidth {
                if mask & num != 0 {
                    counters[index] += 1
                }
                mask = mask << 1
            }
        }
        // Each bit of the "lonely number" will appear 3k + 1 times, where k >= 0.
        var mask = 1
        var solution = 0
        for (index, counter) in counters.enumerated() {
            if counter % 3 == 1 {
                solution |= mask
            }
            mask = mask << 1
        }
        return solution
    }
}
