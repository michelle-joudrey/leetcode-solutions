class Solution {
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        guard !nums.isEmpty else {
            return 0
        }
        var count = 1
        var prevUnique = nums.first!
        let tail = nums.dropFirst()
        for n in tail {
            if n != prevUnique {
                prevUnique = n
                nums[count] = n
                count += 1
            }
        }
        return count
    }
}
