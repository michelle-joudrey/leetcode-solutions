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
struct List {
    var first: ListNode?
    private var last: ListNode?
    
    mutating func append(_ node: ListNode) {
        node.next = nil
        // if there's a last, update it
        if let _last = last {
            _last.next = node
            last = node
            return
        }
        // if there's no last, there's no first.
        first = node
        last = node
    }
}

class Solution {
    func swapPairs(_ head: ListNode?) -> ListNode? {
        var list = List()
        var queue = [ListNode]()
        var node = head
        while let _node = node {
            node = _node.next
            queue.append(_node)
            if queue.count == 2 {
                list.append(queue[1])
                list.append(queue[0])
                queue.removeAll()
            }
        }
        if let first = queue.first {
            list.append(first)
        }
        return list.first
    }
}
