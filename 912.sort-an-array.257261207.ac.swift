class Solution {
    // Pick A[lo] as the pivot.
    // Partition the elements so that the elements less than the pivot come
    // before the elements greater than the pivot.
    // Assumes that lo and hi are valid indices.
    func partition(_ nums: inout [Int], lo: Int, hi: Int) -> Int {
        let pivot = nums[lo]
        var left = lo, right = hi
        while left < right {
            // Move left until it finds an element greater than the pivot, or reaches `hi`.
            while nums[left] <= pivot && left != hi {
                left += 1
            }
            // Move right until it finds an elements less than the pivot, or reaches `lo`.
            while nums[right] >= pivot && right != lo {
                right -= 1
            }
            if left < right {
                nums.swapAt(left, right)
            }
        }
        // `right` will now point to the pivot's final position.
        // `lo` will be pointing to the pivot element.
        // Swap the pivot into its final position.
        nums.swapAt(lo, right)
        return right
    }
    
    func quicksort(_ nums: inout [Int], lo: Int, hi: Int) {
        if lo == hi {
            return
        }
        let pivotIndex = partition(&nums, lo: lo, hi: hi)
        // Are there elements before the pivot to sort?
        if pivotIndex != lo {
            quicksort(&nums, lo: lo, hi: pivotIndex - 1)
        }
        // Are there elements after the pivot to sort?
        if pivotIndex != hi {
            quicksort(&nums, lo: min(pivotIndex + 1, hi), hi: hi)
        }
    }
    
    func merge(_ nums: inout [Int], Alo: Int, Ahi: Int, Blo: Int, Bhi: Int) {
        var merged = [Int]()
        let Aend = Ahi + 1
        let Bend = Bhi + 1
        var i = Alo, j = Blo
        while i != Aend && j != Bend {
            let a = nums[i], b = nums[j]
            if a < b {
                merged.append(a)
                i += 1
            } else {
                merged.append(b)
                j += 1
            }
        }
        while i != Aend {
            merged.append(nums[i])
            i += 1
        } 
        while j != Bend {
            merged.append(nums[j])
            j += 1
        }
        i = Alo
        for num in merged {
            nums[i] = num
            i += 1
        }
    }
    
    func mergesort(_ nums: inout [Int], lo: Int, hi: Int) {
        if nums.isEmpty {
            return
        }
        if lo == hi {
            return
        }
        // Split the array in two halves.
        let mid = lo + (hi - lo) / 2
        let afterMid = min(mid + 1, hi)
        
        // Mergesort each side.
        mergesort(&nums, lo: lo, hi: mid)
        mergesort(&nums, lo: afterMid, hi: hi)
        
        // Merge the two halves.
        merge(&nums, Alo: lo, Ahi: mid, Blo: afterMid, Bhi: hi)
    }
    
    func sortArray(_ nums: [Int]) -> [Int] {
        var nums = nums
        // quicksort(&nums, lo: 0, hi: nums.count - 1)
        mergesort(&nums, lo: 0, hi: nums.count - 1)
        return nums
    }
}
