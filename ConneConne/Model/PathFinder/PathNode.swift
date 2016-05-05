import Foundation

protocol PathNode {
    associatedtype Direction
    static func directions() -> [Direction]

    var index: Int { get }
    func distance(another: Self) -> Int
    subscript(direction: Direction) -> Self? { get set }
}
