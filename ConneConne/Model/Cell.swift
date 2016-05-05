import Foundation

final class Cell: PathNode {
    typealias Dirction = Direction

    enum Direction: Int {
        case Left, Top, Right, Bottom
        static let values: [Direction] = [.Left, .Top, .Right, .Bottom]
    }

    static func directions() -> [Direction] {
        return Direction.values
    }

    let index: Int

    var x: Int {
        return index % Field.width
    }

    var y: Int {
        return index / Field.width
    }

    private var leftCell: Cell?
    private var topCell: Cell?
    private var rightCell: Cell?
    private var bottomCell: Cell?

    init(index: Int) {
        self.index = index
    }

    func distance(another: Cell) -> Int {
        let dx = abs(another.x - x)
        let dy = abs(another.y - y)
        return max(dx, dy)
    }

    subscript(direction: Direction) -> Cell? {
        get {
            switch direction {
            case .Left:
                return leftCell
            case .Top:
                return topCell
            case .Right:
                return rightCell
            case .Bottom:
                return bottomCell
            }
        }
        set(cell) {
            switch direction {
            case .Left:
                leftCell = cell
            case .Top:
                topCell = cell
            case .Right:
                rightCell = cell
            case .Bottom:
                bottomCell = cell
            }
        }
    }
}
