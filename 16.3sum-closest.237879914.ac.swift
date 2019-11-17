class Solution {
    func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
        if nums.count < 3 {
            return 0
        }
        // First, sort the numbers.
        let nums = nums.sorted()
        var closest: Int? = nil
        let n = nums.count
        
        // Three pointer approach
        // If the sum is too large, move 3rd pointer left,
        // If the sum is too small, move 2nd pointer right.
        // Else return the sum
        
        // Note that during each step, i and j will converge.
        // And we don't want i to be greater than n - 2.
        
        // Do this for every i.
        var i = 0, j = 1, k = n - 1
        while i != n - 2 {
            let sum = nums[i] + nums[j] + nums[k]
            let diff = abs(sum - target)
            if let _closest = closest {
                let closestDiff = abs(_closest - target)
                if diff < closestDiff {
                    closest = sum
                }
            } else {
                closest = sum
            }
            if sum < target {
                j += 1
            } else if sum > target {
                k -= 1
            } else { // ==
                return sum
            }
            if j == k {
                i += 1
                j = i + 1
                k = n - 1
            }
        }
        return closest ?? 0
    }
}
