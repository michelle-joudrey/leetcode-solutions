extension Array where Element == Int {
    var from: Int {
        return self[0]
    }
    var through: Int {
        return self[1]
    }
    func overlaps(with interval: [Int]) -> Bool {
        return (from...through).contains(interval.from) || 
               (interval.from...interval.through).contains(from)
    }
}

class Solution {
    // pseudocode:
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        var output = [[Int]]()
        if intervals.isEmpty {
            return output
        }
        let lastIndex = intervals.indices.last!
        var intervals = intervals.sorted { $0.from < $1.from }
        let first = intervals.first!
        var start = first.from
        var end = first.through
        for i in intervals.indices {
            let interval = intervals[i]            
            if i != intervals.startIndex {
                let prev = [start, end]
                // Does the previous interval not overlap with the current one?
                if !prev.overlaps(with: interval) {
                    // Emit start...prev.through, reset start.
                    let mergedInterval = [start, end]
                    output.append(mergedInterval)
                    start = interval.from
                    end = interval.through

                    // Are we at the end of the array? 
                    if i == lastIndex {
                        // Also emit this interval.
                        output.append(interval)
                    }
                    continue
                } else {
                    end = max(end, interval.through)
                }
            }
            if i == lastIndex {
                let mergedInterval = [start, end]            
                output.append(mergedInterval)
            }
        }
        return output
    }
}
