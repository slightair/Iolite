import Foundation

enum PathFinderCheckPoint<T> {
    case CheckPoint(T)
    case End
}

class PathFinder<T: PathNode> {
    let source: T
    let destination: T
    var paths: [Int: Path<T>] = [:]
    var openedPathSet = Set<Path<T>>()
    var result: [T]? = nil
    var calculated = false
    var hasRoute: Bool {
        return calculated && result != nil
    }
    var currentPointIndex = 0
    var maxCost = 50

    init(source: T, destination: T) {
        self.source = source
        self.destination = destination
    }

    func calculate() -> [T]? {
        if calculated {
            return result
        }

        var criteria: Path<T>? = createPath(current: source, cost: 0)
        paths[criteria!.node.index] = criteria!

        while !isSolved(criteria) {
            openSurroundingPaths(criteria!)
            criteria = nextCriteria()
        }

        if criteria?.node.index == destination.index {
            result = criteria!.route()
        }

        calculated = true

        return result;
    }

    func createPath(current current: T, cost: Int, parent: Path<T>? = nil) -> Path<T> {
        return Path(
            node: current,
            cost: cost,
            heuristicCost: heuristicCost(source: current, destination: destination),
            parent: parent
        )
    }

    func isSolved(criteria: Path<T>?) -> Bool {
        if criteria == nil {
            return true
        }
        if criteria!.cost > maxCost {
            return true
        }
        if criteria!.node.index == destination.index {
            return true
        }
        return false
    }

    func openSurroundingPaths(path: Path<T>) {
        for direction in T.directions() {
            if let nextNode = path.node[direction] {
                if paths[nextNode.index] == nil {
                    let newPath = createPath(current: nextNode, cost: path.cost + 1, parent: path)
                    paths[nextNode.index] = newPath
                    openedPathSet.insert(newPath)
                }
            }
        }
        path.close()
        openedPathSet.remove(path)
    }

    func nextCriteria() -> Path<T>? {
        var criteria: Path<T>? = nil
        var score = Int(INT32_MAX)
        for path in openedPathSet {
            if path.score < score {
                score = path.score
                criteria = path
            }
        }
        return criteria
    }

    func heuristicCost(source source: T, destination: T) -> Int {
        return source.distance(destination)
    }

    func nextCheckPoint() -> PathFinderCheckPoint<T> {
        currentPointIndex += 1

        if !hasRoute || currentPointIndex >= result!.count {
            return .End
        }

        let point = result![currentPointIndex]
        return .CheckPoint(point)
    }
}

extension PathFinder: CustomStringConvertible {
    var description: String {
        if let result = result {
            let path = result.map { String($0.index) }
            return "Path: \(path.joinWithSeparator(" -> ")), Step: \(path.count)"
        } else {
            return "(not calculated)"
        }
    }
}