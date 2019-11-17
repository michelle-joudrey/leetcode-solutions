class Solution {
    func myAtoi(_ str: String) -> Int {
        var y = 0
        var sign = 1
        var sawSign = false
        var sawDigit = false
        for c in str {
            if c == "." {
                break
            }
            if c == " " {
                if sawDigit {
                    break
                }
                if sawSign {
                    break
                }
                continue
            }
            if c == "+" {
                if sawSign {
                    if sawDigit {
                        break
                    }
                    return 0
                }
                sawSign = true
                continue
            }
            if c == "-" {
                if sawSign {
                    if sawDigit {
                        break
                    }
                    return 0
                }
                sawSign = true
                if sawDigit {
                    break
                }
                sign = -1
                continue
            }
            if let c = Int(String(c), radix: 10) {
                sawDigit = true
                var overflow: Bool
                (y, overflow) = y.multipliedReportingOverflow(by: 10)
                if overflow {
                    if sign == -1 {
                        return Int(Int32.min)
                    }
                    return Int(Int32.max)
                }
                (y, overflow) = y.addingReportingOverflow(c)
                if overflow {
                    if sign == -1 {
                        return Int(Int32.min)
                    }
                    return Int(Int32.max)
                }
            } else if y == 0 {
                return 0
            } else {
                break
            }
        }
        let result = y * sign
        if result < Int32.min {
            return Int(Int32.min)
        }
        if result > Int32.max {
            return Int(Int32.max)
        }
        return result
    }
}
