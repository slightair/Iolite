import SpriteKit
import GameplayKit

class GameScene: SKScene {
    static let BlockSize = 16

    let fieldNode = SKNode()
    let fieldDebugNode = SKNode()
    var field = Field()
    var blockNodes = [SKNode]()
    var creatures = [Creature]()

    let moveComponentSystem = GKComponentSystem(componentClass: MoveComponent.self)
    let spriteComponentSystem = GKComponentSystem(componentClass: SpriteComponent.self)

    var componentSystems: [GKComponentSystem] {
        return [
            spriteComponentSystem,
            moveComponentSystem,
        ]
    }

    override func didMoveToView(view: SKView) {
        fieldNode.position = CGPoint(x: 32, y: 460)
        fieldDebugNode.position = fieldNode.position

        for y in 0..<Field.height {
            for x in 0..<Field.width {
                guard let node = field.graph.nodeAtGridPosition(vector_int2(Int32(x), Int32(y))) else {
                    continue
                }

                let posString = "\(node.gridPosition.x)-\(node.gridPosition.y)"

                let blockNode = ActionNode(imageNamed: "block")
                blockNode.anchorPoint = CGPoint(x: 0, y: 1)
                blockNode.position = CGPoint(x: x * GameScene.BlockSize, y: -y * GameScene.BlockSize)
                blockNode.color = UIColor.darkGrayColor()
                blockNode.colorBlendFactor = 1.0
                blockNode.tapAction = {
                    print(posString)
                    for component in self.moveComponentSystem.components as! [MoveComponent] {
                        component.moveTo(node.gridPosition)
                    }
                }

                blockNodes.append(blockNode)
                fieldNode.addChild(blockNode)

                let labelNode = SKLabelNode(text: "\(posString)")
                labelNode.position = CGPoint(x: Int(blockNode.position.x) + GameScene.BlockSize / 2,
                                             y: Int(blockNode.position.y) - 12)
                labelNode.fontSize = 5
                fieldDebugNode.addChild(labelNode)
            }
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

        let moveComponent = MoveComponent(field: field)
        creature.addComponent(moveComponent)
        moveComponent.warpTo(vector_int2(8, 20))

        return creature
    }
}
