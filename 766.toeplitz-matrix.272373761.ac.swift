class Solution {
    func isValid(_ matrix: [[Int]], _ i: Int, _ j: Int) -> Bool {
        let numRows = matrix.count
        let numCols = matrix.first?.count ?? 0
        let targetValue = matrix[i][j]
        // go diagonal while possible
        var i = i + 1
        var j = j + 1
        while i < numRows && j < numCols {
            let value = matrix[i][j]
            if value != targetValue {
                return false
            }
            i += 1
            j += 1
        }
        return true
    }
    
    func isToeplitzMatrix(_ matrix: [[Int]]) -> Bool {
        let numRows = matrix.count
        let numCols = matrix.first?.count ?? 0
        for i in 0..<numRows {
            if !isValid(matrix, i, 0) {
                return false
            }
        }
        for j in 0..<numCols {
            if !isValid(matrix, 0, j) {
                return false
            }            
        }
        return true
    }
}
