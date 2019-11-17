extension Character {
    var toLower: Character {
        return Character(String(self).lowercased())
    }
    var isNonAlphaNumeric: Bool {
        return !CharacterSet.alphanumerics.contains(self.unicodeScalars.first!)
    }
}

class Solution {
    func isPalindrome(_ s: String) -> Bool {
        var chars = Array(s)
        guard let lastIndex = chars.indices.last else {
            return true
        }
        var i = chars.startIndex
        var j = lastIndex
        while i < j {
            let lhs = chars[i]
            if lhs.isNonAlphaNumeric {
                i += 1
                continue
            }
            let rhs = chars[j]
            if rhs.isNonAlphaNumeric {
                j -= 1
                continue
            }
            if lhs.toLower != rhs.toLower {
                return false
            }
            i += 1
            j -= 1
        }
        return true
    }
}
