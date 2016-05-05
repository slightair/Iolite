import SpriteKit

class CreatureNode: SKSpriteNode {
    var cellIndex: Int = 0

    convenience init() {
        self.init(imageNamed: "creature")

        size = CGSize(width: 32, height: 32)
    }

    func moveTo(cellIndex: Int, animated: Bool = true) {
        self.cellIndex = cellIndex

        if let gameScene = scene as? GameScene {
            let newPosition = gameScene.positionOfIndex(cellIndex)

            if animated {
                runAction(SKAction.moveTo(newPosition, duration: 0.3))
            } else {
                position = newPosition
            }
        }
    }
}
