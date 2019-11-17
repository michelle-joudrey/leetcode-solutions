class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        // find the longest substring that has no duplicate characters
        // brute force: generate every substring, filter those with duplicates, get max length of those
        // abcabcbb
        // a
        // ab
        // abc
        // abca (remove a from dict)
        // bcab (remove b from dict)
        // cabc (remove c from dict)
        // This next one shows how sometimes, multiple elements are removed from the dict
        // abcb (remove a and b from dict)
        // bcbb (remove b from dict)
        // 
        var max = 0
        var indexForElement = [Character:String.Index]()
        
        var i = s.startIndex
        var leftIndex = i
        
        while i != s.endIndex {
            let c = s[i]
            
            if let existingIndex = indexForElement[c] {
                // remove all key,value pairs from leftIndex to this index
                var index = leftIndex
                var endIndex = s.index(after: existingIndex)
                
                while index != endIndex {
                    let char = s[index]
                    indexForElement[char] = nil
                    s.formIndex(after: &index)
                }
                
                // abc,a -> bc (delete the character)
                leftIndex = s.index(after: existingIndex)
            }
            // bc -> bca
            indexForElement[c] = i
            let len = indexForElement.count
            max = len > max ? len : max
            
            // loop end
            s.formIndex(after: &i)
        }
        return max
    }
}
