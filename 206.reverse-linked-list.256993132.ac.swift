/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *     }
 * }
 */
class Solution {
        // 1 -> 2 -> 3
    func reverseList(_ head: ListNode?) -> ListNode? {
        var node = head
        var prev: ListNode?
        while let _node = node {
            let next = _node.next
            _node.next = prev
            node = next
            prev = _node
        }
        return prev
    }
}
