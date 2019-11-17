class Solution {
    func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
        // Detect a cycle using DFS.
        // If we visit a vertex currently being processed, we have detected a cycle.
        // Question 1: How to create a graph from this data?
        // prereq = edge
        // [1,0] means that 1 depends on 0... or we can get to node 1 from node 0.
        // class = vertex
        
        // for each vertex, keep track of which other vertices we can get to (an adjacency list).
        var adjacencyList = [[Int]](repeating: .init(), count: numCourses)
        for prereq in prerequisites {
            let to = prereq[0]
            let from = prereq[1]
            adjacencyList[from].append(to) 
        }
        
        // keep track of each vertex's state.
        enum State {
            case unvisited
            case processing
            case processed
        }
        var stateForVertex = [State](repeating: .unvisited, count: numCourses)
        
        enum MyError: Error {
            case cycleDetected
        }
        
        // A class may not have any prereqs, so we should start a DFS from every vertex.
        func DFS(vertex: Int) throws {
            switch stateForVertex[vertex] {
                case .processed:
                    return
                case .processing:
                    throw MyError.cycleDetected
                case .unvisited:
                    stateForVertex[vertex] = .processing
                    let neighbors = adjacencyList[vertex]
                    for neighbor in neighbors {
                        try DFS(vertex: neighbor)
                    }
                    stateForVertex[vertex] = .processed
            }
        }
        
        for vertex in 0..<numCourses {
            do {
                try DFS(vertex: vertex)
            } catch {
                return false
            }
        }
        return true
    }
}
