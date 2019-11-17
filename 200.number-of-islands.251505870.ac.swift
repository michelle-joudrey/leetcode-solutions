class Solution {
    class UnionFind: Hashable {
        var next: UnionFind?
        var count: Int
        
        init() {
            count = 1
            next = self
        }
        
        // Return the first element in the set.
        func find() -> UnionFind {
            var node = next!
            while node !== node.next! {
                node = node.next!
            }
            var head = node
            // Optimization: Update all of the intermediate nodes. 
            node = next!
            while node !== node.next! {
                node = node.next!
                node.next = head
            }
            return node
        }
        
        func union(_ other: UnionFind) {
            let otherHead = other.find()
            let head = find()
            if head == otherHead {
                return
            }
            // Optimization: Update both of these nodes
            other.next = head
            next = head
            
            otherHead.next = head
            head.count += otherHead.count
        }
        
        func hash(into hasher: inout Hasher) {
            let str = ObjectIdentifier(self)
            hasher.combine(str)
        }
        
        static func ==(lhs: UnionFind, rhs: UnionFind) -> Bool {
            return lhs === rhs
        }
    }
    
    func numIslands(_ grid: [[Character]]) -> Int {
        guard let firstRow = grid.first else {
            return 0
        }
        let numRows = grid.count
        
        var sets = grid.map { row in row.map { _ in UnionFind() } }
        // for each row
        // - for column 1..<n,
        //   - if the previous column on this row is an island, and this one is, union them.
        for (rowIndex, row) in grid.enumerated() {
            for (columnIndex, cell) in row.enumerated().dropFirst() {
                if row[columnIndex - 1] == "1" && cell == "1" {
                    let set = sets[rowIndex][columnIndex]
                    let prevSet = sets[rowIndex][columnIndex - 1]
                    set.union(prevSet)
                }
            }
        }
        
        // for each column
        // - for each row 1..<n
        //   - if the previous row on this column is an island, and this one is, union them.
        let numColumns = firstRow.count
        for columnIndex in 0..<numColumns {
            for rowIndex in 1..<numRows {
                if grid[rowIndex - 1][columnIndex] == "1" && grid[rowIndex][columnIndex] == "1" {
                    let set = sets[rowIndex][columnIndex]
                    let prevSet = sets[rowIndex - 1][columnIndex]
                    set.union(prevSet)
                }
            }
        }
        
        
        // for each row
        // - for each column
        //   - get the head of the set using find() and put it into a set
        var heads = Set<UnionFind>()
        
        for columnIndex in 0..<numColumns {
            for rowIndex in 0..<numRows {
                if grid[rowIndex][columnIndex] == "0" {
                    continue
                }
                let set = sets[rowIndex][columnIndex]
                let head = set.find()
                heads.insert(head)
            }
        }
        
        // Return the number of items in the set
        return heads.count
    }
}
