class Solution {
    // Input: S = "ab##c", T = "a#d#c"
    // Generate new strings
    // Note: A backspace can only remove elements that come before it.
    // i.e. it doesn't affect characters we haven't seen yet.
    // An array of characters would work fine.
    // Given the note above, can we simply traverse the string in reverse order?
    // Yes, I think so.

    // Algorithm: Reverse two-pointer approach
    // Traverse the string from last character to first character.
    // - If we see a #, increment numToSkip
    // - Otherwise, skip this char if numToSkip > 0 (and decrement numToSkip).
    // - If this character is not skipped, compare with other string's unskipped char.

    func lastComparableIndex(in str: String, from i: String.Index) -> String.Index? {
        var numToSkip = 0
        var i = i
        var pref = str.prefix(through: i)
        for i in pref.indices.reversed() {
            let char = str[i]
            if char == "#" {
                numToSkip += 1
            } else if numToSkip == 0 {
                return i
            } else { // numToSkip > 0
                numToSkip -= 1
            }
        }
        return nil
    }
    
    func backspaceCompare(_ S: String, _ T: String) -> Bool {
        var i = S.indices.last
        var j = T.indices.last
        while true {
            // Find the first comparable char in S.
            let si = i.map { lastComparableIndex(in: S, from: $0) } ?? nil
            let tj = j.map { lastComparableIndex(in: T, from: $0) } ?? nil
            switch (si, tj) {
            case (.some(let si), .some(let tj)):
                if S[si] != T[tj] {
                    // If a character doesn't match, bail early.
                    return false
                }
                if si == S.startIndex {
                    i = nil
                } else {
                    i = S.index(before: si)                  
                }
                if tj == T.startIndex {
                    j = nil
                } else {
                    j = T.index(before: tj)                  
                }
            case (.none, .some), (.some, .none):
                // There is other character to match against
                return false
            case (.none, .none):
                // There are no more characters in either string
                return true 
            }
        }
    }
}
