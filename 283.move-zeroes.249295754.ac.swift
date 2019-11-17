class Solution {
    // find 0 with left pointer.
    // find non-zero with right pointer.
    // swap pointer values.
    
    // [0,1,0,3,12]
    //  i j
    // [1,0,0,3,12]
    //    i j
    // [1,0,0,3,12]
    //    i   j
    // [1,3,0,0,12]
    //    i   j
    // [1,3,0,0,12]
    //      i   j
    // [1,3,12,0,0]
    //      i   j
    func moveZeroes(_ nums: inout [Int]) {
        if nums.count < 2 {
            return
        }
        var i = 0
        
        while true {
            // Find the first zero
            while i != nums.endIndex && nums[i] != 0 {
                i += 1
            }
            if i == nums.endIndex {
                return
            }
            // Find the first non-zero
            var j = i + 1
            while j != nums.endIndex && nums[j] == 0 {
                j += 1
            }
            if j == nums.endIndex {
                return
            }
            // swap both.
            nums.swapAt(i, j)
        }
    }
}
