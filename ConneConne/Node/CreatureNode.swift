import SpriteKit

class CreatureNode: SKSpriteNode {
    var cellIndex: Int = 0
    var pathFinder: PathFinder<Cell>? = nil

    convenience init() {
        self.init(imageNamed: "creature")

        size = CGSize(width: 32, height: 32)
    }

    func moveTo(cellIndex: Int, animated: Bool = true) {
        let prevIndex = self.cellIndex
        self.cellIndex = cellIndex

        if let gameScene = scene as? GameScene {
            pathFinder = gameScene.pathFinder(prevIndex, destination: cellIndex)
            pathFinder!.calculate()
            print(pathFinder)

            let newPosition = gameScene.positionOfIndex(cellIndex)

            if animated {
                runAction(SKAction.moveTo(newPosition, duration: 0.3))
            } else {
                position = newPosition
            }
        }
    }
}
