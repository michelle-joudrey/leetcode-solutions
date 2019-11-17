class Solution {

    // 3 -> invalid
    // 4 -> invalid
    // 7 -> invalid
    
    // If any digit in K doesn't rotate,
    // then K is a bad number.
    
    // If X = rotated(X), then X is bad.
    
    // naive:
    // count = 0
    // for i in 1...N
    //    if !i.digits.contains { badDigit($0) }
    //        count += 1\
    // return count
    
    // O(N * P)
    // P is the number of digits.
    // P <= digits(10000) = 5
    
    // to get each digit, keep dividing by 10.
    // 1234 / 10 = 123, 1234 % 10 = 4
    // 123 / 10 = 12, 123 % 10 = 3
    // 12 / 10 = 1, 12 % 10 = 2
    // 1 / 10 = 0, 1 % 10 = 1
    
    // after applying the rotation, we need to combine the digits.
    // 0 + 4 * 1 = 4
    // 4 + 3 * 10 = 34
    // 34 + 2 * 100 = 234
    // 234 + 1 * 1000 = 1234
    
    func rotatedDigits(_ N: Int) -> Int {
        var count = 0
        outer: for k in 1...N {
            var n = k
            var rotatedK = 0
            var x = 1
            while n != 0 {
                let digit = n % 10
                let rotDigit: Int
                switch digit {
                case 3, 4, 7:
                    continue outer
                case 0, 1, 8:
                    rotDigit = digit
                case 2:
                    rotDigit = 5
                case 5:
                    rotDigit = 2
                case 6:
                    rotDigit = 9
                case 9:
                    rotDigit = 6
                default:
                    fatalError()
                }
                rotatedK += rotDigit * x
                x *= 10
                n /= 10
            }
            if rotatedK == k {
                continue
            }
            count += 1
        }
        return count
    }
}
