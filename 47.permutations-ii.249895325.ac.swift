class Solution {
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        // In general:
        // 1. Find the last index i where Ai < Ai+1
        // 2. Find the last index j where Aj > Ai
        // 3. Swap Ai with Aj
        // 3. Sort Ai+1... e.g. by reversing the elements
        
        // Example case:
        // [1,1,2]
        // i = 1
        // j = 2
        // [1,2,1]
        
        // [1,2,1]
        // i = 0, j = 1
        // [2,1,1]
        
        // [2,1,1]
        // i = nil. Done.

        var nums = nums.sorted()
        var permutations = [nums]
        let indices = nums.indices.dropLast().reversed()
        let indices2 = nums.indices.reversed()
        
        // Assuming that the input is sorted.
        while let i = indices.first(where: { nums[$0] < nums[$0+1] })  {
            let j = indices2.first { nums[$0] > nums[i] }!
            nums.swapAt(i, j)
            nums[(i+1)...].reverse()
            permutations.append(nums)
        }
        return permutations        
    }
}
