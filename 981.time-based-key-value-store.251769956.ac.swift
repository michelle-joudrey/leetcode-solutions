typealias TimeValue = (Int, String)
extension Array where Element == TimeValue {
    // Return the index of the element that comes before or is equal to value;
    // If none do, return nil.
    
    // Assume that the array is not empty.
    func lowerBound(for value: Int) -> Int? {
        var count = self.count
        var startIndex = 0
        
        if isEmpty {
            return nil
        }
        
        while count != 1 {
            // Get the middle element
            // odd case: (k/2 elements) (middle) (k/2 elements) 
            // even case: (k/2 elements) (middle) (k/2 - 1 elements) 
            
            let mid = startIndex + count / 2
            let numLeft = mid - startIndex
            // If middle > value, recurse the left half, not including the middle.
            // - because the right half including the middle can't be the lower bound.
            if self[mid].0 > value {
                // the middle element has `mid - start` values left of it.
                count = numLeft
            }
            // If middle <= value, recurse on the right half including the middle.
            // - because the lower bound could be the middle or an element right of it.
            else {
                startIndex = mid
                // The middle element has `count - left` values right of it (including it)
                count = count - numLeft
            }
        }
        
        let element = self[startIndex].0
        if element > value {
            return nil
        }
        return startIndex
    }
}


class TimeMap {    
    // Maps a key to an array of (timestamp, value)
    var dictionary = [String:[TimeValue]]()

    /** Initialize your data structure here. */
    init() {
        
    }
    
    func set(_ key: String, _ value: String, _ timestamp: Int) {
        let tuple = (timestamp, value)
        dictionary[key, default: [TimeValue]()].append(tuple)
    }
    
    func get(_ key: String, _ timestamp: Int) -> String {
        // return the value associated with this key s.t.
        // insertion_timestamp <= timestamp and insertion_timestamp is maximized.
        
        // Each set operation will have an increasing timestamp.
        // We want to minimize the time complexity of inserts and searches.
        
        // If we use an array, we can append (timestamp, value) tuples in O(1), and perform searches
        // using binary search O(logn).
        let tuples = dictionary[key]!
        let tupleIndex = tuples.lowerBound(for: timestamp)
        if let index = tupleIndex {
            return tuples[index].1
        }
        return ""   
    }
}

/**
 * Your TimeMap object will be instantiated and called as such:
 * let obj = TimeMap()
 * obj.set(key, value, timestamp)
 * let ret_2: String = obj.get(key, timestamp)
 */
