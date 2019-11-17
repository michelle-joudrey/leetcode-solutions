extension Array where Element == String {
    func product(with other: Array) -> Array {
        if other.isEmpty {
            return self
        }
        if isEmpty {
            return other
        }
        var output = Array()
        for element1 in self {
            for element2 in other {
                output.append(element1 + element2)
            }
        }
        return output
    }
}

class Expr {
    var decoded: [String] { return [] }
}

// For debugging
extension Expr {
    var kind: String {
        if let e = self as? ProductExpr {
            return "ProductExpr"
        } else if let e = self as? UnionExpr {
            return "UnionExpr"
        } else if let e = self as? StringExpr {
            return "StringExpr(\(e.value))"
        } else if let e = self as? GroupExpr {
            return "GroupExpr"
        }
        return "Expr"
    }
    
    var description: String {
        var output = ""
        func DFS(_ expr: Expr, indentation: String = "") {
            output += indentation + expr.kind + " = \(expr.decoded)" + "\n"
            if let groupExpr = expr as? GroupExpr {
                for child in groupExpr.children {
                    DFS(child, indentation: indentation + "--")
                }
            }
        }
        DFS(self)
        return output
    }
}

class GroupExpr: Expr {
    var children = [Expr]()
    override var decoded: [String] {
        var output = [String]()
        for child in children {
            output += child.decoded
        }
        return output
    }
}

class ProductExpr: GroupExpr {
    override var decoded: [String] {
        var output = [String]()
        // Fold the elements
        for child in children {
            let d = child.decoded
            output = output.product(with: d)
        }
        return output
    }
}

class UnionExpr: GroupExpr {
    override var decoded: [String] {
        var output = Set<String>()
        for child in children {
            let d = child.decoded
            for c in d {
                output.insert(c)
            }
        }
        return Array(output)
    }
}

class StringExpr: Expr {
    let value: String
    init(_ value: String) {
        self.value = value
    }
    override var decoded: [String] {
        return [value]   
    }
}

// Solution: Build a parse tree.
// Every expression, besides a group expression and a ProductExpr, will have a ProductExpr above it.
// 

/* Example parse tree for "{{a,z},a{b,c},{ab,z}}":

GroupExpr = ["z", "a", "ab", "ac"]
--ProductExpr = ["a", "ab", "z", "ac"]
----UnionExpr = ["a", "z", "ab", "ac"]
------ProductExpr = ["a", "z"]
--------UnionExpr = ["a", "z"]
----------ProductExpr = ["a"]
------------StringExpr(a) = ["a"]
----------ProductExpr = ["z"]
------------StringExpr(z) = ["z"]
------ProductExpr = ["ac", "ab"]
--------StringExpr(a) = ["a"]
--------UnionExpr = ["b", "c"]
----------ProductExpr = ["b"]
------------StringExpr(b) = ["b"]
----------ProductExpr = ["c"]
------------StringExpr(c) = ["c"]
------ProductExpr = ["z", "ab"]
--------UnionExpr = ["z", "ab"]
----------ProductExpr = ["ab"]
------------StringExpr(a) = ["a"]
------------StringExpr(b) = ["b"]
----------ProductExpr = ["z"]
------------StringExpr(z) = ["z"]
*/

class Solution {
    func braceExpansionII(_ expression: String) -> [String] {
        var rootExpr = GroupExpr()
        var stack = [rootExpr]
        
        for char in expression {
            if char == "{" {
                let unionExpr = UnionExpr()                
                let curExpr = stack.last!
                if let productExpr = curExpr as? ProductExpr {
                    curExpr.children.append(unionExpr)
                    stack.append(unionExpr)
                } else {
                    let productExpr = ProductExpr()
                    productExpr.children = [unionExpr]
                    curExpr.children.append(productExpr)
                    stack.append(productExpr)
                    stack.append(unionExpr)
                }
            } else if char == "}" {
                // Remove the ProductExpr
                stack.removeLast()
                // Remove the UnionExpr
                stack.removeLast()
            } else if char == "," {
                // Remove the ProductExpr.
                stack.removeLast()
            } else { // a-z
                let curExpr = stack.last!
                let stringExpr = StringExpr(String(char))
                if let productExpr = curExpr as? ProductExpr {
                    curExpr.children.append(stringExpr)
                } else {
                    let productExpr = ProductExpr()
                    productExpr.children = [stringExpr]
                    stack.append(productExpr)
                    curExpr.children.append(productExpr)
                }
            }
        }
        return rootExpr.decoded.sorted()
    }
}
