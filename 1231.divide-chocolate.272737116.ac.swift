class Solution {
    // Count how many chunks we can produce that are at least `minChunkSize` large.
    func numChunks(_ numbers: [Int], minChunkSize: Int) -> Int {
        var chunks = 0
        var chunkSize = 0
        for n in numbers {
            chunkSize += n
            if chunkSize >= minChunkSize {
                chunks += 1
                chunkSize = 0
            }
        }
        return chunks 
    }
    
    func maximizeSweetness(_ sweetness: [Int], _ K: Int) -> Int {
        var lo = 0
        // In an ideal world, everyone would get the same amount of chocolate,
        // which would maximize the minimum chocolate chunk size.
        var hi = sweetness.reduce(0, +) / (K == 0 ? 1 : K)
        while lo <= hi {
            let mid = lo + (hi - lo) / 2
            // Count how many chunks we can split the bar into while retaining the minimum chunk size.
            
            // We need at least K+1 pieces.
            if numChunks(sweetness, minChunkSize: mid) >= K + 1 {
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        return hi
    }
}
