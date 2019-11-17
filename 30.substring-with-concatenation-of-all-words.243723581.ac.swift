class Solution {
    class Trie {
        var timesUsable = 0
        var timesUsed = 0
        var indexUsedFor = -1
        var isLeaf = true
        var children = [Trie?](repeating: nil, count: 26)

        private static let valueOfA = UInt8(Character("a").asciiValue!)
        func indexForChar(_ char: UInt8) -> Int {
            return Int(char - Trie.valueOfA)
        }

        func addWord(_ word: UnsafeBufferPointer<UInt8>) {
            var node = self
            isLeaf = false

            var addr = word.baseAddress!
            let end = word.baseAddress! + word.count
            while addr != end {
                let char = addr.pointee
                if let child = node.child(for: char) {
                    node = child
                } else {
                    let child = Trie()
                    let index = indexForChar(char)
                    node.children[index] = child
                    node.isLeaf = false
                    node = child
                }
                node.timesUsable += 1
                addr += 1
            }
        }

        func child(for char: UInt8) -> Trie? {
            let index = indexForChar(char)
            return children[index]
        }
    }
    
    func findSubstring(_ s: String, _ words: [String]) -> [Int] {
        let root = Trie()
        for word in words {
            word.utf8.withContiguousStorageIfAvailable { x in
                root.addWord(x)
            }
        }
        
        let n = s.count
        var indices = [Int]()
        
        s.utf8.withContiguousStorageIfAvailable { s in
            for i in 0..<n  {
                // Note this prevents retain and release.
                unowned(unsafe) var node = root
                var numWordsMatched = 0
                var j = i
                while numWordsMatched != words.count {
                    guard j < n, let child = node.child(for: s[j]) else {
                        break // fail.
                    }
                    if child.isLeaf {
                        if child.indexUsedFor != i {
                            child.timesUsed = 0
                            child.indexUsedFor = i
                        }
                        if child.timesUsed == child.timesUsable {
                            break // fail.
                        } else {
                            child.timesUsed += 1
                            numWordsMatched += 1
                            node = root
                        }
                    } else {
                        node = child
                    }
                    j += 1
                }
                if numWordsMatched == words.count && !words.isEmpty {
                    indices.append(i)
                }
            }
        }
        return indices
    }
}
