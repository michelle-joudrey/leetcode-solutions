// DFS from each vertex.
// - During DFS, if we've already visited a vertex, add its associated length to the current path length.
// Once we finish processing a vertex, write down its maximum length.

//   [9,9,4]         [1,1,2]
//   [6,6,8]   --->  [2,2,1]
//   [2,1,1]         [3,4,2]

// a length of zero means the vertex has already been visited.

// We could have also solved this by doing a topological sort, then just counting the max length that way.
class Solution {
    func longestIncreasingPath(_ matrix: [[Int]]) -> Int {
        if matrix.isEmpty {
            return 0
        }
        // This is here just for performance.
        let numRows = matrix.count
        let rowLength = matrix[0].count
        var lengths = matrix.map { $0.map { _ in 0 } }
        
        func shouldVisit(_ i: Int, _ j: Int, fromValue: Int) -> Bool {
            if !(0..<numRows).contains(i) {
                return false
            }
            if !(0..<rowLength).contains(j) {
                return false
            }
            let value = matrix[i][j]
            return fromValue < value
        }
        
        func DFS(_ i: Int, _ j: Int) {
            let length = lengths[i][j]
            // Was this vertex already visited
            if length != 0 {
                return
            }
            let neighbors = [(i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)]
            let value = matrix[i][j]
            var maxLength = 0
            for (i, j) in neighbors {
                if shouldVisit(i, j, fromValue: value) {
                    DFS(i, j)
                    let length = lengths[i][j]
                    maxLength = max(maxLength, length)
                }
            }
            lengths[i][j] = 1 + maxLength
        }
        
        var maxLength = 0
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                DFS(i, j)
                let length = lengths[i][j]
                maxLength = max(maxLength, length)
            }
        }
        return maxLength
    }
}
