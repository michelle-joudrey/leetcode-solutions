class Solution {
        // We'll keep a list of all the indices used in the current window.
        // - For i in the list, s[i] is in t.
        
        // We'll keep track of how many of each character are in the list.
        // - We'll use this info to evict indices that are no longer needed.
        //   - e.g. If both T and our list contains 2 'E's, and s[i] is 'E', we'll remove the
        //     'E' with the lowest index from our list, and add i to our list.
        //     - Note that arbitrary deletions from our list will require a doubly-linked list.
        //   - To keep track of which index we should remove, each character
        //     will have an associated queue of list nodes (retrieved via dictionary lookup).
        //     - Removing the first is O(1). Adding the new index is O(1).
    
        // We'll keep track of the number of indices in the list.
        // - if the number is T.count, then we'll find the window length via 
        //   last.value - first.value
        // - This works particularly well since the list is implicitly sorted.
    
    class Queue<T> {
        private let initialValue: T
        private let storageCount: Int

        private var storage: [T]
        private var firstIndex: Int
        private(set) var count: Int

        init(repeating t: T, count: Int) {
            storage = [T](repeating: t, count: count)
            firstIndex = 0
            initialValue = t
            self.count = 0
            self.storageCount = count
        }
        
        var isEmpty: Bool {
            return count == 0
        }
        
        var isFull: Bool {
            return count == storageCount
        }

        var endIndex: Int {
            return (firstIndex + count) % storageCount
        }

        func enqueue(_ t: T) {
            assert(!isFull, "Queue is full")
            storage[endIndex] = t
            count += 1
        }

        func dequeue() -> T {
            assert(count != 0, "Queue is empty")
            let element = storage[firstIndex]
            storage[firstIndex] = initialValue
            firstIndex = (firstIndex + 1) % storageCount
            count -= 1
            return element
        }
    }
    
    class ListNode<T> {
        var val: T
        var next: ListNode?
        var prev: ListNode?
        init(_ val: T) {
            self.val = val
        }
    } 

    // Linked list abstraction.
    class List<T> {
        var first: ListNode<T>?
        var last: ListNode<T>?
        var count: Int = 0

        func append(_ node: ListNode<T>) {
            count += 1
            // last <-> node
            node.prev = last
            last?.next = node
            // update last, and first if necessary.
            last = node
            if first == nil {
                first = node
            }
        }

        func remove(_ node: ListNode<T>) {
            count -= 1
            // Do we need to update first?
            if node === first {
                first = node.next
            }
            // Do we need to update last?
            if node === last {
                last = node.prev
            }
            // prev <-> next
            node.prev?.next = node.next
            node.next?.prev = node.prev
        }
    }
    
    // Time & Space = O(N)
    func minWindow(_ s: String, _ t: String) -> String {
        let tCount = t.count
        
        // Figure out how large we need our queue for each character to be.
        var numOccurrences = [Character: Int]()
        for char in t {
            numOccurrences[char, default: 0] += 1
        }
        // Create the queues
        var queues = [Character: Queue<ListNode<Int>?>]()
        for (char, count) in numOccurrences {
            queues[char] = Queue(repeating: nil, count: count)
        }
        // Create our doubly-linked list.
        let list = List<Int>()
        var minWindowStartIndex = 0
        var minWindowSize = Int.max
        
        // Enumerate s.
        for (i, char) in s.enumerated() {
            // Is this char in T?
            guard let queue = queues[char] else {
                continue
            }
            // Do we need to remove a char?
            if queue.count == numOccurrences[char] {
                // Remove the first node in the queue and remove it from the list.
                let node = queue.dequeue()!
                list.remove(node)
            }
            // Append this index to the list and the queue.
            let node = ListNode(i)
            list.append(node)
            queue.enqueue(node)
            // Update the min window size if necessary.
            if list.count != tCount {
                continue
            }
            let windowStartIndex = list.first!.val
            let windowSize = list.last!.val - list.first!.val + 1
            if windowSize < minWindowSize {
                minWindowStartIndex = windowStartIndex
                minWindowSize = windowSize
            }
        }
        
        if minWindowSize == Int.max {
            return ""
        }
        let startIndex = s.index(s.startIndex, offsetBy: minWindowStartIndex)
        let endIndex = s.index(startIndex, offsetBy: minWindowSize)
        return String(s[startIndex..<endIndex])
    }
}
