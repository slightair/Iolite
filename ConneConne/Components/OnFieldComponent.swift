import GameplayKit
import SpriteKit

class OnFieldComponent: GKComponent {
    var field: Field
    var currentCellIndex: Int = 0
    var pathFinder: PathFinder<Cell>? = nil
    var isMoving = false

    init(field: Field) {
        self.field = field
        super.init()
    }

    var movePathNode: SKShapeNode? {
        willSet {
            movePathNode?.removeFromParent()
        }

        didSet {
            if let node = movePathNode {
                spriteNode?.parent?.addChild(node)
            }
        }
    }

    var moveDuration: NSTimeInterval {
        return 0.3
    }

    var spriteNode: SKSpriteNode? {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else {
            return nil
        }
        return spriteComponent.spriteNode
    }

    func targetTo(cellIndex: Int) {
        if pathFinder != nil {
            pathFinder = nil
            spriteNode?.removeAllActions()
            isMoving = false
            moveTo(currentCellIndex)
        }

        pathFinder = makePathFinder(currentCellIndex, destination: cellIndex)
        let result = pathFinder!.calculate()!
        var points = result.map { positionOfIndex($0.index) }
        self.movePathNode = SKShapeNode(points: &points, count: points.count)
    }

    func moveTo(cellIndex: Int) {
        currentCellIndex = cellIndex
        pathFinder = nil

        spriteNode?.position = positionOfIndex(cellIndex)
    }

    func tick() {
        if isMoving {
            return
        }

        guard let pathFinder = pathFinder else {
            return
        }

        switch pathFinder.nextCheckPoint() {
        case .CheckPoint(let cell):
            isMoving = true
            spriteNode?.runAction(SKAction.moveTo(positionOfIndex(cell.index), duration: moveDuration)) {
                self.currentCellIndex = cell.index
                self.isMoving = false
            }
        case .End:
            self.pathFinder = nil
        }
    }

    func positionOfIndex(index: Int) -> CGPoint {
        guard let cell = field.cells[index] else {
            fatalError("invalid index")
        }
        return CGPoint(x: cell.x * GameScene.BlockSize + GameScene.BlockSize / 2,
                       y: -cell.y * GameScene.BlockSize - GameScene.BlockSize / 2)
    }

    func makePathFinder(source: Int, destination: Int) -> PathFinder<Cell> {
        let sourceCell = field.cells[source]!
        let destinationCell = field.cells[destination]!

        return PathFinder(source: sourceCell, destination: destinationCell)
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        tick()
    }
}
