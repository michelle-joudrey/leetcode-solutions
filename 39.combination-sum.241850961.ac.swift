class Solution {
    // Problem:
    // Given a list x1, x2, ... xn
    // find the set S 
    // where each element is a list of 
    // k1, k2, ... kn
    // such that x1*k1 + x2*k2 + ... xn*kn = y
    
    // Solve via DFS of trying to add each possible value to the sum until the sum reaches the target.
    // Each edge along the path represents a value that was added.
    // To prevent duplicate results, we discard candidates less than the previous edge. 
    func search<T: Collection>(sum: Int, edges: [Int], candidates: T, target: Int, output: inout [[Int]]) 
      where T.Element == Int, T.Index == Int
    {
        for (index, candidate) in candidates.enumerated() {
            var newEdges = edges + [candidate]
            if sum + candidate < target {
                // keep looking along this path
                let sum = sum + candidate
                // enforce that edges must be >= the current edge
                let remainingCandidates = candidates.suffix(from: candidates.startIndex + index)
                search(sum: sum, edges: newEdges, candidates: remainingCandidates, target: target, output: &output)
            } else if sum + candidate == target {
                // we are done with this path
                output.append(newEdges)
            } else {
                // dead end: since the candidates are in sorted order,
                // no candidate can make sum + candidate <= target.
                break
            }
        }
    }
    
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let candidates = candidates.sorted()
        var output = [[Int]]()
        search(sum: 0, edges: [], candidates: candidates, target: target, output: &output)
        return output
    }
}
