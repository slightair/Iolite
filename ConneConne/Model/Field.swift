import Foundation

class Field {
    static let width = 16
    static let height = 25

    var cells: [Int: Cell] = [:]

    init() {
        for index in 0..<(Field.width * Field.height) {
            let cell = Cell(index: index)
            cells[index] = cell
        }
    }
}
