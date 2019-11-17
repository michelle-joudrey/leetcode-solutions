// 1,234,517
// % 10 = 7 (seven)
// % 100 = 17 (seventeen)
// % 1000 = 500 = (five hundred)

class Solution {
    let digits = [ "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" ]
    let teenDigits = [ "Zero", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" ]
    let tenDigits = [ "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" ]
    let modifiers = [ "Nothing", "Thousand", "Million", "Billion" ]
    
    func numberToWords(_ num: Int) -> String {
        if num == 0 {
            return "Zero"
        }
        
        // handle hundreds place first
        var n = num
        var i = 0
        var words = [String]()
        while n != 0 {
            // how many hundred do we have? (0 through 9)
            let hundreds = (n % 1000) / 100
            // how many tens do we have? (0 through 9)
            let tens = (n % 100) / 10
            // how many ones do we have? (0 through 9)
            let ones = (n % 10)
            
            var strs = [String]()
            
            if hundreds > 0 {
                // e.g. five hundred
                strs.append(digits[hundreds]) // five
                strs.append("Hundred")
            }
            if tens == 1 && ones != 0 {
                // Fourteen
                strs.append(teenDigits[ones])
            } else {
                if tens > 0 {
                    // fifty-five
                    strs.append(tenDigits[tens]) // fifty
                }
                if ones > 0 {
                    strs.append(digits[ones]) // five
                }
            }
            if !strs.isEmpty {
                if i > 0 {
                    // Thousand
                    strs.append(modifiers[i])
                }
                let str = strs.joined(separator: " ")
                words.append(str)
            }
            
            n /= 1000
            i += 1
        }
        
        return words.reversed().joined(separator: " ")
    }
}
