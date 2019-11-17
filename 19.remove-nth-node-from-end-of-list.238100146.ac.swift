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
    func count(_ head: ListNode?) -> Int {
        guard let head = head else {
            return 0
        }
        return 1 + count(head.next)
    }
    
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        guard let head = head else {
            return nil
        }
        let count = self.count(head)
        let index = count - n
        if index == 0 {
            return head.next
        }
        var i = 0
        var node = head
        while i != index - 1 {
            node = node.next! 
            i += 1
        }
        node.next = node.next!.next
        return head
    }
}
