class Solution {
    func intToRoman(_ num: Int) -> String {
        var num = num
        var result = ""
        
        let symbols = [ 
            (1000, "M"), (900, "CM"), 
            (500, "D"), (400, "CD"), 
            (100, "C"), (90, "XC"), 
            (50, "L"), (40, "XL"), 
            (10, "X"), (9, "IX"),
            (5, "V"), (4, "IV"),
            (1, "I")
        ]
        
        for (value, symbol) in symbols {
            let numToEmit = num / value
            num = num % value
            if numToEmit != 0 {
                result += String(repeating: symbol, count: numToEmit)
            }
            if num == 0 {
                break
            }
        }        
        return result
    }
}
