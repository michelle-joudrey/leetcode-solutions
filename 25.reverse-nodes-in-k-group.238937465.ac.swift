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

class List {
    var head: ListNode?
    var last: ListNode?
    var count: Int = 0
    
    // note that this erases node.next
    func append(_ node: ListNode) {
        count += 1
        node.next = nil
        guard let last = last else {
            self.head = node
            self.last = node
            return
        }
        // last -> node
        last.next = node
        self.last = node
    }
    
    // note that this erases node.next
    func prepend(_ node: ListNode) {
        count += 1
        node.next = nil
        guard let head = head else {
            self.head = node
            self.last = node
            return
        }
        // node -> head
        node.next = head
        self.head = node
    }
    
    func reverse() {
        let list = List()
        var node = head
        while let _node = node {
            // note that prepend modifies _node.next
            node = _node.next
            list.prepend(_node)
        }
        self.head = list.head
        self.last = list.last
    }
    
    func appendList(_ list: List) {
        last?.next = list.head
        last = list.last
    }
}

class Solution {
    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
        var currentList = List()
        var outputList = currentList
        var currentNode = head
        while true {
            guard let _currentNode = currentNode else {
                currentList.reverse()
                if outputList !== currentList {
                    outputList.appendList(currentList)
                }
                return outputList.head
            }
            let next = _currentNode.next
            // note that prepend modifies _currentNode.next
            currentList.prepend(_currentNode)
            if currentList.count == k {
                outputList.appendList(currentList)
                currentList = List()
            }
            currentNode = next
        }
    }
}
