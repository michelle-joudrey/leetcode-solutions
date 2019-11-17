class Solution {
    func maxArea(_ height: [Int]) -> Int {
        var maxArea = 0
        var i = 0
        var j = height.count - 1 // N >= 2.
        while i != j {
            let area = min(height[i], height[j]) * (j - i)
            maxArea = max(maxArea, area)
            if height[i] <= height[j] {
                i += 1
            } else {
                j -= 1
            }
        }
        return maxArea
    }
}
