// grammar
// string = [word | num string]
// word = [a-Z]
// num = [0-9]+

///  example: "a2[ab3[c]]"
///  []
///  [word(a), num(2) string]
///                      |--> [word(ab), num(3) string]
///                                                |--> [word(c)]

/// Parse tree
class EncodedString {
    private var children = [Child]()
    var parent: EncodedString?

    enum Child {
        case word(String)
        case rep(Int, EncodedString)

        var decoded: String {
            switch self {
            case .word(let str):
                return str
            case .rep(let num, let encodedStr):
                return String(repeating: encodedStr.decoded, count: num)
            }
        }
    }

    func addChild(_ child: Child) {
        if case let .rep(_, node) = child {
            node.parent = self
        }
        children.append(child)
    }

    var decoded: String {
        return children.map { $0.decoded }.joined(separator: "")
    }
}

class Solution {    
    func decodeString(_ s: String) -> String {
        let root = EncodedString()
        var node = root
        var i = s.startIndex
        var n = 0
        for char in s {
            if let num = Int(String(char)) {
                n = n * 10 + num
            } else if char == "[" {
                let newNode = EncodedString()
                node.addChild(.rep(n, newNode))
                node = newNode
                n = 0
            } else if char == "]" {
                node = node.parent!
            } else {
                node.addChild(.word(String(char)))
            }
        }
        return root.decoded
    }
}
