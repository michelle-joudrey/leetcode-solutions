class Solution {
    typealias Board = [[Character]]

    func updateDomain(board: Board, startRow: Int, startColumn: Int, numRows: Int, numColumns: Int, domain: inout [Bool]) {
        for row in startRow..<(startRow + numRows) {
            for column in startColumn..<(startColumn + numColumns) {
                let cell = board[row][column]
                if let value = Int(String(cell)) {
                    domain[value - 1] = false
                }
            }
        }
    }

    func getDomain(for board: Board, row: Int, col: Int) -> [Int]? {
        if let _ = Int(String(board[row][col])) {
            return nil
        }
        var dom = [Bool](repeating: true, count: 9)
        // Check the cells in the current row
        updateDomain(board: board, startRow: row, startColumn: 0, numRows: 1, numColumns: 9, domain: &dom)
        // Check the cells in the current column
        updateDomain(board: board, startRow: 0, startColumn: col, numRows: 9, numColumns: 1, domain: &dom)
        // Check the current box (get rid of remainder to get upper left)
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        updateDomain(board: board, startRow: boxRow, startColumn: boxCol, numRows: 3, numColumns: 3, domain: &dom)
        return dom.indices.filter { dom[$0] }.map { $0 + 1 }
    }

    func mostConstrainedVariable(for board: Board) -> (row: Int, col: Int, domain: [Int])? {
        var min: (row: Int, col: Int, domain: [Int])? = nil
        for row in 0..<9 {
            for col in 0..<9 {
                if let domain = getDomain(for: board, row: row, col: col) {
                    let tuple = (row, col, domain)
                    min = min.map { domain.count < $0.domain.count ? tuple : $0 } ?? tuple
                }
            }
        }
        return min.map { ($0.row, $0.col, $0.domain) }
    }

    func solveSudoku(_ board: inout Board) -> Bool {
        // We are most likely to guess the correct value for the most constrained variable.
        guard let (row, col, domain) = mostConstrainedVariable(for: board) else {
            return true
        }
        // Try each value in the domain.
        for value in domain {
            board[row][col] = Character(String(value))
            if solveSudoku(&board) {
                return true
            }
        }
        // Dead end: We made a bad choice earlier, now we need to backtrack.
        board[row][col] = "."
        return false
    }
}
