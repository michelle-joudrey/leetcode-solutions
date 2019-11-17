// What are the best indices to split nums at such that
// the maximum of subArray.reduce(0, +) is minimized?

// We can split n - 1 times. Can split at 1..<n.
// e.g. 1,2,3,4 -> [[1], [2, 3, 4]] (split at index 1).

// Note: If k = n - 1, only one split set.

// brute force: try every possible set of splits.
// Runtime:
// for s1 in 1..<(n - k - 1)
//    for s2 in s1+1..<(n-k-2)
//       for s3 in s2+1..<(n-k-3)
//          ...
//          for sk in n-k..<n
// (n - k) * (n - k - 1) * ... * 1
// O((n - k)^k)

// input constraints:
// 1 ≤ n ≤ 1000
// 1 ≤ k ≤ min(50, n)
// 1000^50 = 1e+150.
// We obviously can't generate every possible split b/c that would be way too slow.

// DP approach:
// Reuse work on the same level of the solution tree.
// e.g. for a tree of indices:
// [0],       [1],    [2]
// [1, 2, 3], [2, 3], [3]
// ...
// Skip calculation of splitArray for index 2, 3, and 3 since we already computed those.
// To reuse work on the same level, we need to perform DFS to find the best path, then memoize that.
// By reusing work, we never will have more than n paths recursed per level.
// There will be m levels.
// The total time will then by O(n * m)

class Solution {
    // m here refers to the number of splits to make.
    func DFS(_ nums: inout [Int], _ m: Int, _ start: Int = 0, _ memo: inout [[Int?]], _ sums: inout [Int]) -> Int? {
        if m == 0 {
            return sums[start]
        }
        if let answer = memo[m][start] {
            return answer
        }
        var minMax: Int?
        var sumUpToChild = nums[start]
        let end = nums.count - m + 1
        for j in start + 1..<end {
            guard let child = DFS(&nums, m - 1, j, &memo, &sums) else {
                continue
            }
            let maxSum = max(child, sumUpToChild)
            minMax = minMax.map { min($0, maxSum) } ?? maxSum
            sumUpToChild += nums[j]
        }
        memo[m][start] = minMax
        return minMax
    }
    
    func splitArray(_ nums: [Int], _ m: Int) -> Int {
        var memo = [[Int?]](repeating: [Int?](repeating: nil, count: nums.count), count: m)
        var sums = [Int](repeating: 0, count: nums.count)
        var nums = nums
        var sum = 0
        for i in nums.indices.reversed() {
            sum += nums[i]
            sums[i] = sum
        }
        return DFS(&nums, m - 1, 0, &memo, &sums) ?? 0
    }
}
