/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.left = nil
 *         self.right = nil
 *     }
 * }
 */
class Solution {
    func countNodes(_ root: TreeNode?) -> Int {
        return root.map(countNodes2) ?? 0
    }
    
    // iterative
    func countNodes2(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        var stack = [root]
        var sum = 0
        while !stack.isEmpty {
            sum += 1
            let last = stack.removeLast()
            if let left = last.left {
                stack.append(left)
            }
            if let right = last.right {
                stack.append(right)
            }
        }
        return sum
    }
    
    /* 
    // recursive
    func countNodes2(_ root: TreeNode) -> Int {
        let left = root.left.map(countNodes2) ?? 0
        let right = root.right.map(countNodes2) ?? 0
        return 1 + left + right
    }*/
}
