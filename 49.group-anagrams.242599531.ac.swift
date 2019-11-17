class Solution {
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        let a = Int(Character("a").asciiValue!)
        // maps letter frequency array to array of words
        var dictionary = [[Int] : [String]]()
        for str in strs {
            var frequencies = [Int](repeating: 0, count: 26)
            for char in str {
                frequencies[Int(char.asciiValue!) - a] += 1
            }
            let array = dictionary[frequencies] ?? []
            dictionary[frequencies] = array + [str]
        }
        return Array(dictionary.values)
    }
}
