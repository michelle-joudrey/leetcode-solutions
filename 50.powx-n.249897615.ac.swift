class Solution {
    // We could have 
    func myPow(_ x: Double, _ n: Int) -> Double {
        // x^(-n) = (1/x)^n
        // Note: restore the sign later.
        let sign = x < 0.0 ? (n % 2 == 0 ? 1.0 : -1.0) : 1.0
        let x = n < 0 ? (1.0 / abs(x)) : abs(x)
        let n = abs(n)
        
        // Solve based on this trick:
        // i.e. x^n = x^a * x^b where n = a + b.
        //      x^n = x^(2^1)*a1 * x^(2^2)*a2 ... * x^(2^30)*a2
        // e.g. 3^9 = 3^8 * 3^1
        
        // To do this, we need to compute this list quickly: 
        // x^1, x^2, x^4, x^8, x^16, ... , x^(2^31)
        // We can do this via the rule: x^(2n) = x^n * x^n
        // e.g. 3^8 = 3^4 * 3^4
        
        // We'll insert zeroes in place of numbers that are too large
        // to express with Double. x^k terms that are too small
        // to express with Double will automatically become zeroes.
        
        // The answer to x^2^y is at list[y].
        var list = [Double]()
        var r = x
        for _ in 1...31 {
            list.append(r)
            r = r * r
            if r.isInfinite {
                r = 0
            }
        }
        
        var product = 1.0
        var k = n
        var p = 30
        // set p2 to 2^30 since n can be at most 2^31-1.
        var p2 = 1 << 30
        while k != 0 {
            // Find the largest power of two less than k.
            while p2 > k {
                p2 /= 2
                p -= 1
            }
            
            // Multiply the x^(2^p) term with our product
            let term = list[p]
            if term == 0.0 {
                return 0.0
            }
            product *= term
            // Update k
            k -= p2
        }
        return sign * product
    }
}
