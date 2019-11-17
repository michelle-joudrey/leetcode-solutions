class Solution {
    // notes: one of the arrays can be empty, but not both
    // complexity should be O(log(m+n))
    
    // get the element left of the partition at p
    @inline(__always) func leftOf(partition: Int, in array: [Int]) -> Int? {
        return partition == 0 ? nil : array[partition - 1]
    }
    
    @inline(__always) func rightOf(partition: Int, in array: [Int]) -> Int? {
        return partition == array.count ? nil : array[partition]
    }
    
    @inline(__always) func avg(_ lhs: Double, _ rhs: Double) -> Double {
        return (lhs + rhs) / 2.0
    }
    
    // It takes much more code to check for nil on both of these. 
    // Going to skip that for now, making some assumptions. 
    
    @inline(__always) func mino(_ lhs: Int?, _ rhs: Int?) -> Double {
        return Double(min(lhs ?? Int.max, rhs ?? Int.max))
    }
    
    @inline(__always) func maxo(_ lhs: Int?, _ rhs: Int?) -> Double {
        return Double(max(lhs ?? Int.min, rhs ?? Int.min))
    }
    
    // median here is defined as the middle value in (a + b).sorted()
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        // naive solution is to merge the arrays O(n + m)
        
        // The median has (n + 1) / 2 elements left of it.
        
        // An O(log(min(n + m))) solution is as follows: 
        
        // Find partitions pA and pB such that 
        // the number of elements left of pA
        // added with the number of elements left of pB
        // equals (n + 1) / 2 (half of the total elements).
        // and
        // Ord(pA, pB) = l(pA) <= r(pB) && l(pB) <= r(pA) is true.
        // where l(p) is the element left of partition p
        // and r(p) is the partition to the right of partition p.
        
        // Implementation
        // --
        
        // Initialization:
        // Set A to be the smaller array and B to the larger array.
        let A = nums1.count < nums2.count ? nums1 : nums2
        let B = nums1.count < nums2.count ? nums2 : nums1
        // Put pA at the middle of A, and pB at the appropriate position
        // so that pA + pB = (n + 1) / 2.
        // The number of elements in the left group in the 2 groups of elements.
        let N = A.count + B.count
        var pA = A.count / 2
        var pB = (N / 2) - pA
        var numLeft = pA
        var numRight = A.count - pA
        
        // Iterative step:
        while true {            
            // If l(pA) > r(pB), we need to move pA left.
            // > Move pA to the middle of the subarray left of pA, move pB
            // > so that pA + pB = (n + 1) / 2
            // > repeat iterative step
            let lPa = leftOf(partition: pA, in: A)
            let rPb = rightOf(partition: pB, in: B)
            if let _lPa = lPa, let _rPb = rPb, _lPa > _rPb {
                let offset = (numLeft + 1) / 2
                numRight = offset
                numLeft -= numRight
                pA -= offset
                pB += offset
                continue
            }

            // If l(pB) > r(pA), we need to move pB right.
            // > Move pA to the middle of the subarray right of pA, move pB
            // > so that pA + pB = (n + 1) / 2
            // > repeat iterative step
            let lPb = leftOf(partition: pB, in: B)
            let rPa = rightOf(partition: pA, in: A)
            if let _lPb = lPb, let _rPa = rPa, _lPb > _rPa {
                let offset = (numRight + 1) / 2
                numLeft = offset
                numRight -= numLeft
                pA += offset
                pB -= offset
                continue
            }
            
            // Base case:
            // If Ord(pA, pB) is true
            // > If n is odd, return min(r(pA), r(pB))
            // > else return avg(max(l(pA), l(pB)), min(r(pA), r(pB)))
            // (implemented at the end)        
            
            // odd
            if N % 2 == 1 {
                return mino(rPa, rPb)
            }
            // even
            return avg(maxo(lPa, lPb), mino(rPa, rPb))
        }
    }
}
