class Solution {
    func romanToInt(_ s: String) -> Int {
        let symbols = [ 
            (1000, "M"), (500, "D"), (100, "C"), (50, "L"), (10, "X"), (5, "V"), (1, "I")
        ]
        
        let specialSymbols = [
            (900, "CM"), (400, "CD"), (90, "XC"), (40, "XL"), (9, "IX"), (4, "IV")
        ]
        
        var index = s.startIndex
        
        func peek() -> String? {
            if !s.indices.contains(index) {
                return nil
            }
            return String(s[index])
        }
        
        func consume() -> String? {
            guard let str = peek() else {
                return nil
            }
            s.formIndex(after: &index)
            return str
        }
        
        var result = 0
        
        while true {
            guard let firstChar = consume() else {
                break
            }
            if let secondChar = peek() {
                let prefix = firstChar + secondChar
                if let symbol = specialSymbols.first(where: { $0.1 == prefix }) {
                    consume()
                    result += symbol.0
                    continue
                }
            }
            let symbol = symbols.first(where: { $0.1 == firstChar })!
            result += symbol.0
        }
        
        return result
    }
}
