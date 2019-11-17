class Solution {
    func isIsomorphic(_ s: String, _ t: String) -> Bool {
        // Edge case
        if s.count != t.count {
            return false
        }
        // egg -> add
        // e -> a (e maps to a)
        // g -> d (g maps to d)
        // g -> d (same, second time)
        let charPairs = zip(s, t)
        var outputForInput = [Character: Character]()
        var inputForOutput = [Character: Character]()
        
        for (input, output) in charPairs {
            if let expectedOutput = outputForInput[input] {
                // If we have a mapping for the input char already, verify that 
                // the output is the char we expect.
                if output != expectedOutput {
                    return false
                }
            } else {
                // Otherwise create a mapping for input -> output.
                outputForInput[input] = output
                
                // Also create a mapping for output -> input,
                // after verifying that one doesn't exist.
                // (No two input characters may map to the same output)
                if let _ = inputForOutput[output] {
                    return false
                }
                inputForOutput[output] = input
            }
        }
        return true
    }
}
