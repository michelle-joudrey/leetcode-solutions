class Solution {
    func isMatch(_ s: String, _ p: String) -> Bool {
        let nilChar = Character("`")
        // What character can we use to transition from si to si+1?
        var next = [Character?](repeating: nil, count: p.count + 1)
        // What character can we use to transition from si to si?
        var loop = [Character?](repeating: nil, count: p.count + 1)
        
        var state = 1
        var lastNonWildCard = 0
        var i = p.startIndex
        while i != p.endIndex {
            let char = p[i]
            if char == "*" {
                next[state - 1] = nilChar
                loop[state] = "."
            } else {
                next[state - 1] = char == "?" ? "." : char
                lastNonWildCard = state
            }
            i = p.index(after: i)
            state += 1
        }
         
        // The current states we are in.
        var inState = [Bool](repeating: false, count: state)
        var inStateNext = [Bool](repeating: false, count: state)
        inState[0] = true
        
        for char in s {
            var i = 0
            while i != inState.count {
                let s = inState[i]
                inState[i] = false
                if !s {
                    i += 1
                    continue
                }                
                // Is there a transition to the next state from this one?
                if let transChar = next[i] {
                    if char == transChar || transChar == "."  {
                        inStateNext[i + 1] = true
                    } else if transChar == nilChar {
                        // We can effectively match a nil character without consuming
                        // the input char via this trick.
                        inState[i + 1] = true
                    }
                }
                // Is there a transition from this state to itself?
                if let transChar = loop[i], transChar == char || transChar == "." {
                    inStateNext[i] = true
                }
                i += 1
            }
            (inState, inStateNext) = (inStateNext, inState)
        }
        // A state is an accepting state if there are no non-nil transitions after it.
        if let lastActiveState = inState.lastIndex(where: { $0 }) {
            return lastActiveState >= lastNonWildCard
        }
        return false
    }
}
