import XCTest

class FieldTest: XCTestCase {
    var field: Field! = nil

    override func setUp() {
        super.setUp()
        field = Field()
    }

    func assertNeighbors(index: Int, neighbors: [Int?]) {
        let cell0 = field.cells[index]!

        XCTAssertEqual(cell0[.Left]?.index, neighbors[0])
        XCTAssertEqual(cell0[.Top]?.index, neighbors[1])
        XCTAssertEqual(cell0[.Right]?.index, neighbors[2])
        XCTAssertEqual(cell0[.Bottom]?.index, neighbors[3])
    }

    func testNeighborCells() {
        assertNeighbors(0, neighbors: [nil, nil, 1, 16])
        assertNeighbors(15, neighbors: [14, nil, nil, 31])
        assertNeighbors(16, neighbors: [nil, 0, 17, 32])
        assertNeighbors(17, neighbors: [16, 1, 18, 33])
        assertNeighbors(31, neighbors: [30, 15, nil, 47])
        assertNeighbors(368, neighbors: [nil, 352, 369, 384])
        assertNeighbors(383, neighbors: [382, 367, nil, 399])
        assertNeighbors(384, neighbors: [nil, 368, 385, nil])
        assertNeighbors(399, neighbors: [398, 383, nil, nil])
    }
}
