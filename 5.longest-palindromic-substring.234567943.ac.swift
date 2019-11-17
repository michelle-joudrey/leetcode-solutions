class Solution {
    func expand(_ s: [Character], _ leftI: Int, _ rightI: Int) -> ClosedRange<Int>? {
        var i = leftI
        var j = rightI
        var lastGood: ClosedRange<Int>?
        while s.indices.contains(i) && s.indices.contains(j) {
            if s[i] == s[j] {
                lastGood = i...j
            } else {
                return lastGood
            }
            i -= 1
            j += 1
        }
        return lastGood
    }
    
    func longestPalindrome(_ s: String) -> String {
        let chars = Array(s)
        var longestRange: ClosedRange<Int>?
        for i in 0 ..< chars.count {
            for j in i ... i + 1 {
                if let range = expand(chars, i, j) {
                    if let _longestRange = longestRange {
                        if range.count > _longestRange.count {
                            longestRange = range
                        }                        
                    } else {
                        longestRange = range
                    }
                }                
            }
        }
        return longestRange.map { String(chars[$0]) } ?? ""
    }
}
