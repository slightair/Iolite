import Foundation

func ==<T>(lhs: Path<T>, rhs: Path<T>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

enum PathStatus {
    case Open, Closed
}

class Path<T: PathNode>: Hashable {
    let node: T
    var status: PathStatus
    let cost: Int
    let heuristicCost: Int
    let parent: Path?
    var score: Int {
        return cost * 1000 + heuristicCost
    }

    var hashValue: Int {
        return node.index
    }

    init(node: T, cost: Int, heuristicCost: Int, parent: Path? = nil) {
        self.node = node
        self.status = .Open
        self.cost = cost
        self.heuristicCost = heuristicCost
        self.parent = parent
    }

    func close() {
        status = .Closed
    }

    func route() -> [T] {
        var nodes = [node]
        var nextParent = parent
        while nextParent != nil {
            nodes.append(nextParent!.node)
            nextParent = nextParent!.parent
        }
        return Array(nodes.reverse())
    }
}
