class Solution {
    func maximalSquare(_ matrix: [[Character]]) -> Int {
        // Brute force:
        // Treat each cell as the top left corner of the square,
        // expand the square while all cells to be added to it are 1s.
        // Use the maximum sized square.
        // Time complexity: O(N * M * N * M)
        
        
        // DP solution: "Promote" 1s surrounded by 1s into 2s, 2s into 3s, etc.
        // Use a matrix to store the maximal square for each cell, where
        //    the cell represents the bottom right cell of the square.
        // The trick here is to process the cells in an order such that
        //    the above, upper left, and left cells have already been processed.
        // Since some cells have no above, upper left, or left cells, add an 
        //    extra row and column to the grid to avoid index checks.
        // Time complexity: O(N * M)
        
        // For example:
        
        /*
              1 0 1 0 0
              1 0 1 1 1
              1 1 1 1 1
              1 0 0 1 0
        
            0 0 0 0 0 0
            0 1 0 1 0 0
            0 1 0 1 1 1
            0 1 1 1 2 2
            0 1 0 0 1 0        
        */
        
        if matrix.isEmpty {
            return 0
        }
        
        let row = [Int](repeating: 0, count: matrix[0].count + 1)
        var table = [[Int]](repeating: row, count: matrix.count + 1)
        
        for (i, row) in matrix.enumerated() {
            for (j, cell) in row.enumerated() {
                if cell == "1" {
                    table[i + 1][j + 1] = 1 + min(
                        table[i][j],
                        table[i + 1][j],
                        table[i][j + 1]
                    )
                }
            }
        }
        
        let maxCell = table.flatMap { $0 }.max()
        return Int(pow(Double(maxCell!), 2.0))
    }
}
