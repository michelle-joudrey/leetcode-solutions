class Solution {
    func permute(_ nums: [Int]) -> [[Int]] {
        // In general:
        // 1. Find the last index i where Ai < Ai+1
        // 2. Find the last index j where Aj > Ai
        // 3. Swap Ai with Aj
        // 3. Sort Ai+1... e.g. by reversing the elements
        
        // Example case:
        // [3,5,4,2,1]
        // [4,1,2,3,5]
        
        // [3,5,4,2,1]
        // i = 0
        // j = 2
        // [4,5,3,2,1]
        // [4,1,2,3,5]
        
        // Edge case:
        // [2, 1]

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
