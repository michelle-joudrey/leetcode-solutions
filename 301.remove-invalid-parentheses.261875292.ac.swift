// Naive approach: Try every possible combination of removing parens.
// Say that we have N parens (open + close)
// For each paren, create a string without adding the paren, and a string with the paren.
// 
// e.g.
// input: "()("
// "", "("
// "", ")", "()", ")"
// "", ")", "()", ")", "(", ")(", "()(", ")("
// When we have processed all input chars, then we pick the longest valid one. e.g. "()"
// Overall time complexity: O(2^N * N) since we branch two ways on every paren.

class Solution {
    func tryAll(_ str: String) -> [String] {
        var strings = [""]
        for char in str {
            // Do we have a non-paren character?
            if char != "(" && char != ")" {
                // Note: We have to use the index here to mutate the value.
                for i in strings.indices {
                    strings[i].append(char)
                }
                continue
            }
            var newStrings = strings
            for i in newStrings.indices {
                // Add the paren
                newStrings[i].append(char)
            }
            strings += newStrings
            strings = Array(Set(strings))
        }
        return strings
    }
    
    func isValid(_ str: String) -> Bool {
        var balance = 0
        for char in str {
            if char == "(" {
                balance += 1
            }
            if char == ")" {
                if balance == 0 {
                    return false
                }
                balance -= 1
            }
            // ignore non-paren chars
        }
        return balance == 0
    }
    
    func removeInvalidParentheses(_ s: String) -> [String] {
        let strs = tryAll(s).filter(isValid)
        let maxCount = strs.map { $0.count }.max()
        return strs.filter { $0.count == maxCount }
    }
}
