class Solution {
    // return the first index where target <= nums[i+1].
    
    func find<T: Collection>(_ nums: T, _ target: Int) -> Int 
        where T.Element == Int, T.Index == Int 
    {
        if nums.count == 0 {
            return nums.startIndex
        }
        let midIndex = nums.startIndex + nums.count / 2
        let midValue = nums[midIndex]
        let leftHalf = nums.prefix(upTo: midIndex)
        let rightHalf = nums.suffix(from: midIndex + 1)
        if target < midValue {
            return find(leftHalf, target)
        } else if target > midValue {
            return find(rightHalf, target)
        }
        return midIndex
    }
    
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        return find(nums, target)
    }
}
