import SpriteKit
import GameplayKit

class GameScene: SKScene {
    static let BlockSize = 16

    let fieldNode = SKNode()
    let fieldDebugNode = SKNode()
    var field = Field()
    var blockNodes = [SKNode]()
    var creatures = [Creature]()

    let onFieldComponentSystem = GKComponentSystem(componentClass: OnFieldComponent.self)
    let spriteComponentSystem = GKComponentSystem(componentClass: SpriteComponent.self)

    var componentSystems: [GKComponentSystem] {
        return [
            spriteComponentSystem,
            onFieldComponentSystem,
        ]
    }

    override func didMoveToView(view: SKView) {
        fieldNode.position = CGPoint(x: 32, y: 460)
        fieldDebugNode.position = fieldNode.position

        for (index, cell) in field.cells {
            let (x, y) = (cell.x, cell.y)

            let blockNode = SKSpriteNode(imageNamed: "block")
            blockNode.anchorPoint = CGPoint(x: 0, y: 1)
            blockNode.position = CGPoint(x: x * GameScene.BlockSize, y: -y * GameScene.BlockSize)
            blockNode.color = UIColor.darkGrayColor()
            blockNode.colorBlendFactor = 1.0
            blockNode.name = "\(index)"

            blockNodes.append(blockNode)
            fieldNode.addChild(blockNode)

            let labelNode = SKLabelNode(text: "\(index)")
            labelNode.position = CGPoint(x: Int(blockNode.position.x) + GameScene.BlockSize / 2,
                                         y: Int(blockNode.position.y) - 12)
            labelNode.fontSize = 8
            fieldDebugNode.addChild(labelNode)
        }

        addChild(fieldDebugNode)
        addChild(fieldNode)

        let creature = makeCreature()
        for componentsystem in componentSystems {
            componentsystem.addComponentWithEntity(creature)
        }
        creatures.append(creature)
    }

    override func update(currentTime: CFTimeInterval) {
        for system in componentSystems {
            system.updateWithDeltaTime(currentTime)
        }
    }

    func makeCreature() -> Creature {
        let creature = Creature()

        let spriteComponent = SpriteComponent()
        creature.addComponent(spriteComponent)
        fieldNode.addChild(spriteComponent.spriteNode)

        let onFieldComponent = OnFieldComponent(field: field)
        creature.addComponent(onFieldComponent)
        onFieldComponent.moveTo(311)

        return creature
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.locationInNode(self)
        guard let selectedNode = (nodesAtPoint(location).filter { blockNodes.contains($0) }).first,
            indexString = selectedNode.name,
            selectedIndex = Int(indexString)
            else {
            return
        }

        for component in onFieldComponentSystem.components as! [OnFieldComponent] {
            component.targetTo(selectedIndex)
        }
    }
}
