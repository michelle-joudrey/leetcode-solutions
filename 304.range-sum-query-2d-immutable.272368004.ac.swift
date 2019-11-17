class NumMatrix {
    let DP: [[Int]]

    init(_ matrix: [[Int]]) {
        let numRows = matrix.count
        let numCols = matrix.first?.count ?? 0

        let DPRow = [Int](repeating: 0, count: numCols + 1)
        var DP = [[Int]](repeating: DPRow, count: numRows + 1)

        // Fill in the DP table.
        // DP[i,j] = DP[i-1,j] + DP[i,j-1] - DP[i-1,j-1] + A[i,j]
        // Make sure to add one to every index used to index DP since we added an extra zero
        // row and column to the start of the DP table (in order to avoid edge cases).
        for (i, row) in matrix.enumerated() {
            for (j, cell) in row.enumerated() {
                DP[i + 1][j + 1] = DP[i][j + 1] + DP[i + 1][j] - DP[i][j] + cell
            }
        }
        self.DP = DP
    }

    func subMatrixSum(i1: Int, j1: Int, i2: Int, j2: Int) -> Int {
        let whole   = DP[i2 + 1][j2 + 1]
        let left    = DP[i2 + 1][j1]
        let top     = DP[i1][j2 + 1]
        let overlap = DP[i1][j1]
        return whole - (top + left - overlap)
    }
    
    func sumRegion(_ row1: Int, _ col1: Int, _ row2: Int, _ col2: Int) -> Int {
        return subMatrixSum(i1: row1, j1: col1, i2: row2, j2: col2)
    }
}

/**
 * Your NumMatrix object will be instantiated and called as such:
 * let obj = NumMatrix(matrix)
 * let ret_1: Int = obj.sumRegion(row1, col1, row2, col2)
 */
