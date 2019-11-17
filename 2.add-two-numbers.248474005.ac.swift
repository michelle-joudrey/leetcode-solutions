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
    // (a, b, c) + (d, e, f) = (u, v, w)
    // w = (c + f) % 10, carry = (c + f) / 10
    // v = (b + v + carry) % 10, carry = (b + v + carry) / 10
    // u = (a + d + carry) % 10, carry = (a + d + carry) / 10
    // etc. 
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var carry = 0
        var a = l1
        var b = l2
        var cFirst: ListNode? = nil
        var cLast: ListNode? = nil
        
        // Use a trick for padding the nodes
        while a != nil || b != nil {
            let aVal = a ?? ListNode(0)
            let bVal = b ?? ListNode(0)
                        
            // calculate digit and carry
            let sum = aVal.val + bVal.val + carry
            let digit = sum % 10
            carry = sum / 10
            
            // create a new node
            let node = ListNode(digit)
            if let last = cLast {
                last.next = node
                cLast = node
            } else {
                cLast = node
                cFirst = node
            }
            
            // end of loop
            a = aVal.next
            b = bVal.next
        }
        if carry != 0 {
            let node = ListNode(1)
            cLast!.next = node // cLast must exist since a carry is present
        }
        return cFirst
    }
}
