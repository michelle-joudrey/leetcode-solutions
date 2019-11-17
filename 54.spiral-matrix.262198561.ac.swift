class Solution {    
    func spiralOrder(_ matrix: [[Int]]) -> [Int] {
        var output = [Int]()
        
        var startRow = 0
        var startColumn = 0
        var numRows = matrix.count
        var numColumns = matrix.first?.count ?? 0
        
        while numRows > 0 && numColumns > 0 {
            var lastRow = startRow + numRows - 1
            var lastColumn = startColumn + numColumns - 1

            // Append the first row
            (startColumn...lastColumn).forEach { col in
                output.append(matrix[startRow][col])
            }
            // Append the right column, except for the first and last row.
            (startRow...lastRow).dropFirst().dropLast().forEach { row in
                output.append(matrix[row][lastColumn])
            }
            if startRow != lastRow {
                // Append the bottom row
                (startColumn...lastColumn).reversed().forEach { col in
                    output.append(matrix[lastRow][col])
                }                
            }
            if startColumn != lastColumn {
                // Append the left column, except for the first and last rows, in reverse order.
                (startRow...lastRow).dropFirst().dropLast().reversed().forEach { row in
                    output.append(matrix[row][startColumn])
                }
            }
            startRow += 1
            startColumn += 1
            numRows -= 2
            numColumns -= 2
        }
        return output
    }
}
