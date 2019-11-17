class AVLTree<Key: Comparable, Value> {
    var root: AVLTreeNode<Key, Value>?
    
    var count: Int {
        return root?.count ?? 0
    }
    
    func insert(_ value: Value, forKey key: Key) {
        if let root = root {
            self.root = root.insert(value, forKey: key)
        } else {
            root = AVLTreeNode(key: key, value: value)
        }
    }
    
    func find(_ key: Key) -> Value? {
        return root?.find(key)
    }
}

class AVLTreeNode<Key: Comparable, Value> {
    let key: Key
    let value: Value
    var leftChild: AVLTreeNode?

    var rightChild: AVLTreeNode?
    
    private(set) var height: Int = 1
    private(set) var count: Int = 1
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
    
    var balance: Int {
        return (rightChild?.height ?? 0) - (leftChild?.height ?? 0)
    }
    
    var isRightHeavy: Bool {
        return balance > 0
    }
    
    var isLeftHeavy: Bool {
        return balance < 0
    }
    
    var needsBalancing: Bool {
        return balance < -1 || balance > 1
    }
    
    // Returns the new root of the (sub)tree.
    func insert(_ value: Value, forKey key: Key, parent: AVLTreeNode? = nil) -> AVLTreeNode? {
        if key == self.key {
            fatalError()
        } else if key < self.key {
            if let leftChild = leftChild {
                _ = leftChild.insert(value, forKey: key, parent: self)
            } else {
                leftChild = AVLTreeNode(key: key, value: value)
            }
        } else {
            if let rightChild = rightChild {
                _ = rightChild.insert(value, forKey: key, parent: self)
            } else {
                rightChild = AVLTreeNode(key: key, value: value)
            }
        }
        if !needsBalancing {
            // Update the height & count on the way back up since a node was inserted.
            updateHeight()
            updateCount()
            return self
        }
        // Otherwise, rebalance() will update the heights and counts of affected nodes.
        let newSubtreeRoot = rebalance()
        // Update the parent node if necessary.
        if self === parent?.leftChild {
            parent?.leftChild = newSubtreeRoot
        } else if self === parent?.rightChild {
            parent?.rightChild = newSubtreeRoot
        } else {
            return newSubtreeRoot
        }
        return self
    }
    
    func find(_ key: Key) -> Value? {
        if key == self.key {
            return value
        } else if key < self.key {
            return leftChild?.find(key)
        } else {
            return rightChild?.find(key)
        }
    }
    
    // MARK: - Private helpers
    
    private func updateCount() {
        count = 1 + (leftChild?.count ?? 0) + (rightChild?.count ?? 0)
    }
    
    private func updateHeight() {
        height = 1 + max(leftChild?.height ?? 0, rightChild?.height ?? 0)
    }
    
    //     c                 b
    //    /                /  \
    //   b     ---->      a    c
    //  /
    // a
    private func rotateRight() -> AVLTreeNode {
        let c = self
        let b = leftChild!
        c.leftChild = b.rightChild
        b.rightChild = c
        
        // The height & count of b depends on c, so update c first.
        c.updateHeight()
        b.updateHeight()
        c.updateCount()
        b.updateCount()
        return b
    }
    
    // a                   b
    //  \                /  \
    //   b     ---->    a    c
    //    \
    //     c
    private func rotateLeft() -> AVLTreeNode {
        let a = self
        let b = rightChild!
        a.rightChild = b.leftChild
        b.leftChild = a
        
        // The height & count of b depends on a, so update a first.
        a.updateHeight()
        b.updateHeight()
        a.updateCount()
        b.updateCount()
        return b
    }
    
    // Assumes that the tree needs rebalancing.
    private func rebalance() -> AVLTreeNode {
        if isLeftHeavy { // LL or LR
            if leftChild!.isRightHeavy { // LR -> LL
                leftChild = leftChild!.rotateLeft()
            }
            return rotateRight()
        } else { // RR or RL
            if rightChild!.isLeftHeavy { // RL -> RR
                rightChild = rightChild!.rotateRight()
            }
            return rotateLeft()
        }
    }
}

extension AVLTree: CustomStringConvertible where Key: CustomStringConvertible {
    var description: String {
        return root?.description ?? "∅"
    }
}

extension AVLTreeNode: CustomStringConvertible where Key: CustomStringConvertible {
    var description: String {
        var output = ""
        makeDescription(output: &output)
        return output
    }
    
    func makeDescription(output: inout String, prefix: String = "") {
        if !output.isEmpty {
            output += "\n"
        }
        output += prefix + key.description + " (h = \(height), b = \(balance), c = \(count))"
        if leftChild == nil && rightChild == nil {
            return
        }
        if let leftChild = leftChild {
            leftChild.makeDescription(output: &output, prefix: prefix + "--")
        } else {
            output += "\n" + prefix + "--∅"
        }
        if let rightChild = rightChild {
            rightChild.makeDescription(output: &output, prefix: prefix + "--")
        } else {
            output += "\n" + prefix + "--∅"
        }
    }
}

extension AVLTree {
    func countLessThan(_ key: Key) -> Int {
        return root?.countLessThan(key) ?? 0
    }
}

extension AVLTreeNode {
    func countLessThan(_ key: Key, runningCount: Int = 0) -> Int {
        if key == self.key {
            return runningCount + (leftChild?.count ?? 0)
        } else if key < self.key {
            return leftChild?.countLessThan(key, runningCount: runningCount) ?? runningCount
        } else {
            let runningCount = runningCount + 1 + (self.leftChild?.count ?? 0)
            return rightChild?.countLessThan(key, runningCount: runningCount) ?? runningCount
        }
    }
}

// Use a custom key to allow for duplicates in the tree. 
// This acts kind of like a floating point number.
// If we have (3, 1), (3, 2), and (3, 3) in a tree, then 
// (4, 1) will be greater than 3 elements.
struct MyKey: Comparable, CustomStringConvertible {
    let number: Int
    let instanceNumber: Int
    
    static func <(lhs: MyKey, rhs: MyKey) -> Bool {
        if lhs.number == rhs.number {
            assert(lhs.instanceNumber != rhs.instanceNumber)
            return lhs.instanceNumber < rhs.instanceNumber
        }
        return lhs.number < rhs.number
    }
    
    var description: String {
        return number.description
    }
}

class Solution {
    func countSmaller(_ nums: [Int]) -> [Int] {
        let tree = AVLTree<MyKey, Int>()
        var output = [Int]()
        let nums = nums.reversed()
        var numInstances = [Int: Int]()
        for number in nums {
            numInstances[number, default: 0] += 1
            let instanceNumber = numInstances[number]!
            let key = MyKey(number: number, instanceNumber: instanceNumber)
            tree.insert(number, forKey: key)
            let key2 = MyKey(number: number, instanceNumber: 0)
            let count = tree.countLessThan(key2)
            output.append(count)
        }
        output.reverse()
        return output
    }
}
