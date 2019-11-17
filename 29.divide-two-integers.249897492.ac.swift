class Solution {
    // Find highest power of two c s.t. a <= c * b.
    // Assumes that a >= b.
    func highest(_ a: Int, _ b: Int) -> (c: Int, cb: Int) {
        var c = 1
        var cb = b
        while cb <= a {
            // multiply c by 2 and update c * b.
            cb <<= 1
            c <<= 1
        }
        // since we exited the loop, cb > a.
        // we need to "go back" once so that cb <= a.
        return (c >> 1, cb >> 1)
    }

    // special cases: negatives, min, max, a = b.
    func divide(_ dividend: Int, _ divisor: Int) -> Int {
        // a / b = c
        var a = abs(dividend)
        var b = abs(divisor)
        var output = 0

        // if a >= b, c must be >= 1.
        while a >= b {
            // 1. compute highest power of two of c s.t. a <= c * b
            let (c, cb) = highest(a, b)
            // 2. combine with output
            output |= c
            // 3. update a
            a -= cb
        }

        // sign
        a = dividend
        b = divisor
        if (a < 0 || b < 0) && !(a < 0 && b < 0) {
            output = -output
        }
        // boundary values
        if output < Int32.min {
            return Int(Int32.min)
        }
        if output > Int32.max {
            return Int(Int32.max)
        }
        return output
    }
}
