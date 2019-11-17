class Solution {
    func calcEquation(_ equations: [[String]], _ values: [Double], _ queries: [[String]]) -> [Double] {
        // brute force solution:
        // - make substitutions until we find solution.
        // e.g. 
        // a/b = 2
        // b/c = 3
        
        // a/c = a/b * b/c
        
        // Observation: All possible u/v = w triplets build off of combining known info.
        
        // 1. We can invert every equation whose quotient doesn't equal zero.
        // if a/b = j, then b/a = 1/j.
        
        // 2. We can combine equation pairs in the form of a/b = j, b/c = k.
        // (i.e. where equation 1's divisor equals equation 2's dividend)  (quotient = dividend / divisor)
        // a/b = j
        // b/c = k
        // a/c = j * k
        
        struct Division: Hashable {
            let dividend: String
            let divisor: String
            init(_ dividend: String, _ divisor: String) {
                self.dividend = dividend
                self.divisor = divisor
            }
            var inverse: Division {
                return Division(divisor, dividend)
            }
        }
        
        var solutions = [Division: Double]()
        var variables = Set<String>()
        for (i, equation) in equations.enumerated() {
            // insert the equation and its inverse into the equations set
            let dividend = equation[0]
            let divisor = equation[1]
            let quotient = values[i]
            
            let division = Division(dividend, divisor)
            solutions[division] = quotient
            
            if quotient != 0 {
                solutions[division.inverse] = 1.0 / quotient
            }
            
            // add the variable to the variables set
            variables.insert(dividend)
            variables.insert(divisor)            
        }
        
        // Try to find solutions for every pair of variables by combining previous results.
        // e.g. a/c = a/b * b/c
        var foundNewSolution = false 
        repeat {
            foundNewSolution = false
            for v1 in variables {
                for v2 in variables {
                    if v2 == v1 {
                        continue
                    }
                    for v3 in variables {
                        if v3 == v1 || v3 == v2 {
                            continue
                        }
                        // We now have 3 unique variables.
                        // Try to find a solution for
                        // v1/v3 = v1/v2 * v2/v3
                        let lhs = Division(v1, v2)
                        let rhs = Division(v2, v3)
                        if let lhsQuotient = solutions[lhs], let rhsQuotient = solutions[rhs] {
                            let division = Division(v1, v3)
                            if let _ = solutions[division] {
                                continue
                            }
                            let quotient = lhsQuotient * rhsQuotient
                            solutions[division] = quotient
                            if quotient != 0 {
                                solutions[division.inverse] = 1.0 / quotient
                            }
                        }
                    }
                }
            }            
        } while foundNewSolution
        
        var quotients = [Double]()
        for query in queries {
            let dividend = query[0]
            let divisor = query[1]
            
            if dividend == divisor && variables.contains(dividend) {
                quotients.append(1)
                continue
            } 
            
            let division = Division(dividend, divisor)
            let quotient = solutions[division, default: -1]
            quotients.append(quotient)
        }
        return quotients
    }
}
