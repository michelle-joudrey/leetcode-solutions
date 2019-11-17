class Solution {
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        var numRemoved = 0
        for (i, n) in nums.enumerated() {
            if n == val {
                numRemoved += 1
                continue
            }
            nums[i - numRemoved] = n
        }
        return nums.count - numRemoved
    }
}
