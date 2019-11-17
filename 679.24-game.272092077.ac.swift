extension Float {
    // Because floating point 
    var isAbout24: Bool {
        return self > 23.9 && self < 24.1
    }
}

class Solution {
    func f(_ operation: Int, _ lhs: Float, _ rhs: Float) -> Float {
        switch operation {
        case 0:
            return lhs * rhs
        case 1:
            return lhs / rhs
        case 2:
            return lhs - rhs
        case 3:
            return lhs + rhs
        default:
            fatalError()
        }
    }
    
    func judgePoint24(_ numbers: [Int]) -> Bool {
        let range = 0..<4
        let opRange = 0..<4
        for op1 in opRange {
            for op2 in opRange {
                for op3 in opRange {
                    for g1 in range {
                        for g2 in range {
                            if g2 == g1 { 
                                continue
                            }
                            for g3 in range {
                                if g3 == g1 || g3 == g2 {
                                    continue
                                }
                                for g4 in range {
                                    if g4 == g1 || g4 == g2 || g4 == g3 {
                                        continue
                                    }
                                    var a = Float(numbers[g1])
                                    var b = Float(numbers[g2])
                                    var c = Float(numbers[g3])
                                    var d = Float(numbers[g4])
                                    
                                    // There are 5 different parse trees you can generate using
                                    // 3 operations and 4 variables. We will simply try them all here.
                                    
                                    var s = f(op1, f(op2, f(op3, a, b), c), d)
                                    if s.isAbout24 {
                                        return true
                                    }
                                    
                                    s = f(op1, f(op2, a, f(op3, b, c)), d)
                                    if s.isAbout24 {
                                        return true
                                    }
                                    
                                    s = f(op1, f(op2, a, b), f(op3, c, d))
                                    if s.isAbout24 {
                                        return true
                                    }
                                    
                                    s = f(op1, a, f(op2, b, f(op3, c, d)))
                                    if s.isAbout24 {
                                        return true
                                    }
                                    
                                    s = f(op1, a, f(op2, f(op3, b, c), d))
                                    if s.isAbout24 {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}
