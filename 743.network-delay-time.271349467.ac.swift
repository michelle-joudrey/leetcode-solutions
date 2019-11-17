import Foundation

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
    
    private mutating func insertValue(_ value: T, at index: Int) {
        array[index] = value
        indexForValue[value] = index
    }
    
    private mutating func swapValues(_ lhsIndex: Int, _ rhsIndex: Int) {
        let lhs = array[lhsIndex]!
        let rhs = array[rhsIndex]!
        array[lhsIndex] = rhs
        array[rhsIndex] = lhs
        indexForValue[lhs] = rhsIndex
        indexForValue[rhs] = lhsIndex
    }
    
    private mutating func removeValue(at index: Int) {
        let value = array[index]!
        array[index] = nil
        indexForValue[value] = index
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
            swapValues(index, parentIndex)
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
        let elementIndex = count - 1
        insertValue(element, at: elementIndex)
        heapifyUp(index: elementIndex)
    }
    
    /// 1.) replace array[index] with array[last]
    /// 2.) set array[last] = nil
    /// 3.) swap with minChild while element > minChild
    mutating func remove(at index: Int) {
        // crash if the array is empty
        assert(count > 0)
        defer { count -= 1 }
        
        let lastElement = array[count - 1]!
        
        // swap the element at `index` with the last element
        swapValues(index, count - 1)
        
        // remove the new last element
        removeValue(at: count - 1)
        
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
            swapValues(elementIndex, minChildIndex)
            // continue checking violations on child
            elementIndex = minChildIndex
        }
    }
}

class Vertex: Comparable, Hashable, CustomStringConvertible {
    let index: Int // This is just here for debugging.
    var time = Int.max
    var via: Vertex?
    var processed = false
    var visited = false
    
    init(index: Int) {
        self.index = index
    }
    
    static func <(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    var description: String {
        return "i: \(index), time: \(time)"
    }
}

struct Edge {
    let to: Vertex
    let time: Int
}

class Solution {
    func networkDelayTime(_ inputTimes: [[Int]], _ N: Int, _ startVertex: Int) -> Int {
        var vertices = [Vertex]()
        for i in 0..<N {
            let vertex = Vertex(index: i)
            vertices.append(vertex)
        }
        vertices[startVertex - 1].time = 0
        
        var edges = [Vertex: [Edge]]()
        for time in inputTimes {
            // Convert the from/to vertex numnbers to vertex indices
            let (from, to, time) = (time[0] - 1, time[1] - 1, time[2])
            let fromVertex = vertices[from]
            let toVertex = vertices[to]
            let edge = Edge(to: toVertex, time: time)
            edges[fromVertex, default: .init()].append(edge)
        }
        
        // Setup the heap with all of the vertices.
        var heap = Heap<Vertex>(kind: .min, capacity: N)
        let startVertex = vertices[startVertex - 1]
        heap.insert(startVertex)
        
        // Dijsktra's Algorithm:
        // 1. Get the unprocessed vertex with the shortest time value.
        // 2. Visit each of its unprocessed neighbors, updating their time if necessary.
        // 3. Mark this vertex as processed.
        while let minVertex = heap.first {
            minVertex.processed = true
            heap.remove(at: 0)
            
            guard let edges = edges[minVertex] else {
                // If the vertex has no outgoing edges, just remove it.
                continue
            }
            for edge in edges {
                let neighbor = edge.to
                if neighbor.processed {
                    continue
                }
                // Calculate the time to get to this neighbor.
                let newTimeToNeighbor = minVertex.time + edge.time
                neighbor.time = min(neighbor.time, newTimeToNeighbor)
                if neighbor.visited {
                    // Update the neighbor's place in the min heap since we modified its time.
                    heap.decreaseKey(neighbor)
                } else {
                    neighbor.visited = true
                    heap.insert(neighbor)
                }
            }
            continue
        }
        let max = vertices.map { $0.time }.max()
        if max == Int.max {
            return -1
        }
        return max ?? 0
    }
}
