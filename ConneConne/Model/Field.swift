import GameplayKit

class Field {
    static let width = 16
    static let height = 25

    var enemies: [Enemy] = []
    var graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                            width: Int32(Field.width),
                            height: Int32(Field.height),
                            diagonalsAllowed: true)
}
