class Solution {
    func jump(_ nums: [Int]) -> Int {
        var first = 0
        var end = 1
        var numIterations = 0
        // Use a storageless version of BFS
        // where we have a range of elements that we'll visit.
        
        while end < nums.count {
            // what's the furthest element we can reach?
            var temp = end
            end = (first..<end).lazy.map { $0 + nums[$0] }.max()! + 1
            first = temp
            numIterations += 1
        }
        return numIterations
    }
}
