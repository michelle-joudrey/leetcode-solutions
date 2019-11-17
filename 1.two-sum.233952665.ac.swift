class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var indexForNum = [Int:Int]()
        for (i, num) in nums.enumerated() {
            // overwrites in the case of [a, a]
            indexForNum[num] = i 
        }
        
        for (i, num) in nums.enumerated() {
            // array gives us f(index) = element,
            // but to do this in O(n) we want f(element) = index
            // target = lhs + rhs
            // target - rhs = lhs
            // f(lhs) = index
            let lhs = target - num
            // you many not use the same element twice
            if let lhsIndex = indexForNum[lhs], lhsIndex != i {
                return [lhsIndex, i]
            }
        }
        fatalError() // one solution is guaranteed, so this won't be called
    }
}
