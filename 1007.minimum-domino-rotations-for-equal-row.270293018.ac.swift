class Solution {
    func numFlips(A: [Int], B: [Int], n: Int) -> Int? {
        // 1. How many dominoes do need to be flipped?
        // If a domino can't be flipped, then return nil.
        var numToFlip = 0
        for (i, a) in A.enumerated() {
            if a != n {
                if B[i] == n {
                    numToFlip += 1
                } else {
                    return nil
                }
            }
        }
        return numToFlip
    }
    
    func minDominoRotations(_ A: [Int], _ B: [Int]) -> Int {
        // Brute force: Try every possible solution.
        // - For each domino, we can either flip the domino, or not flip it.
        
        // Alternate approach:
        //  For each number n in 1...6, count how many flips we'd have to make (or nil if impossible)
        
        // A = [2,1,2,4,2,2], B = [5,2,6,2,3,2]
        // A: [n, n, 2, n, n, n, n]
        
        // If we have zero elements, we'll end up returning zero. Good.
        var minNumFlips: Int?
        for n in 1...6 {
            // We might get a better result by flipping dominoes in one array, or performing the inverse flips.
            if let flips = numFlips(A: A, B: B, n: n) {
                minNumFlips = minNumFlips.map {  min($0, flips) } ?? flips
            }
            if let flips = numFlips(A: B, B: A, n: n) {
                minNumFlips = minNumFlips.map {  min($0, flips) } ?? flips
            }
        }
        return minNumFlips ?? -1
    }
}
