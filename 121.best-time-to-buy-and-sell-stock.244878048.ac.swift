class Solution {    
    func maxProfit(_ prices: [Int]) -> Int {
        var maxProfit = 0
        guard var maxAfterI = prices.last else {
            return 0
        }
        for i in prices.indices.dropLast().reversed() {
            let profit = -prices[i] + maxAfterI
            maxAfterI = max(prices[i], maxAfterI)
            maxProfit = max(maxProfit, profit)
        }
        return maxProfit
    }
}
