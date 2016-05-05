import Foundation

class Cell {
    enum Direction: Int {
        case Left, Top, Right, Bottom
        static let values: [Direction] = [.Left, .Top, .Right, .Bottom]
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
