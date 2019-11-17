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
    func height(_ root: TreeNode?) -> (Int, Bool) {
        guard let root = root else {
            return (0, true)
        }
        let (leftHeight, leftBalanced) = height(root.left)
        let (rightHeight, rightBalanced) = height(root.right)
        let balanced = abs(leftHeight - rightHeight) <= 1 && leftBalanced && rightBalanced
        return (1 + max(leftHeight, rightHeight), balanced)
    }
    
    func isBalanced(_ root: TreeNode?) -> Bool {
        return height(root).1
    }
}
