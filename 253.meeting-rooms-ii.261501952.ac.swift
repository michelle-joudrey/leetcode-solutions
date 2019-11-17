class Solution {
    func isStart(_ j: Int) -> Bool {
        return j == 0
    }
    
    // The idea is to sort the interval start and end times, then enumerate through them,
    // keeping track of how many intervals we are "inside" of.
    func minMeetingRooms(_ intervals: [[Int]]) -> Int {
        var indices = [(i: Int, j: Int)]()
        
        // Create a list of index paths like [(0, 0), (0, 1), (1, 0), (1, 1)]
        for (i, interval) in intervals.enumerated() {
            for j in interval.indices {
                let pair = (i, j)
                indices.append(pair)
            }
        }
        
        indices.sort { (lhs, rhs) in
            let lhsValue = intervals[lhs.i][lhs.j]
            let rhsValue = intervals[rhs.i][rhs.j]
            if lhsValue == rhsValue {
                // In the case of a tie, place the meeting end time *before* meeting start time (if applicable).
                return !isStart(lhs.j)
            }
            // Order index paths by their associated value.
            return lhsValue < rhsValue
        }
        
        // Enumerate our list of meeting start and end times,
        // keeping track of the active number of meetings at each time.
        var count = 0
        var maxCount: Int?
        for (_, j) in indices {
            if isStart(j) {
                count += 1
            } else {
                count -= 1
            }
            maxCount = maxCount.map { max($0, count) } ?? count
        }
        return maxCount ?? 0
    }
}
