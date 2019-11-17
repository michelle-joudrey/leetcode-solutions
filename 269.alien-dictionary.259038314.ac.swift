class Solution {
    func groupWords<T>(_ words: [T]) -> [[T]] where T: Collection, T.Element == Character {
        var wordGroups = [[T]]()
        var wordGroup = [T]()
        for word in words {
            if word.isEmpty {
                continue
            }
            // do we need to start a new word group?
            if !wordGroup.isEmpty && wordGroup.first!.first! != word.first! {
                // Yes, add the current group to the word groups.
                wordGroups.append(wordGroup)
                // Create a new word group.
                wordGroup = [word]
            } else {
                // No, just add the word to the current group.
                wordGroup.append(word)
            }
        }
        if !wordGroup.isEmpty {
            wordGroups.append(wordGroup)
        }
        return wordGroups
    }
    
    typealias AdjacencyList = [Character: [Character]]
    
    func alienOrder(_ words: [String]) -> String {
        // For each character, which character comes next?
        var adjacencyList = AdjacencyList()
        alienOrder(words, &adjacencyList)
        
        // Get the alphabet.
        var alphabet = Set<Character>()
        for word in words {
            let chars = Array(word)
            for char in chars {
                alphabet.insert(char)
            }
        }        
        // Topological sort the chars.
        enum State {
            case unvisited
            case processing
            case processed
        }
        var charState = [Character: State]()
        
        enum DFSError: Error {
            case cycleDetected
        }
        
        var charOrder = [Character]()
        func DFS(_ char: Character) throws {
            // Have we already visited this char?
            let state = charState[char, default: .unvisited]
            if state == .processed {
                return
            }
            
            // visit the next chars (if applicable)
            let nextChars = adjacencyList[char] ?? []
            for char in nextChars {
                let state = charState[char, default: .unvisited]
                switch state {
                case .unvisited:
                    charState[char] = .processing
                case .processing:
                    throw DFSError.cycleDetected
                case .processed:
                    continue
                }
                try DFS(char)
            }
            // mark this one as processed
            charState[char] = .processed
            // add it to our list
            charOrder.append(char)
        }
        
        
        for char in alphabet {
            do {
                try DFS(char)
            } catch {
                // Cycle detected
                return ""
            }
        }
        return String(charOrder.reversed())
    }
    
    func alienOrder<T>(_ words: [T], _ adjacencyList: inout AdjacencyList) where T: Collection, T.Element == Character {
        // Create an array of each group of words.
        // Words will be grouped by their first letter.
        let wordGroups = groupWords(words)
        
        // Create edges between vertices (e.g. w -> e -> r)
        for (i, group) in wordGroups.enumerated() {
            // Is there a next word group?
            if i + 1 < wordGroups.count {
                // Add an edge.
                let currentLetter = group.first!.first!
                let nextLetter = wordGroups[i + 1].first!.first!
                adjacencyList[currentLetter, default: .init()].append(nextLetter)
            }
            
            // Remove the first letter and recurse on this group
            let group = group.map { $0.dropFirst() }
            alienOrder(group, &adjacencyList)
        }
    }
}
