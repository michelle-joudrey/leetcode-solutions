class Solution {
    // For a particular subarray, you can think of it having
    // elements before it that form a prefix of the original array,
    // and elements after it that form a suffix of the original array.
    
    // The sum of a subarray is then given by
    // sum(array) - sum(prefix) - sum(suffix)
    
    // If we keep a running sum, then the formula becomes:
    // running_sum - sum(prefix)
    
    // Given a running sum, and a target subarray sum, 
    // we can try to find a prefix sum that satisfies this equation.
    // i.e. sum(prefix) = running_sum - k
    
    // This means that as long as we keep track of the sum of every prefix
    // we've seen so far, we can solve this problem.
    
    func subarraySum(_ nums: [Int], _ k: Int) -> Int {
        // A subarray could exist s.t. sum(subArray) = k,
        // and subArray is a prefix of the array.
        
        // In this case, the running sum will equal k,
        // meaning that we'll need to find zero in our dictionary.
        // Put zero in our dictionary just for this case.
        var prefixSums = [0: 1]
        var count = 0
        var sum = 0
        for num in nums {
            sum += num
            if let frequency = prefixSums[sum - k] {
                count += frequency
            }
            prefixSums[sum, default: 0] += 1
        }
        return count
    }
}
