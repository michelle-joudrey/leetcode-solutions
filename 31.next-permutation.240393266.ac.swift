class Solution {
    func nextPermutation(_ nums: inout [Int]) {
        guard let swapLhsIndex = nums.indices.dropLast().last(where: { i in
            nums[i] < nums[i + 1]
        }) else {
            // The elements are in the last permutation (in reverse order)
            // To obtain the first permutation, simply reverse the elements.
            nums.reverse()
            return
        }
        // There will be at least one element greater than the left element to swap.
        let swapRhsIndex = nums.lastIndex { $0 > nums[swapLhsIndex] }!
        nums.swapAt(swapLhsIndex, swapRhsIndex)
        // reverse the elements from swapLhsIndex + 1 to the end.
        nums[(swapLhsIndex + 1)...].reverse()
    }
}
