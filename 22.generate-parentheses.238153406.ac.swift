class Solution {
    func generateParenthesis(_ n: Int) -> [String] {
        var finished = [String]()
        var solutions = [ (numLeft: 1, numRight: 0, "(") ]
        while !solutions.isEmpty {
            var newSolutions = [(Int, Int, String)]()
            for (numLeft, numRight, string) in solutions {
                if numLeft == n && numRight == n {
                    finished.append(string)
                }
                if numLeft != n {
                    let solution = (numLeft + 1, numRight, string + "(")
                    newSolutions.append(solution)
                }
                if numRight < numLeft {
                    let solution = (numLeft, numRight + 1, string + ")")
                    newSolutions.append(solution)
                }
                solutions = newSolutions
            }
        }
        return finished
    }
}
