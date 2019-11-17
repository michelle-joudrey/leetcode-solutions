class Solution {
    // We'll bucket items into high and low buckets.
    // This will help us narrow down where the minimum missing value is. 
    func search(_ nums: [Int], min: Int, max: Int) -> Int {
        // When we've whittled down the number of values to some arbitrary small constant,
        // we can do a simple check to see which value is missing.
        if max - min < 10 {
            var set = Set<Int>()
            for n in nums {
                if n >= min && n <= max {
                    set.insert(n)
                }
            }
            let missing = (min...max).first { !set.contains($0) }
            if let _missing = missing {
                return _missing
            }
            return max + 1
        }
        
        let boundary = (min + max) / 2
        var lowBucket = Set<Int>()
        var highBucket = Set<Int>()
        for n in nums {
            if n < min || n > max {
                continue
            }
            if n < boundary {
                lowBucket.insert(n)
            } else {
                highBucket.insert(n)
            }
        }
        // If a bucket is missing values, we will investigate it further.
        if lowBucket.count < boundary - min {
            return search(nums, min: min, max: boundary)
        } else if highBucket.count < max - boundary {
            return search(nums, min: boundary, max: max)            
        } else {
            return max + 1
        }
    }
    
    func firstMissingPositive(_ nums: [Int]) -> Int {
        guard let minPositive = nums.lazy.filter({ $0 > 0 }).min() else {
            return 1
        }
        if minPositive != 1 {
            return 1
        }
        let max = nums.max()!
        return search(nums, min: minPositive, max: max)
    }
}
