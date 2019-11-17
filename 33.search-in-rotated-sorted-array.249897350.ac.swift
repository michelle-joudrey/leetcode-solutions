class Solution {
    // 1. startIndex = i s.t. A[i-1] > A[i]
    //    a. edge case: sorted array
    //    b. edge case: single element array
    // 2. n = A.count
    // 3. Do binary search
    //    a. midIndex = (startIndex + n / 2) % n
    //    b. if target == A[midIndex], return midIndex
    //    c. if target < A[midIndex], recurse left side
    //       n = n / 2
    //    d. else recurse right side
    //       n = n / 2
    //       startIndex = midIndex
    
    func search(_ nums: [Int], _ target: Int) -> Int {
        let minIndex = nums.indices.dropFirst().first { nums[$0 - 1] > nums[$0] }
        if let startIndex = minIndex {
            // search([4,5,6,7,0,1,2], 3, 4, 7)
            return search(nums, target, startIndex, nums.count)
        }
        return search(nums, target, 0, nums.count)
    }
    
    // # elements on left side (middle = n / 2)
    // [1,2, 3,4], midIndex = 2, left = n / 2 = 4 / 2 = 2
    // [1,2,3,4,5], midIndex = 2, left = n / 2 = 5 / 2 = 2
    
    // # elements on right side
    // 1. (n - 1) / 2 = 3 / 2 = 1
    // 2. (n - 1) / 2 = 4 / 2 = 2
    
    func search(_ nums: [Int], _ target: Int, _ startIndex: Int, _ n: Int) -> Int {
        if n == 0 {
            return -1
        }
        let midIndex = (startIndex + n / 2) % nums.count
        let midValue = nums[midIndex]
        if target < midValue {
            return search(nums, target, startIndex, n / 2)
        }
        else if target > midValue {
            return search(nums, target, midIndex + 1, (n - 1) / 2)
        }
        return midIndex
    }
}
