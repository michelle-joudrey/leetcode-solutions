class Solution {
    func isValidArea(board: [[Character]], startColumn: Int, startRow: Int, numColumns: Int, numRows: Int) -> Bool {
        var set = Array<Bool>(repeating: false, count: 9)
        for row in startRow..<(startRow + numRows) {
            for column in startColumn..<(startColumn+numColumns) {
                let cell = board[row][column]
                guard let value = Int(String(cell)) else {
                    continue
                }
                if set[value-1] {
                    return false
                }
                set[value-1] = true
            }
        }
        return true
    }
    
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        // validate each row
        for row in 0..<9 {
            if !isValidArea(board: board, startColumn: 0, startRow: row, numColumns: 9, numRows: 1) {
                return false
            }
        }
        // validate each column
        for col in 0..<9 {
            if !isValidArea(board: board, startColumn: col, startRow: 0, numColumns: 1, numRows: 9) {
                return false
            }
        }
        // validate each 9x9 subbox
        // 1,1, 1,4, 1,7
        // 4,1, 4,4, 4,7
        // 7,1, 7,4. 7,7
        for row in stride(from: 1, through: 7, by: 3) {
            for col in stride(from: 1, through: 7, by: 3) {                
                if !isValidArea(board: board, startColumn: col - 1, startRow: row - 1, numColumns: 3, numRows: 3) {
                    return false
                }
            }
        }
        return true
    }
}
