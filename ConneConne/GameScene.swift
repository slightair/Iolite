import SpriteKit

class GameScene: SKScene {
    static let BlockSize = 16
    let fieldNode = SKNode()
    var field = Field()

    override func didMoveToView(view: SKView) {
        fieldNode.position = CGPoint(x: 32, y: 460)

        for (index, cell) in field.cells {
            let (x, y) = (cell.x, cell.y)

            let blockNode = SKSpriteNode(imageNamed: "block")
            blockNode.anchorPoint = CGPoint(x: 0, y: 1)
            blockNode.position = CGPoint(x: x * GameScene.BlockSize, y: -y * GameScene.BlockSize)
            blockNode.color = UIColor.darkGrayColor()
            blockNode.colorBlendFactor = 1.0
            fieldNode.addChild(blockNode)

            let labelNode = SKLabelNode(text: "\(index)")
            labelNode.position = CGPoint(x: Int(blockNode.position.x) + GameScene.BlockSize / 2,
                                         y: Int(blockNode.position.y) - 12)
            labelNode.fontSize = 8
            fieldNode.addChild(labelNode)
        }

        addChild(fieldNode)
    }

    override func update(currentTime: CFTimeInterval) {

    }
}
