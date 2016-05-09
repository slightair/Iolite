import SpriteKit

class CreatureNode: SKSpriteNode {
    var currentCellIndex: Int = 0
    var pathFinder: PathFinder<Cell>? = nil
    var isMoving = false

    var moveDuration: NSTimeInterval {
        return 0.3
    }

    convenience init() {
        self.init(imageNamed: "creature")

        size = CGSize(width: 32, height: 32)
    }

    func targetTo(cellIndex: Int) {
        guard let gameScene = scene as? GameScene else {
            return
        }

        if pathFinder != nil {
            pathFinder = nil
            removeAllActions()
            isMoving = false
        }

        pathFinder = gameScene.pathFinder(currentCellIndex, destination: cellIndex)
        pathFinder!.calculate()
    }

    func moveTo(cellIndex: Int) {
        guard let gameScene = scene as? GameScene else {
            return
        }

        currentCellIndex = cellIndex
        pathFinder = nil

        position = gameScene.positionOfIndex(cellIndex)
    }

    func tick() {
        if isMoving {
            return
        }

        guard let gameScene = scene as? GameScene, pathFinder = pathFinder else {
            return
        }

        switch pathFinder.nextCheckPoint() {
        case .CheckPoint(let cell):
            isMoving = true
            runAction(SKAction.moveTo(gameScene.positionOfIndex(cell.index), duration: moveDuration)) {
                self.currentCellIndex = cell.index
                self.isMoving = false
            }
        case .End:
            self.pathFinder = nil
        }
    }
}
