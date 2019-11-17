class Solution {
    func trap<T: Collection>(_ bars: T) -> (leftIndex: Int, sum: Int)
      where T.Element == Int, T.Index == Int
    {
        var leftIndex = 0
        var rightIndex = 0
        var waterSum = 0
        var runningSum = 0        
        while rightIndex != bars.count {
            let leftBarHeight = bars[leftIndex]
            let barHeight = bars[rightIndex]
            if barHeight >= leftBarHeight {
                waterSum += runningSum
                runningSum = 0
                leftIndex = rightIndex
            } else {
                runningSum += leftBarHeight - barHeight
            }
            rightIndex += 1
        }
        return (leftIndex, waterSum)
    }
    
    
    func trap(_ bars: [Int]) -> Int {
        // We will assume that for every left bar,
        // there is a right bar greater or equal in height.
        // The amount of water trapped for every bar between
        // the left and right bars is the difference of left bar height
        // and the bar height.
        
        // It could turn out that there is no right bar that is
        // greater or equal in height to the left bar. In that case
        // we will discard the running sum of water between the left and
        // right bars.
        
        // In the preceding case where the subsequent bars are all 
        // shorter than the left bar, we still need to count the water
        // trapped between those. 
        // To do this, we can use the original algorithm, except
        // on the reversed list of bars from the end to the last left bar
        // from the original run. 
        let (leftIndex, leftSum) = trap(bars)
        let rightBars = bars.suffix(from: leftIndex)
        let (_, rightSum) = trap(rightBars.reversed())
        return leftSum + rightSum
    }
}
