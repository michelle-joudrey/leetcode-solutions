class Solution {    
    func threeSum(_ nums: [Int]) -> [[Int]] {
        if nums.count < 3 {
            return [[Int]]()
        }
        // Key points:
        // 1. Must avoid duplicates
        // 2. a + b = -c
        let nums = nums.sorted()
        // 3-pointer approach:
        // - Sort the array
        // 1st pointer on current sum
        // 2nd pointer just right of current sum
        // 3rd pointer at the end
        // While 2nd pointer != 3rd pointer, move closer
        // If A2 + A3 < sum, we need to move A2 to the right, increasing sum (since array is sorted)
        // if A2 + A3 > sum, we need to move A1 to the left, decreasing the sum
        // if A2 + A3 == sum, we add this to our list and move A2 along until its value changes (this is how we avoid duplicates)
        var solutions = [[Int]]()
        let lastIndex = nums.indices.last!
        let endIndex = nums.endIndex
        
        var i = 0
        var j = 1
        var k = lastIndex
        
        while i != lastIndex - 1 {
            let sum = -nums[i]
            let a = nums[j]
            let b = nums[k]
            if a + b < sum {
                j += 1
            } else if a + b > sum {
                k -= 1
            } else { // =
                solutions.append([-sum, a, b])
                // Move j to the next different element, or k (whichever comes first)
                while j != k && nums[j] == a {
                    j += 1
                }
            }
            if j == k {
                while i != lastIndex - 1 && nums[i] == -sum {
                    i += 1
                }
                j = i + 1
                k = lastIndex
            }
        }
        return solutions
    }
}
