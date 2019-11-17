class Solution {
        /*
          A
        D   B
          C
        
          B       Swap top and right
        D   A
          C
        
          C       Swap top and bottom
        D   A
          B
        
          D       Swap top and left
        C   A
          B
        
        */
    
    func rotate(_ matrix: inout [[Int]], _ first: Int? = nil, _ n: Int? = nil) {        
        func swap(_ i: (Int, Int), _ j: (Int,Int)) {
            var temp = matrix[i.0][i.1]
            matrix[i.0][i.1] = matrix[j.0][j.1]
            matrix[j.0][j.1] = temp
        }
        
        let first = first ?? 0
        let n = n ?? matrix.count
        let last = first + n - 1
        
        if n <= 1 {
            return
        }
        
        // start refers to the first element between the two corner elements
        let start = first + 1
        // end refers to the last element between the two corner elements
        let end = last - 1
        let midLen = max(end - start + 1, 0)
        
        // Swap top row with right column from top to bottom
        for i in 0..<midLen {
            swap((first, start + i), (start + i, last))
        }
        // Swap top row with bottom row from right to left
        for i in 0..<midLen {
            swap((first, start + i), (last, end - i))
        }
        // Swap top row with left column from bottom to top
        for i in 0..<midLen {
            swap((first, start + i), (end - i, first))
        }
        
        // Swap top left with top right
        swap((first, first), (first, last))
        // Swap top left with bottom right
        swap((first, first), (last, last))
        // Swap top left with bottom left
        swap((first, first), (last, first))
        
        rotate(&matrix, first + 1, n - 2)
    }
}
