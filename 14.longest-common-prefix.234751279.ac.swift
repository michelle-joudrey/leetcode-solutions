class Solution {
    func char(at index: String.Index, in str: String) -> Character? {
        if str.indices.contains(index) {
            return str[index]
        }
        return nil
    }
    
    func longestCommonPrefix(_ strs: [String]) -> String {
        if strs.count == 0 {
            return ""
        }        
        var prefix = ""
        var index = strs[0].startIndex
        while true {
            guard let c1 = char(at: index, in: strs[0]) else {
                return prefix
            }
            for s in strs {
                guard let c2 = char(at: index, in: s) else {
                    return prefix
                }
                if c2 != c1 {
                    return prefix
                }
            }
            prefix += String(c1)
            strs[0].formIndex(after: &index)
        }
        return prefix
    }
}
