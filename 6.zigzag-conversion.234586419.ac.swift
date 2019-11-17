class Solution {
    func convert(_ s: String, _ numRows: Int) -> String {        
        if numRows == 1 {
            return s
        }
        
        var rowChars = [(row: Int, char: Character)]()
        let chars = Array(s)
        
        func placeChars() {
            var cursorRow = 0        
            var index = 0
            
            func getChar() -> Character? {
                if chars.indices.contains(index) {
                    let char = chars[index]
                    index += 1
                    return char
                }
                return nil
            }
            
              while true {
                for _ in 1 ... numRows - 1 {
                    // place character
                    guard let char = getChar() else {
                        return
                    }
                    rowChars.append((cursorRow, char))
                    // move cursor down
                    cursorRow += 1
                }            
                for _ in 1 ... numRows - 1 {
                    guard let char = getChar() else {
                        return
                    }  
                    // place character
                    rowChars.append((cursorRow, char))
                    // move cursor up one row and right one column
                    cursorRow -= 1
                }
              }            
        }
        
        placeChars()
        
        // optimization step
        var rows = [[(Character)]](repeating:[(Character)](), count: numRows)         
        for (row, char) in rowChars {
            rows[row].append((char))
        }
        
        var str = ""
        for row in rows {
            for (char) in row {
                str += "\(char)"
            }
        }
        
        return str
    }
}
