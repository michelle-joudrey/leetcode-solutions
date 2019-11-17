extension Array where Element == Int {
    // Note: The only difference between these two functions is that the indices
    // are visited in a different order.
    
    // Return a map of each index i to the index of the first element after A[i] less than A[i].
    func nextLessThan() -> [Int?] {
        var nextLT = [Int?](repeating: nil, count: count)
        var stack = [Int]()
        for i in indices {
            let x = self[i]
            while let topIndex = stack.last, x < self[topIndex] {
                stack.removeLast()
                nextLT[topIndex] = i
            }
            stack.append(i)
        }
        return nextLT
    }
    
    // Return a map of each index i to the index of the first element before A[i] less than A[i].
    func prevLessThan() -> [Int?] {
        var prevLT = [Int?](repeating: nil, count: count)
        var stack = [Int]()
        for i in indices.reversed() {
            let x = self[i]
            while let topIndex = stack.last, x < self[topIndex] {
                stack.removeLast()
                prevLT[topIndex] = i
            }
            stack.append(i)
        }
        return prevLT
    }
    
    // O(n)
    func maxArea() -> Int {        
        let nlt = nextLessThan()
        let plt = prevLessThan()
        var maxArea = 0
        for (i, height) in enumerated() {
            // If there's an element after this one that's less than `height`, use that index (j1). (the first one)
            // Otherwise, we want to include all the elements after this one in our area calculation.
            // Calculate the distance of i..<j. 
            let j1 = nlt[i] ?? count
            let numAfter = j1 - i - 1
            // If there's an element before this one that's less than `height`, use that index (j2). (the first one)
            // Otherwise, use i, since that is the number of elements before A[i].
            // Calculate the distance of j2..<i.
            let numBefore = plt[i].map { i - $0 - 1 } ?? i
            let area = height * (numAfter + numBefore + 1)
            maxArea = Swift.max(maxArea, area)
        }
        return maxArea
    }
}

class Solution {
    func largestRectangleArea(_ heights: [Int]) -> Int {
        return heights.maxArea()
    }
}
