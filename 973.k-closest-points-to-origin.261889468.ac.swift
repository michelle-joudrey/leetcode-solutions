struct Heap<T: Comparable> {
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
    
    init(kind: Kind, count: Int) {
        switch kind {
        case .min:
            inOrder = (<)
        case .max:
            inOrder = (>)
        }
        array = Array(repeating: nil, count: count)
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
    
    /// 1.) insert element at the end
    /// 2.) swap with parent while element < parent
    mutating func insert(_ element: T) {
        // Check that we have space available
        assert(!isFull)
        count += 1
        
        // insert the element at the end
        var elementIndex = count - 1
        array[elementIndex] = element
        
        // bubble up the element while a violation exists
        while let parentIndex = self.parentIndex(of: elementIndex)  {
            // compare with parent (a parent always exists)
            let parent = array[parentIndex]!
            if inOrder(parent, element) {
                // no violation exists, we are done
                return
            }
            // violation detected: swap element with its parent, and go agane
            array[parentIndex] = element
            array[elementIndex] = parent
            elementIndex = parentIndex
        }
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
        array[index] = lastElement
        // remove the last element since we moved it
        array[count - 1] = nil
        
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
            array[minChildIndex] = element
            array[elementIndex] = minChild
            // continue checking violations on child
            elementIndex = minChildIndex
        }
    }
}

struct MaxHeap<T: Comparable> {
    var heap: Heap<T>
    
    init(count: Int) {
        heap = Heap(kind: .max, count: count)
    }
    
    var isFull: Bool {
        return heap.isFull
    }
    
    var array: [T?] {
        return heap.array
    }
    
    var max: T? {
        return heap.first
    }
    
    mutating func insert(_ element: T) {
        heap.insert(element)
    }
    
    mutating func removeMax() {
        heap.remove(at: 0)
    }
}

struct Coordinate: Comparable {
    let x: Int
    let y: Int
    let distance: Double
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        distance = sqrt(pow(Double(x), 2.0) + pow(Double(y), 2.0))
    }
    static func <(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.distance < rhs.distance
    }
}

class Solution {
    func kClosest(_ points: [[Int]], _ K: Int) -> [[Int]] {
        var heap = MaxHeap<Coordinate>(count: K)
        for point in points {
            let coordinate = Coordinate(x: point[0], y: point[1])
            if heap.isFull {
                let max = heap.max!
                if coordinate < max {
                    heap.removeMax()
                } else {
                    continue
                }
            }
            heap.insert(coordinate)
        }
        return heap.array.compactMap { $0.map { [$0.x, $0.y] } }
    }
}
