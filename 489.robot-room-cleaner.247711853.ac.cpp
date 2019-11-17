/**
 * // This is the robot's control interface.
 * // You should not implement it, or speculate about its implementation
 * class Robot {
 *   public:
 *     // Returns true if the cell in front is open and robot moves into the cell.
 *     // Returns false if the cell in front is blocked and robot stays in the current cell.
 *     bool move();
 *
 *     // Robot will stay in the same cell after calling turnLeft/turnRight.
 *     // Each turn will be 90 degrees.
 *     void turnLeft();
 *     void turnRight();
 *
 *     // Clean the current cell.
 *     void clean();
 * };
 */

struct Node {
    uint32_t xOffset;
    uint32_t yOffset;
    int directionBack;
    
    uint64_t id() {
        return (((uint64_t)xOffset) << 32) | yOffset;
    }
    
    std::vector<Node> neighbors() {
        return { 
            Node { xOffset, yOffset - 1 }, // up
            Node { xOffset + 1, yOffset }, // right
            Node { xOffset, yOffset + 1 }, // down
            Node { xOffset - 1, yOffset }  // left
        };
    }
    
    bool operator==(Node other) {
        return id() == other.id();
    }
    
    bool operator!=(Node other) {
        return !(*this == other);
    }
};

class Solution {
public:
    void cleanRoom(Robot& robot) {
        // Iterative 
        // 0 = up, 1 = right, 2 = down, 3 = left
        auto direction = 0;
        
        auto visited = std::unordered_set<uint64_t>();
        auto path = std::vector<Node> { {0, 0} };
        while (path.size() != 0) {
            // Clean every room.
            robot.clean();
            
            auto node = path.back();
            visited.insert(node.id());
            // Try to visit a neighbor.
            auto neighbors = node.neighbors();
            auto targetDirection = 0;
            for (auto neighbor: neighbors) {
                // Did we already visit this neighbor?
                if (visited.find(neighbor.id()) != visited.end()) {
                    targetDirection += 1;
                    continue;
                }
                // Visit this neighbor.
                // 0. Mark it visited.
                visited.insert(neighbor.id());
                // 1. Turn clockwise until we are pointing at the neighbor.
                while (direction != targetDirection) {
                    robot.turnRight();
                    direction = (direction + 1) % 4;
                }
                // 2. Attempt to move to the neighbor.
                auto didMove = robot.move();
                // 3. If we did move to the neighbor, add the neighbor to the current path.
                if (didMove) {
                    neighbor.directionBack = (direction + 2) % 4;
                    path.push_back(neighbor);
                    break;
                }
                // Otherwise, try the next neighbor.
                targetDirection += 1;
            }
            // If we moved to the neighbor, then continue down that path.
            if (path.back() != node) {
                continue;
            }
            
            // If there were no unvisited neighbors, backtrack the robot to the previous position in the path.
            path.pop_back();
            // Is there a previous node in the path?
            if (path.size() == 0) {
                return; // Nope. We're done.
            }
            // Yes, so get the direction to where we came from.
            targetDirection = node.directionBack;
            // Turn until we're in that direction.
            while (direction != targetDirection) {
                robot.turnRight();
                direction = (direction + 1) % 4;
            }
            // We will always be able to backtrack without running into obstacles.
            robot.move();
        }
    }
};
