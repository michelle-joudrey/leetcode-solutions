class Solution {
    func say(_ str: String) -> String {
        // count how many of the same char we have in a row
        var output = ""
        var str = Array(str)
        var i = 0
        var j = 0
        while i != str.count {
            while j != str.count && str[i] == str[j] {
                j += 1
            }
            let char = str[i]
            let count = j - i
            output += "\(count)\(char)"
            i = j
        }
        return output
    }
    
    func countAndSay(_ n: Int) -> String {
        if n == 1 {
            return "1"
        }
        return say(countAndSay(n - 1))
    }
}
