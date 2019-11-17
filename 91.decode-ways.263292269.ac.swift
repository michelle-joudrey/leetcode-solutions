class Solution {
    func numDecodings(_ s: String) -> Int {
        var chars = Array(s)
        var numPathsFromIndex = [Int](repeating: 0, count: s.count)
        
        enum MyError: Error {
            case badInput
        }
        
        func DFS(index i: Int) throws -> Int {
            if i == chars.endIndex {
                return 1
            }
            
            if !chars.indices.contains(i) {
                return 0
            }
            // Don't recalculate the number of paths for chars at indices we've already visited.
            if numPathsFromIndex[i] != 0 {
                return numPathsFromIndex[i]
            }
            // Use this index alone to form a letter.
            var numPaths = 0
            
            // Can we use this index and the next to form a letter?
            let num = Int(String(chars[i]))!
            
            // If this number is '0', we don't count it towards our number of paths.
            if num == 0 {
                // Check if the previous index was a '1' or '2'.
                if !chars.indices.contains(i - 1) {
                    throw MyError.badInput
                }
                let prevNum = Int(String(chars[i - 1]))!
                if !(1...2).contains(prevNum) {
                    throw MyError.badInput
                }
                return 0
            }
            numPaths += try DFS(index: i + 1)
            
            if chars.indices.contains(i + 1) {
                let twoDigitNum = Int(String(chars[i...i + 1]))!
                if (1...26).contains(twoDigitNum) {
                    numPaths += try DFS(index: i + 2)
                }
            }
            numPathsFromIndex[i] = numPaths
            return numPaths
        }
        
        if let firstIndex = chars.indices.first {
            return (try? DFS(index: 0)) ?? 0
        }
        return 0
    }
}
