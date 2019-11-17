class Solution {    
    func isValid(_ s: String) -> Bool {
        var stack = [Character]()
        for char in s {
            switch char {
                case "{", "[", "(":
                    stack.append(char)
                default:
                    guard let last = stack.last else {
                        return false
                    }
                    stack.removeLast()
                    switch char {
                        case "}": 
                            if last != "{" { 
                                return false 
                            }
                        case "]":
                            if last != "[" { 
                                return false 
                            }
                        case ")":
                            if last != "(" { 
                                return false 
                            }
                        default:
                            fatalError()
                    }
            }
        }
        if !stack.isEmpty {
            return false
        }
        return true
    }
}
