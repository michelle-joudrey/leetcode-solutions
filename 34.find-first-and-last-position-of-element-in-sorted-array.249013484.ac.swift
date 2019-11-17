class Solution {
    // 1. Find first index where nums[index] = target
    // 2. Find last index where nums[index] = target
    // Same as binary search, except that we continue recursing while
    // the left/right half contains the target.
    // We recurse left if looking for the first position, and right otherwise.
    
    func find<T: Collection>(_ target: Int, in nums: T, first: Bool) -> Int 
       where T.Element == Int, T.Index == Int
    {
        if nums.count == 0 {
            return -1
        }
        let midIndex = nums.startIndex + nums.count / 2
        let midValue = nums[midIndex]
        let leftHalf = nums[..<midIndex]
        let rightHalf = nums[(midIndex+1)...]
        if target < midValue {
            return find(target, in: leftHalf, first: first)
        } else if target > midValue {
            return find(target, in: rightHalf, first: first)
        }
        let nextIndex = first ? midIndex - 1 : midIndex + 1
        let nextHalf = first ? leftHalf : rightHalf
        let next = nums.indices.contains(nextIndex) ? nums[nextIndex] : nil
        if let next = next, next == midValue {
            return find(target, in: nextHalf, first: first)
        }
        return midIndex
    }
    
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        return [
            find(target, in: nums, first: true),
            find(target, in: nums, first: false)
        ]
    }
}
