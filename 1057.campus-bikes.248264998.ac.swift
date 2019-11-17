class Solution {
    func assignBikes(_ workers: [[Int]], _ bikes: [[Int]]) -> [Int] {
        // Create pairs sorted by worker index and then bike index.
        var buckets = Array(repeating: [(Int, Int)](), count: 2000)
                
        // Optimizations: 
        // - The max distance from a bike to a worker is 2000.
        // Bucket-sort pairs by distance.
        // By simply controlling the order that we create pairs
        // (worker index followed by bike index), we get sorting for free.
        for workerIndex in workers.indices {
            let worker = workers[workerIndex]
            let (workerX, workerY) = (worker[0], worker[1])
            for bikeIndex in bikes.indices {
                let bike = bikes[bikeIndex]
                let (bikeX, bikeY) = (bike[0], bike[1])
                let distance = abs(bikeX - workerX) + abs(bikeY - workerY)
                buckets[distance].append((workerIndex, bikeIndex))
            }
        }
        
        let NM = workers.count * bikes.count
        var pairs = [(Int, Int, Int)]()
        // O(N * M)
        for (distance, bucketPairs) in buckets.enumerated() {
            for (workerIndex, bikeIndex) in bucketPairs {
                pairs.append((workerIndex, bikeIndex, distance))
            }
        }
        
        // Find the first bike for each worker. O(N * M)
        var workers = [Int](repeating: -1, count: workers.count)
        var bikeUsed = [Bool](repeating: false, count: bikes.count)
        for (workerIndex, bikeIndex, _) in pairs {
            if workers[workerIndex] == -1 && !bikeUsed[bikeIndex] {
                workers[workerIndex] = bikeIndex
                bikeUsed[bikeIndex] = true
            }
        }
        
        return workers
    }
}
