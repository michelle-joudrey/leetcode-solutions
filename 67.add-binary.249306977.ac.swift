class Solution {
    func addBinary(_ a: String, _ b: String) -> String {
        //  11
        //  01
        // 100  digit = (a+b+carry)%2 = 0, carry = (a+b+carry) / 2.
        // compute least-significant digit first, then next, etc.
        // reverse string at the end.
        // 0
        // 00
        // 001
        // 001 -> 100
        
        var output = ""
        
        let a = a.reversed()
        let b = b.reversed()
        
        var i = Optional(a.startIndex)
        var j = Optional(b.startIndex)
        var carry = 0
        
        while i != nil || j != nil || carry != 0 {
            // 1
            let lhs = i.map { Int(String(a[$0]))! } ?? 0
            // 1
            let rhs = j.map { Int(String(b[$0]))! } ?? 0
            let sum = lhs + rhs + carry
            let digit = sum % 2
            carry = sum / 2
            output += "\(digit)"

            if let nextI = i.map({ a.index(after: $0) }) {
                i = nextI == a.endIndex ? nil : nextI                
            }

            if let nextJ = j.map({ b.index(after: $0) }) {
                j = nextJ == b.endIndex ? nil : nextJ
            }
        }
        return String(output.reversed())
    }
}
