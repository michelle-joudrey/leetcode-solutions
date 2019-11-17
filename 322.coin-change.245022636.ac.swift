class Solution {
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

        var endIndex: Int {
            return (firstIndex + count) % storageCount
        }

        func enqueue(_ t: T) {
            assert(count != storageCount, "Queue is full")
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
    
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        var visited = Array(repeating: false, count: amount + 1)
        var queue = Queue(repeating: 0, count: amount + 1)
        queue.enqueue(0)
        // Height of the tree
        var height = 0
        while !queue.isEmpty {
            // Keep track of count so that we can process all nodes at this height.
            var count = queue.count
            while count != 0 {
                // Get a node.
                let node = queue.dequeue()
                if node == amount {
                    return height
                }
                // Add any valid children nodes that haven't yet been checked.
                for coin in coins {
                    let amt = node + coin
                    if amt > amount {
                        continue
                    }
                    if visited[amt] {
                        continue
                    }
                    visited[amt] = true
                    queue.enqueue(amt)
                }
                count -= 1
            }
            height += 1
        }
        return -1
    }
}
