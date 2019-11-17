class Solution {
    func subsets(_ nums: [Int]) -> [[Int]] {
        var sets = [[Int]()]
        // for each num, create sets with and without the item.
        for num in nums {
            sets += sets.map { $0 + [num] }
        }
        return sets
    }
}
