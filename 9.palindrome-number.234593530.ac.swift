class Solution {
    func reverse(_ x: Int) -> Int {
        let sign = x < 0 ? -1 : 1
        var x = x < 0 ? -x : x
        var y = 0
        while x != 0 {
            y *= 10
            y += x % 10
            x /= 10
        }
        if y > Int32.max {
            return 0
        }
        return y * sign
    }
    
    func isPalindrome(_ x: Int) -> Bool {
        if x < 0 {
            return false
        }
        let rev = reverse(x)
        return rev == x
    }
}
