class Solution {
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        func indexExists(_ i: Int, _ j: Int) -> Bool {
            if !board.indices.contains(i) {
                return false
            }
            return board[i].indices.contains(j)
        }
        
        func getNeighbors(_ i: Int, _ j: Int) -> [(Int, Int)] {
            var neighbors = [(Int, Int)]()
            var indices = [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
            for (i, j) in indices {
                if indexExists(i, j) {
                    neighbors.append((i, j))
                }
            }
            return neighbors
        }
        
        // Keep track of which indices have been used to avoid reusing one.
        var visited = board.map { $0.map { _ in false } }
        
        func DFS(i: Int, j: Int, letterIndex: String.Index) -> Bool {
            if visited[i][j] {
                return false
            }
            visited[i][j] = true
            let nextIndex = word.index(after: letterIndex)
            // If we made it to the end of the word, we're done.
            if nextIndex == word.endIndex {
                return true
            }
            let nextLetter = word[nextIndex]
            let neighbors = getNeighbors(i, j)
            for (ni, nj) in neighbors {
                let char = board[ni][nj]
                if char == nextLetter {
                    if DFS(i: ni, j: nj, letterIndex: nextIndex) {
                        return true
                    }
                }
            }
            visited[i][j] = false
            return false
        }
        
        guard let firstLetter = word.first else {
            return false
        }        
        
        // DFS from each starting position.
        var startPositions = [(Int, Int)]()
        for (i, row) in board.enumerated() {
            for (j, char) in row.enumerated() {
                if char == firstLetter {
                    if DFS(i: i, j: j, letterIndex: word.startIndex) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
