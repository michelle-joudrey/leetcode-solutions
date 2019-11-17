/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* left;
    Node* right;

    Node() {}

    Node(int _val, Node* _left, Node* _right) {
        val = _val;
        left = _left;
        right = _right;
    }
};
*/

struct ProcessState {
    Node *first;
    Node *last;
};

class Solution {
public:
    void process(Node *node, ProcessState &state) {
        // prev <-> node
        // Careful: Don't modify the right subtree since we are doing inorder.
        node->left = nullptr;        
        Node *prev = state.last;
        if (prev != nullptr) {
            prev->right = node;
            node->left = prev;
        } else {
            state.first = node;
        }
        state.last = node;
    }
    
    void inorder(Node *node, ProcessState &state) {
        if (node == nullptr) {
            return;
        }
        // L N R
        inorder(node->left, state);
        process(node, state);
        inorder(node->right, state);
    }
    
    Node* treeToDoublyList(Node* root) {
        ProcessState state;
        state.last = nullptr;
        state.first = nullptr;
        
        inorder(root, state);
        if (state.first != nullptr) {
            state.first->left = state.last;
            state.last->right = state.first;
        }
        return state.first;
    }
};
