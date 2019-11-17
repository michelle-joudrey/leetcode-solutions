class Solution {
    func lengthOfLongestSubstringTwoDistinct(_ s: String) -> Int {
        // eg. eccbcc
        // Enumerate the string
        // eccbcc
        // ^       Add this character to the ones we've seen. [(e, 0)]. len = 1
        // eccbcc
        //  ^      Add this one too.  [(e, 0), (c, 1)]. len = 2
        // eccbcc
        //   ^     Duplicate character. [(e, 0), (c, 1)] len = 3
        // eccbcc
        //    ^    Now we need to throw away the e, since that was least recently used.
        //         [(c, 1), (b, 3)]
        // eccbcc
        //     ^   We've already seen c, so just continue. len = 3
        // eccbcc
        //      ^  Same. len = 4.
        
        // eceba
        // ^       Add [(e, 0)]
        // eceba
        //  ^      Add [(e, 0), (c, 1)]
        // eceba
        //   ^     Do nothing [(e, 0), (c, 1)]
        // eceba
        //   ^     Do nothing [(e, 0), (c, 1)]
        // eceba
        //    ^    Remove lru [(e, 0)]
        //         Update e   [(e, 2)]
        //         Add b      [(e, 2), (b, 3)]
        // Updating e:
        // c is the least recently used char.
        // The new start index for e will be j + 1, where j is the last 
        // index where c appeared.
        // Length:
        // count == 2: index - min(A0.i, A1.i)
        // count == 1: index - A0.i
        
        
        // Keep track of where each of the two unique characters appeared.
        var uniqueLetters = [(startIndex: Int, c: Character, lastIndex: Int)]()
        var maxLength = 0
        for (index, char) in s.enumerated() {
            // Have we seen this letter already?
            if let i = uniqueLetters.firstIndex(where: { $0.c == char }) {
                // If so, update the lastIndex.
                uniqueLetters[i].lastIndex = index
            } else {
                // If not...
                // Do we need to make space for this letter?
                if uniqueLetters.count == 2 {
                    // Yes, let's remove the least recently used letter.
                    let lruIndex = uniqueLetters[0].lastIndex > uniqueLetters[1].lastIndex ? 1 : 0
                    let j = uniqueLetters[lruIndex].lastIndex
                    uniqueLetters.remove(at: lruIndex)
                    // Update the startIndex of the most recently used letter.
                    uniqueLetters[0].startIndex = j + 1
                }
                // Add the letter
                uniqueLetters.append((index, char, index))
            }
            if uniqueLetters.count == 2 {
                let minIndex = min(uniqueLetters[0].startIndex, uniqueLetters[1].startIndex)
                let length = index - minIndex + 1
                maxLength = max(maxLength, length)
            }
            if uniqueLetters.count == 1 {
                let length = index - uniqueLetters[0].startIndex + 1
                maxLength = max(maxLength, length)
            }
        }
        return maxLength
    }
}
