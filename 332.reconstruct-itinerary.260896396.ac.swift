extension Character {
    var bucketIndex: Int {
        return Int(
            self.lowercased().first!.asciiValue! - 
            "a".lowercased().first!.asciiValue!
        )
    }
} 

class Solution {
    /// Note: This is Hierholzer's algorithm, with a slight variation for visiting neighbors
    /// in lexiographical order.
    /// Since the problem states that the first airport is always "JFK", the graph verification
    /// code isn't needed.
    
    func bucketSort(_ strings: [String]) -> [String] {
        if strings.isEmpty {
            return []
        }
        var strings = strings
        var buckets = [[String]](repeating: [], count: 26)

        // Sort the strings into the buckets based on the current character
        let firstString = strings.first!
        var charIndex = firstString.endIndex

        while charIndex != firstString.startIndex {
            firstString.formIndex(before: &charIndex)
            for string in strings {
                let bucketIndex = string[charIndex].bucketIndex
                buckets[bucketIndex].append(string)
            }
            // Move the strings from the buckets to the array
            var index = 0
            for (bucketIndex, bucket) in buckets.enumerated() {
                for string in bucket {
                    strings[index] = string
                    index += 1
                }
                buckets[bucketIndex].removeAll()
            }
        }
        return strings
    }
    
    enum FindError: Error {
        case nonEulerianGraph
    }
    
    func find(_ legs: [[String]]) throws -> [String] {
        if legs.isEmpty {
            return []
        }
        
        var inDegree = [String: Int]()
        var outDegree = [String: Int]()
        var neighbors = [String: [String]]()

        // Setup num in/out for each leg.
        for leg in legs {
            let source = leg[0]
            let destination = leg[1]
            inDegree[destination, default: 0] += 1
            outDegree[source, default: 0] += 1
            neighbors[source, default: []].append(destination)
        }
        
        // Bucket sort each neighbor list.
        for (source, destinations) in neighbors {
            neighbors[source] = bucketSort(destinations)
        }

        // Verify that each vertex (airport) has a difference of in-degree & out-degree of <= 1.
        // Verify that there is one start vertex and one end vertex.
        // - The start vertex has 1 more outgoing edge compared to its incoming edges.
        // - The end vertex has 1 more incoming edge compared to its outgoing edges.
        var startVertex: String?
        var endVertex: String?
        for leg in legs {
            for airport in leg {
                let numIn = inDegree[airport] ?? 0
                let numOut = outDegree[airport] ?? 0
                if abs(numIn - numOut) > 1 {
                    throw FindError.nonEulerianGraph
                }
                // Does it have more outgoing edges than incoming?
                if numOut - numIn == 1 && startVertex != airport {
                    if startVertex != nil {
                        throw FindError.nonEulerianGraph
                    }
                    startVertex = airport
                }
                // Does it have more incoming edges than outgoing?
                else if numIn - numOut == 1 && endVertex != airport {
                    if endVertex != nil {
                        throw FindError.nonEulerianGraph
                    }
                    endVertex = airport
                }
            }
        }

        // If the previous conditions hold, except there is no start and end vertex, 
        // this graph contains a Eulerian path. We can start from any vertex.
        if startVertex == nil && endVertex == nil {
            // Pick "JFK" because the problem tells us to.
            startVertex = "JFK"
            endVertex = startVertex
        }

        guard let _startVertex = startVertex else {
            throw FindError.nonEulerianGraph
        }
        // We don't actually use the end vertex, but it does need to exist for a Eulerian path to exist.
        guard let _ = endVertex else {
            throw FindError.nonEulerianGraph
        }

        var output = [String]()
        func DFS(_ airport: String) {
            while let numOut = outDegree[airport], numOut != 0 {
                let airportNeighbors = neighbors[airport]!
                let index = airportNeighbors.count - numOut
                let neighbor = airportNeighbors[index]
                outDegree[airport]! -= 1
                DFS(neighbor)
            }
            output.append(airport)
        }
        DFS(_startVertex)

        output.reverse()
        return output
    }
    
    func findItinerary(_ tickets: [[String]]) -> [String] {
        return (try? find(tickets)) ?? []
    }
}
