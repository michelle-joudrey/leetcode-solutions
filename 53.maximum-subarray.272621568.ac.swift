/*
	Assume we have an array 'A' of length 4.

	If Mi is the sum of the max subarray that starts at index i, then the solution is:
    maxSubarraySum(A) = max(M0, M1, M2, M3)

    If Sij is the sum from Ai through Aj...
    M0 = max(S00, S01, S02, S03)
    M1 = max(S11, S12, S13)
    M2 = max(S22, S23)
    M3 = max(S33)

    Applying the rule:
    max(x, x + y) = x + max(0, y)

    M0 = A0 + max(0, S11, S12, S13)
    M1 = A1 + max(0, S22, S23)
    M2 = A2 + max(0, S33)
    M3 = A3

    Applying the rule:
    max(x, y, z) = max(x, max(y, z))

    M0 = A0 + max(0, max(S11, S12, S13))
    M1 = A1 + max(0, max(S22, S23))
    M2 = A2 + max(0, max(S33))
    M3 = A3

    Recall that:
    M0 = max(S00, S01, S02, S03)
    M1 = max(S11, S12, S13)
    M2 = max(S22, S23)
    M3 = max(S33)

    Use this to perform substitution:
    M0 = A0 + max(0, M1)
    M1 = A1 + max(0, M2)
    M2 = A2 + max(0, M3)
    M3 = A3

    From this we can deduce the relationship of:
    Mi = Ai + max(0, M(i+1))
    and M_lastIndex = A_lastIndex.
    This relationship looks pretty magical, but since we did the proof above, there's really nothing magical about it.

    Note that no DP table is needed, since we only need M(i+1) around when solving Mi, therefore a previousM variable works fine.

*/

class Solution {    
    func maxSubArray(_ nums: [Int]) -> Int {
        // Return 0 if the array is empty, otherwise set Mprev to the last element.
        guard var Mprev = nums.last else {
            return 0
        }
        var maxSum = Mprev
        // Visit the elements (minus the last one) in reverse order.
        for n in nums.dropLast().reversed() {
            let Mi = n + max(0, Mprev)
            maxSum = max(maxSum, Mi)
            Mprev = Mi
        }
        return maxSum
    }
}
