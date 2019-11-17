class Solution {
    func increasingTriplet(_ nums: [Int]) -> Bool {
        guard var a = nums.first else {
            return false
        }
        var b: Int?
        for n in nums.dropFirst() {
            if n > a {
                if let _b = b {
                    if n > _b {
                         // a < b < n
                        return true
                    }
                } else {
                    // a < n
                    b = n
                }
            } else if n < a {
                b = nil
                a = n
            }
        }
        return false
    }
}
