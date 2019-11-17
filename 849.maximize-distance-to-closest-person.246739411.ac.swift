class Solution {
    // 1 = sitting
    // 0 = empty
    // at least one empty seat
    // at least one person sitting
    // find seat (index) that maximizes distance from seat to closest occupied seat.
    
    // [1,0,0,0,1,0,1]
    
    // alg: two pointers
    // Move first pointer right until it finds an occupied seat.
    // Start second pointer at first pointer + 1, keep incrementing it while
    //   seat is empty.
    // The two pointers will now each point to an occupied seat, with no occupied seats
    //   between them.
    // Get the middle seat index m = i + (j - i) / 2
    // Take the minimum distance between m and j and m and i.
    // max = max(max, dist)
    
    // Set first pointer to second pointer
    // Set second poiner to first + 1
    // Resume
    
    // Edge case: [0, 0, 0, 0, 1] dist = l
    //            [1, 0, 0, 0, 0] dist = count - l - 1
    // Handle edge cases separately.
    
    
    func maxDistToClosest(_ seats: [Int], start: Int = 0) -> Int {
        var left = start
        let n = seats.count
        // There is at least one occupied seat.
        // Find the first occupied seat.
        while seats[left] == 0 {
            left += 1
        }
        // What is the distance to this seat?
        var maxDist = left - start
        
        // If there are no more seats, we're done.
        if left == n - 1 {
            return maxDist
        }
        
        // Find the second occupied seat, if possible.
        // There is at least one (either occupied or empty) seat remaining.
        var right = left + 1
        while right != n && seats[right] == 0 {
            right += 1
        }
        // Now, we either have a right occupied seat (right != n), or we don't (right == n).
        if right == n {
            return max(maxDist, n - left - 1)
        }
        // There is an occupied seat on the right and left, compute the number of seats between them.
        let numEmptySeats = right - left - 1
        // If we split this group of empty seats in half, what's the minimum num of seats on each side?
        let dist = (numEmptySeats + 1) / 2
        maxDist = max(maxDist, dist)
        // continue on the remainder of the seats, starting with the right occupied seat.
        return max(maxDist, maxDistToClosest(seats, start: right))
    }
}
