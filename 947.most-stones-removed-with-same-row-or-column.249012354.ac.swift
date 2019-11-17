struct Node {
    let index: Int
    var parentIndex: Int
    var count: Int
    
    init(index: Int) {
        self.index = index
        self.count = 1
        self.parentIndex = index
    }
}

extension Array where Element == Node {
    // Find the index of the root node of node nodes[i]
    mutating func find(_ i: Int) -> Int {
        var nodeIndex = i
        // The node that points to itself is the root.
        while case let parentIndex = self[nodeIndex].parentIndex, nodeIndex != parentIndex {
            nodeIndex = parentIndex
        }
        // Path compression:
        // Point this node to the root.
        self[i].parentIndex = nodeIndex
        return nodeIndex
    }
    
    // Merges the sets if they are unmerged.
    mutating func union(_ lhsIndex: Int, _ rhsIndex: Int) {
        let lhsRootIndex = find(lhsIndex)
        let rhsRootIndex = find(rhsIndex)
        // Are they already merged?
        if lhsRootIndex == rhsRootIndex {
            return
        }
        // rhsRoot -> lhsRoot
        self[rhsRootIndex].parentIndex = lhsRootIndex
        self[lhsRootIndex].count += self[rhsRootIndex].count
    }
}

class Solution {
    func removeStones(_ stones: [[Int]]) -> Int {
        // # Create a set containing each stone.
        var nodes = stones.indices.map(Node.init)
        
        // # Merge sets with the same x coordinate
        // 1. Group nodes by x-coordinate
        var nodesForX = [Int: [Int]]()
        for i in nodes.indices {
            let stone = stones[i]
            let (x, _) = (stone[0], stone[1])
            nodesForX[x, default: [Int]()].append(i)
        }
        // 2. Perform merging
        for (_, nodesX) in nodesForX {
            // Merge all nodes in nodes
            guard let mergedSetIndex = nodesX.first else {
                continue
            }
            // The nodes will always be in separate sets.
            for i in nodesX.dropFirst() {
                nodes.union(mergedSetIndex, i)
            }
        }
        
        // # Merge sets with the same y coordinate.
        // 1. Group nodes by y-coordinate
        var nodesForY = [Int: [Int]]()
        for i in nodes.indices {
            let stone = stones[i]
            let (_, y) = (stone[0], stone[1])
            nodesForY[y, default: [Int]()].append(i)
        }
        // 2. Perform merging
        for (_, nodesY) in nodesForY {
            // Merge all nodes in nodes
            guard let mergedSetIndex = nodesY.first else {
                continue
            }
            // Merge the nodes if they aren't already.
            for i in nodesY.dropFirst() {
                nodes.union(mergedSetIndex, i)
            }
        }
        
        // # Get the set of sets.
        var rootIndices = [Bool](repeating: false, count: 1000)
        for i in nodes.indices {
            let rootIndex = nodes.find(i)
            rootIndices[rootIndex] = true
        }
        
        // Get the count of connected components
        var count = 0
        for i in rootIndices.indices {
            if rootIndices[i] {
                count += nodes[i].count - 1
            }
        }
        return count
    }
}
