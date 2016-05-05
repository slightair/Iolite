import Foundation
import XCTest

class PathFinderTests: XCTestCase {
    let field = Field()

    func assertPathFinderRoute(source sourceIndex: Int, destination destinationIndex: Int, expectedRoute: [Int]) {
        let source = field.cells[sourceIndex]!
        let destination = field.cells[destinationIndex]!

        let pathFinder = PathFinder(source: source, destination: destination)
        let result = pathFinder.calculate()
        XCTAssertEqual(result!.map { $0.index }, expectedRoute)
    }

    func testPathFinder() {
        assertPathFinderRoute(source: 212, destination: 74,
                              expectedRoute: [212, 196, 180, 164, 165, 149, 150, 134, 135, 119, 103, 104, 105, 89, 90, 74])
        assertPathFinderRoute(source: 0, destination: 399,
                              expectedRoute: [0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 145, 161, 177, 178, 194, 195, 196, 212, 213, 229, 245, 246, 262, 263, 279, 280, 296, 297, 298, 314, 330, 331, 332, 348, 364, 365, 366, 382, 383, 399])
    }

    func testPerformancePathFinder() {
        let cellA = field.cells[212]!
        let cellB = field.cells[74]!

        self.measureBlock() {
            let pathFinder = PathFinder(source: cellA, destination: cellB)
            pathFinder.calculate()
        }
    }
}
