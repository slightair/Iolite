import Foundation

class Field {
    static let width = 16
    static let height = 25

    var cells: [Int: Cell] = [:]

    init() {
        setUpCells()
    }

    func setUpCells() {
        for index in 0..<(Field.width * Field.height) {
            let cell = Cell(index: index)
            cells[index] = cell
        }

        for index in 0..<(Field.width * Field.height) {
            let cell = cells[index]!

            if index >= Field.width {
                cell[.Top] = cells[index - Field.width]
            }
            if index <= Field.width * (Field.height - 1) {
                cell[.Bottom] = cells[index + Field.width]
            }
            if index % Field.width != 0 {
                cell[.Left] = cells[index - 1]
            }
            if index % Field.width != (Field.width - 1) {
                cell[.Right] = cells[index + 1]
            }
        }
    }
}
