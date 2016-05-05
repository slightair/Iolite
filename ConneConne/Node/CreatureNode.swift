import SpriteKit

class CreatureNode: SKSpriteNode {
    var cellIndex: Int = 0 {
        didSet {
            if let gameScene = scene as? GameScene {
                position = gameScene.positionOfIndex(cellIndex)
            }
        }
    }

    convenience init() {
        self.init(imageNamed: "creature")

        size = CGSize(width: 32, height: 32)
    }
}
