//    a             0
//  b   c       1       2
// d e f g    3   4   5   6
//           7 8 9 a b c d e

// first child index formula:
// f(0) = 1
// f(1) = 3
// f(2) = 5
// f(3) = 7
// f(4) = 9
// f(5) = 11
// f(6) = 13
// f(x) = 2 * x + 1

// parent index formula:
// 0: no parent
// f(1) = 0
// f(2) = 0
// f(3) = 1
// f(4) = 1
// f(5) = 2
// f(6) = 2
// f(x) = (x - 1) / 2

struct Heap<T: Comparable>: CustomDebugStringConvertible {
    private var array: [T?]
    /// The index of the last element in array, or nil
    private var lastIndex: Int?
    private let inOrder: (T, T) -> Bool
    
    enum Kind {
        case min
        case max
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
        guard let lastIndex = lastIndex else {
            return nil
        }
        let childIndex = (index * 2) + 1
        if childIndex > lastIndex {
            return nil
        }
        return childIndex
    }
    
    private func childRightOf(_ index: Int) -> Int? {
        guard let lastIndex = lastIndex else {
            return nil
        }
        let newIndex = index + 1
        if newIndex > lastIndex {
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
        guard let lastIndex = lastIndex else {
            self.lastIndex = 0
            array[0] = element
            return
        }
        
        // insert the element at the end
        var elementIndex = lastIndex + 1
        array[elementIndex] = element
        // update lastIndex since we added an element
        self.lastIndex = elementIndex
        
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
        let lastIndex = self.lastIndex!
        let lastElement = array[lastIndex]!
        
        // replace the element at `index` with the last element
        array[index] = lastElement
        // remove the last element since we moved it
        array[lastIndex] = nil
        
        // update lastIndex since we are removing an element
        if lastIndex == 0 {
            self.lastIndex = nil
        } else {
            self.lastIndex = lastIndex - 1
        }
        
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
    
    var debugDescription: String {
        return "\(array)"
    }
}

struct MinHeap<T: Comparable>: CustomDebugStringConvertible {
    var heap: Heap<T>
    
    init(count: Int) {
        heap = Heap(kind: .min, count: count)
    }
    
    func min() -> T? {
        return heap.first
    }
    
    mutating func insert(_ element: T) {
        heap.insert(element)
    }
    
    mutating func removeMin() {
        heap.remove(at: 0)
    }
    
    var debugDescription: String {
        return heap.debugDescription
    }
}

extension ListNode: Comparable {
    public static func <(lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val < rhs.val
    }
    public static func ==(lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val == rhs.val
    }
}


class Solution {
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        let lists = lists.compactMap { $0 }
        var heap = MinHeap<ListNode>(count: lists.count)
        // insert all of the heads into the heap
        for list in lists {
            heap.insert(list)
        }
        var outputHead: ListNode? = nil
        var outputLast: ListNode? = nil
        // remove the min list, re-insert its next
        while let min = heap.min() {
            heap.removeMin()
            if let next = min.next {
                heap.insert(next)
            }
            if let _outputLast = outputLast {
                _outputLast.next = ListNode(min.val)
                outputLast = _outputLast.next
            } else {
                outputHead = ListNode(min.val)
                outputLast = outputHead
            }
        }
        return outputHead
    }
}
