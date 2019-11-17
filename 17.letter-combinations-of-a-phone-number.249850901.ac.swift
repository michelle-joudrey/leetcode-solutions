class Solution {
    
    // Returns false when finished
    func addOne( _ numbers: inout [Int], _ bases: [Int]) -> Bool {
        var i = numbers.count - 1
        while i >= 0 {
            let n = numbers[i] + 1
            let base = bases[i]
            if n == base {
                numbers[i] = 0
            } else {
                numbers[i] = n
                return true
            }
            i -= 1
        }
        return false
    }
    
    func letterCombinations(_ digits: String) -> [String] {
        if digits.count == 0 {
            return []
        }
        
        let letterMap = [
            "",     // 0
            "",     // 1
            "abc",  // 2
            "def",
            "ghi",
            "jkl",
            "mno",
            "pqrs",
            "tuv",
            "wxyz" // 9
        ]
        var strs = [String]()
        var letters = digits.map { Array(letterMap[Int(String($0), radix: 10)!]) }
        var indices = [Int](repeating: 0, count: letters.count)
        var bases = letters.map { $0.count }
        repeat {
            var str = ""
            for i in 0 ..< letters.count {
                let j = indices[i]
                str += String(letters[i][j])
            }
            strs.append(str)
        } while addOne(&indices, bases)
        return strs
    }
}
