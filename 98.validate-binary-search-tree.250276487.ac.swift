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
    // LNR
    func inOrder(_ root: TreeNode?, process: (Int) -> ()) {
        guard let root = root else {
            return
        }
        inOrder(root.left, process: process)
        process(root.val)
        inOrder(root.right, process: process)
    }
    
    func isValidBST(_ root: TreeNode?) -> Bool {
        var sorted = true
        var previousValue: Int?
        func process(_ value: Int) {
            if let _prev = previousValue, value <= _prev {
                sorted = false
            }
            previousValue = value
        }
        inOrder(root, process: process)
        return sorted
    }
}
