struct Heap<T: Hashable & Comparable> {
    var array: [T?]
    private var count = 0
    private let inOrder: (T, T) -> Bool
    
    enum Kind {
        case min
        case max
    }
    
    var isFull: Bool {
        return count == array.count
    }
    
    init(kind: Kind, capacity: Int) {
        switch kind {
        case .min:
            inOrder = (<)
        case .max:
            inOrder = (>)
        }
        array = Array(repeating: nil, count: capacity)
    }
    
    private func childIndex(of index: Int) -> Int? {
        let childIndex = (index * 2) + 1
        if childIndex >= count {
            return nil
        }
        return childIndex
    }
    
    private func childRightOf(_ index: Int) -> Int? {
        let newIndex = index + 1
        if newIndex >= count {
            return nil
        }
        return newIndex
    }
    
    private func parentIndex(of index: Int) -> Int? {
        if index == 0 {
            return nil
        }
        return (index - 1) / 2
    }
    
    var first: T? {
        return array.first?.flatMap { $0 }
    }
    
    private var indexForValue = [T: Int]()
    
    private mutating func setValue(_ value: T?, at index: Int) {
        let oldValue = array[index]
        array[index] = value
        if value == nil {
            if let oldValue = oldValue {
                indexForValue[oldValue] = nil
            }            
        }
    }
    
    mutating func decreaseKey(_ value: T) {
        let index = indexForValue[value]!
        heapifyUp(index: index)
    }
    
    private mutating func heapifyUp(index: Int) {
        var index = index
        // bubble up the element while a violation exists
        while let parentIndex = self.parentIndex(of: index)  {
            let element = array[index]!
            // compare with parent (a parent always exists)
            let parent = array[parentIndex]!
            if inOrder(parent, element) {
                // no violation exists, we are done
                return
            }
            // violation detected: swap element with its parent, and go agane
            setValue(element, at: parentIndex)
            setValue(parent, at: index)
            index = parentIndex
        }
    }
    
    /// 1.) insert element at the end
    /// 2.) swap with parent while element < parent
    mutating func insert(_ element: T) {
        // Check that we have space available
        assert(!isFull)
        count += 1
        
        // insert the element at the end
        var elementIndex = count - 1
        array[elementIndex] = element
        heapifyUp(index: elementIndex)
    }
    
    /// 1.) replace array[index] with array[last]
    /// 2.) set array[last] = nil
    /// 3.) swap with minChild while element > minChild
    mutating func remove(at index: Int) {
        // crash if the array is empty
        assert(count != 0)
        defer { count -= 1 }
        
        let lastElement = array[count - 1]!
        // replace the element at `index` with the last element
        setValue(lastElement, at: index)
        // remove the last element since we moved it
        setValue(nil, at: count - 1)
        
        // sink the element while a violation exists
        var elementIndex = index
        let element = lastElement
        while true {
            let leftChildIndex = childIndex(of: elementIndex)
            let rightChildIndex = leftChildIndex.flatMap(childRightOf)
            let minChild: T
            let minChildIndex: Int
            
            let leftChild = leftChildIndex.flatMap { array[$0] }
            let rightChild = rightChildIndex.flatMap { array[$0] }
            
            switch (leftChild, rightChild) {
            case (.some(let leftChild), .some(let rightChild)):
                if inOrder(leftChild, rightChild) {
                    minChild = leftChild
                    minChildIndex = leftChildIndex!
                } else {
                    minChild = rightChild
                    minChildIndex = rightChildIndex!
                }
            case (.some(let leftChild), .none):
                minChild = leftChild
                minChildIndex = leftChildIndex!
            case (.none, .some(let rightChild)):
                minChild = rightChild
                minChildIndex = rightChildIndex!
            case (.none, .none):
                // this node has no children, so no violation can exist
                return
            }
            if inOrder(element, minChild) {
                // no violation detected, we are done
                return
            }
            // violation detected: swap element with its child
            setValue(element, at: minChildIndex)
            setValue(minChild, at: elementIndex)
            // continue checking violations on child
            elementIndex = minChildIndex
        }
    }
}

class Vertex: Comparable, Hashable {
    var pathLength = Int.max
    let i: Int
    let j: Int
    init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }
    
    static func <(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.pathLength < rhs.pathLength
    }
    
    static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
}

class Solution {
    func minPathSum(_ grid: [[Int]]) -> Int {
        if grid.isEmpty || grid[0].isEmpty {
            return 0
        }
        let numRows = grid.count
        let numCols = grid.first?.count ?? 0
        var minHeap = Heap<Vertex>(kind: .min, capacity: numRows * numCols)
        
        var vertices = [[Vertex]]()
        for i in grid.indices {
            var row = [Vertex]()
            for j in grid[i].indices {
                let vertex = Vertex(i: i, j: j)
                row.append(vertex)
            }
            vertices.append(row)
        }
        
        var startVertex = vertices[0][0]
        startVertex.pathLength = grid[0][0]
        minHeap.insert(startVertex)
        
        while let vertex = minHeap.first {
            minHeap.remove(at: 0)
            if vertex.i == numRows - 1 && vertex.j == numCols - 1 {
                return vertex.pathLength
            }
            var neighbors = [Vertex]()
            // does a right vertex exist?
            if vertex.j + 1 < numCols {
                let rightVertex = vertices[vertex.i][vertex.j + 1]
                neighbors.append(rightVertex)
            }
            // does a vertex exist below?
            if vertex.i + 1 < numRows {
                let belowVertex = vertices[vertex.i + 1][vertex.j]
                neighbors.append(belowVertex)
            }
            // check if the new distance is better.
            for neighbor in neighbors {
                let newLength = vertex.pathLength + grid[neighbor.i][neighbor.j]
                if newLength < neighbor.pathLength {
                    // two cases: neighbor might be in min heap already.
                    // If the neighbnor isn't in the min heap, then it's pathLength will be max
                    if neighbor.pathLength == Int.max {
                        neighbor.pathLength = newLength
                        minHeap.insert(neighbor)
                    } else {
                        neighbor.pathLength = newLength
                        minHeap.decreaseKey(neighbor)
                    }
                }
            }
        }
        fatalError()
    }
}
