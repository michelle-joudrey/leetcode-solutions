extension Array where Element == Int {
    var start: Int {
        return self[0]
    }
    var last: Int {
        return self[1]
    }
    func icontains(_ x: Int) -> Bool {
        return (start...last).contains(x)
    }
}

class Solution {    
    func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {        
        var output = [[Int]]()
        var foundStart = false
        var foundLast = false
        var start: Int?
        for (i, interval) in intervals.enumerated() {
            if !foundStart {
                if interval.icontains(newInterval.start) {
                    // We might need to modify this interval.
                    start = interval.start
                    output += Array(intervals.prefix(upTo: i))
                    foundStart = true
                } else if newInterval.start < interval.start {
                    // We don't need to modify any previous intervals.
                    start = newInterval.start
                    output += Array(intervals.prefix(upTo: i))
                    foundStart = true
                }
            } 
            if foundStart {
                if interval.icontains(newInterval.last) {
                    // Modify this interval
                    output += [[start!, interval.last]]
                    output += Array(intervals.suffix(from: i + 1))
                    foundLast = true
                    break
                } else if newInterval.last < interval.start {
                    // Create a new interval before this one
                    output += [[start!, newInterval.last]]
                    output += Array(intervals.suffix(from: i))
                    foundLast = true
                    break
                }
            }
        }
        if !foundStart {
            output = intervals + [newInterval]
        } else if !foundLast {
            output += [[start!, newInterval.last]]
        }
        return output
    }
}
