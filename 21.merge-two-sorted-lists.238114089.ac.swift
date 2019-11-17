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
    // merge two sorted linked lists, so that the final link list is also sorted
    // The returned list contains copies of the original elements
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var outNode: ListNode? = nil
        var outHead = outNode
        
        var nodeA: ListNode? = l1
        var nodeB: ListNode? = l2
        
        func append(_ newNode: ListNode?) {
            if let _outNode = outNode {
                _outNode.next = newNode
                outNode = newNode
            } else {
                outHead = newNode
                outNode = outHead
            }            
        }
        
        while let _nodeA = nodeA, let _nodeB = nodeB {
            let val: Int
            if _nodeA.val < _nodeB.val {
                val = _nodeA.val
                nodeA = _nodeA.next
            } else {
                val = _nodeB.val
                nodeB = _nodeB.next
            }
            append(ListNode(val))
        }
        
        while let _nodeA = nodeA {
            let newNode = ListNode(_nodeA.val)
            append(newNode)
            nodeA = _nodeA.next
        }
        while let _nodeB = nodeB {
            let newNode = ListNode(_nodeB.val)
            append(newNode)
            nodeB = _nodeB.next
        }   
        return outHead
    }
}
