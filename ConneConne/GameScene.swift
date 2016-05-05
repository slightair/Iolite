import SpriteKit

class GameScene: SKScene {
    static let BlockSize = 16
    let fieldNode = SKNode()
    let fieldDebugNode = SKNode()
    var field = Field()
    var creatureNode: CreatureNode!

    override func didMoveToView(view: SKView) {
        fieldNode.position = CGPoint(x: 32, y: 460)
        fieldDebugNode.position = CGPoint(x: 32, y: 460)

        for (index, cell) in field.cells {
            let (x, y) = (cell.x, cell.y)

            let blockNode = SKSpriteNode(imageNamed: "block")
            blockNode.anchorPoint = CGPoint(x: 0, y: 1)
            blockNode.position = CGPoint(x: x * GameScene.BlockSize, y: -y * GameScene.BlockSize)
            blockNode.color = UIColor.darkGrayColor()
            blockNode.colorBlendFactor = 1.0
            blockNode.name = "\(index)"
            fieldNode.addChild(blockNode)

            let labelNode = SKLabelNode(text: "\(index)")
            labelNode.position = CGPoint(x: Int(blockNode.position.x) + GameScene.BlockSize / 2,
                                         y: Int(blockNode.position.y) - 12)
            labelNode.fontSize = 8
            fieldDebugNode.addChild(labelNode)
        }

        creatureNode = CreatureNode()
        fieldNode.addChild(creatureNode)

        addChild(fieldDebugNode)
        addChild(fieldNode)

        creatureNode.cellIndex = 311
    }

    override func update(currentTime: CFTimeInterval) {
    }

    func positionOfIndex(index: Int) -> CGPoint {
        guard let cell = field.cells[index] else {
            fatalError("invalid index")
        }
        return CGPoint(x: cell.x * GameScene.BlockSize + GameScene.BlockSize / 2,
                       y: -cell.y * GameScene.BlockSize - GameScene.BlockSize / 2)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.locationInNode(self)
        guard let selectedNode = (nodesAtPoint(location).filter { $0.parent == fieldNode }).first,
            indexString = selectedNode.name,
            selectedIndex = Int(indexString)
            else {
            return
        }

        creatureNode.cellIndex = selectedIndex
    }
}
