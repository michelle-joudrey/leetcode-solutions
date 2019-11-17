// KMP algorithm
class Solution {
    func suffixInfo(_ str : [Character]) -> [Int] {
        var suffixInfo = [0]
        var i = 0, j = 1
        while j != str.endIndex {
            if str[i] == str[j] {
                suffixInfo.append(i + 1)
                i += 1
                j += 1
            } else if i == 0 {
                suffixInfo.append(0)
                j += 1
            } else {
                i = suffixInfo[i - 1]
            }
        }
        return suffixInfo
    }

    func strStr(_ haystack: String, _ needle: String) -> Int {
        let haystack = Array(haystack)
        let needle = Array(needle)
        if needle.isEmpty {
            return 0
        }
        if haystack.isEmpty || needle.count > haystack.count {
            return -1
        }
        let suffix = suffixInfo(needle)
        var i = 0
        var j = 0
        while i != haystack.endIndex && j != needle.endIndex {
            if haystack[i] == needle[j] {
                i += 1
                j += 1
            } else if j == 0 {
                i += 1
            } else {
                j = suffix[j - 1]
            }
        }
        if j == needle.endIndex {
            return i - needle.count
        }
        return -1
    }
}
