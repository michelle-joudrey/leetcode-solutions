class Solution {
    func findMissingRanges(_ nums: [Int], _ lower: Int, _ upper: Int) -> [String] {
        var strs = [String]()
        
        func addRangeIfNecessary(_ range: ClosedRange<Int>) {
            if range.count <= 2 {
                return
            }
            var str = "\(range.lowerBound + 1)"
            if range.count > 3 {
                str += "->\(range.upperBound - 1)"
            }
            strs.append(str)
        }
        
        guard let first = nums.first else {
            addRangeIfNecessary(lower - 1...upper + 1)
            return strs
        }

        addRangeIfNecessary(min(lower - 1, first)...first)
        for (i, num) in nums.dropLast().enumerated() {
            addRangeIfNecessary(num...nums[i + 1])
        }
        addRangeIfNecessary(nums.last!...upper + 1)
        return strs
    }
}
