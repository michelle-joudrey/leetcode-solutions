class Solution {
    
    
    func multiply(_ lhs: String, _ rhs: String) -> String {
        let n = lhs.count
        let m = rhs.count
        // The product will either be n + m or n + m - 1,
        // but this depends on carry values, so we'll error on the side
        // of n + m, then correct the output later if necessary.
        var product = Array<Character>(repeating: "0", count: n + m)
        // 1. Strings don't conform to RandomAccessCollection
        let lhs = Array(lhs)
        let rhs = Array(rhs)
        
        // Build each column of the product starting with least-signifcant part.
        var carry = 0
        for col in 0..<product.count {
            var sum = carry
            // Sum up the rows of this column
            for row in 0..<m {
                let i = n - (col - row) - 1
                let j = m - row - 1
                if !lhs.indices.contains(i) {
                    continue
                }
                if !rhs.indices.contains(j) {
                    continue
                }
                let a = Int(String(lhs[i]))!
                let b = Int(String(rhs[j]))!
                sum += a * b
            }
            let k = product.count - col - 1
            let digit = sum % 10
            carry = sum / 10
            product[k] = Character(String(digit))
        }
        
        // Handle edge cases like 0123 and 0000.
        for (i, char) in product.enumerated() {
            if char != "0" {
                return String(product.suffix(from: i))
            }
        }        
        return "0"
    }
}
