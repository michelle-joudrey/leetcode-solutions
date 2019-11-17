class LRUCache {
    
    class Node {
        var next: Node?
        var prev: Node?
        var keyValue: (key: Int, value: Int)?
    }
    
    var nodeForKey = [Int: Node]()
    var firstUnusedNode: Node?
    var lastNode: Node
    var firstNode: Node

    init(_ capacity: Int) {
        assert(capacity > 0)
        // create linked list
        // assume capacity at least 1
        firstNode = Node()
        firstUnusedNode = firstNode
        var node = firstNode
        for _ in 1..<capacity {
            let nextNode = Node()
            node.next = nextNode
            nextNode.prev = node
            node = nextNode
        }
        lastNode = node
    }
    
    func moveNodeToFront(_ node: Node) {
        guard let prev = node.prev else {
            // This node is the front node.
            // Nothing to do.
            return
        }
        // Step 1: Remove the node from the list.
        if let next = node.next {
            // Case 1: There is a next node
            // prev <-> node <-> next
            // prev <-> next
            prev.next = next
            next.prev = prev
        } else {
            // Case 2: This node is the last node.
            // before: prev -> last
            // after: prev
            prev.next = nil
            // The previous node is now the last node.
            lastNode = prev
        }
        // Step 2: Add the node to the front of the list.
        // first <-> next
        // node <-> first <-> next
        node.next = firstNode
        node.prev = nil
        firstNode.prev = node
        // This node becomes the new first node.
        firstNode = node
    }
    
    func get(_ key: Int) -> Int {
        if let node = nodeForKey[key] {
            moveNodeToFront(node)
            return node.keyValue!.value
        }
        return -1
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = nodeForKey[key] {
            // The key already exists, so we need to replace the value
            // and just move it to the front.
            node.keyValue!.value = value
            moveNodeToFront(node)
            return
        }
        
        // If all nodes are used, we need to evict the last one.
        if firstUnusedNode == nil {
            // evict last node from list and dict.
            nodeForKey.removeValue(forKey: lastNode.keyValue!.key)
            lastNode.keyValue = nil
            firstUnusedNode = lastNode
        } 
        // Now that we've evicted the last node,
        // use that node for this value, then move it to the front.
        let firstUnusedNode = self.firstUnusedNode!
        let nextUnusedNode = firstUnusedNode.next
        firstUnusedNode.keyValue = (key, value)
        nodeForKey[key] = firstUnusedNode
        moveNodeToFront(firstUnusedNode)
        
        // Update firstUnusedNode
        self.firstUnusedNode = nextUnusedNode
    }
}

/**
 * Your LRUCache object will be instantiated and called as such:
 * let obj = LRUCache(capacity)
 * let ret_1: Int = obj.get(key)
 * obj.put(key, value)
 */
