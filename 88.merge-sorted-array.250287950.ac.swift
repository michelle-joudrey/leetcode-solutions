class Solution {
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var i = 0
        var m = m
        for num in nums2 {
            // insert n into nums1.
            // It's safe to assume that we have space to do so.
            while i < m && nums1[i] < num {
                i += 1
            }
            // if we reached an empty space, just insert the item there.
            if i == m {
                nums1[i] = num
                i += 1
                m += 1
                continue
            }
            
            // Move all the elements from i to the end (except the last) back one.
            for j in (i..<nums1.indices.last!).reversed() {
                nums1[j + 1] = nums1[j]
            }
            // Insert the elment at i.
            nums1[i] = num
            m += 1
        }
    }
}
