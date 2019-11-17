class Solution {
    func maxProduct2(_ nums: [Int], i: Int, prevMin: Int, prevMax: Int) -> (min: Int, max: Int) {
        if nums[i] < 0 {
            return (nums[i] * max(1, prevMax), nums[i] * min(1, prevMin))
        }
        return (nums[i] * min(1, prevMin), nums[i] * max(1, prevMax))
    }
    
    func maxProduct(_ nums: [Int]) -> Int {
        guard var maxProduct = nums.last else {
            return 0
        }
        var prevMax = maxProduct
        var prevMin = maxProduct
        for i in nums.indices.dropLast().reversed() {
            let (minP, maxP) = maxProduct2(nums, i: i, prevMin: prevMin, prevMax: prevMax)
            maxProduct = max(maxProduct, max(minP, maxP))
            prevMin = minP
            prevMax = maxP
        }
        return maxProduct
    }
}
