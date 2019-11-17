class Solution {
    // assumes nums.count >= 2 and nums pre-sorted
    func twoSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        guard nums.count >= 2 else {
            fatalError()
        }
        var solutions = [[Int]]()
        var i = 0, j = nums.count - 1
        while i != j {
            let a = nums[i]
            let b = nums[j]
            let sum = a + b
            if sum > target {
                repeat { j -= 1 } while nums[j] == b && i != j
                continue
            }
            if sum == target {
                solutions.append([a, b])
            }
            repeat { i += 1 } while nums[i] == a && i != j
        }
        return solutions
    }
    
    // assumes nums are presorted
    func kSum(_ nums: [Int], _ target: Int, _ k: Int) -> [[Int]] {
        guard nums.count >= k else {
            return [[Int]]()
        }
        if k == 2 { // base case
            return twoSum(nums, target)
        }
        // recursive case
        var solutions = [[Int]]()
        var i = 0
        while i != nums.count - (k - 1) {
            let num = nums[i]
            let target = target - nums[i]
            let tail = Array(nums.suffix(from: i + 1))
            let sols = kSum(tail, target, k - 1).map { [num] + $0 }
            solutions += sols
            repeat { i += 1 } while i != nums.count - (k - 1) && nums[i] == num
        }
        return solutions
    }
    
    func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        return kSum(nums.sorted(), target, 4)
    }
}
