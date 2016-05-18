import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    static let BlockSize = 16

    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0

    let fieldNode = SKNode()
    let fieldDebugNode = SKNode()
    var field = Field()
    var blockNodes = [SKNode]()
    var creatures = [Creature]()

    let followerAgentSystem = GKComponentSystem(componentClass: FollowerAgent.self)
    let physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
    let movementComponentSystem = GKComponentSystem(componentClass: MovementComponent.self)
    let renderComponentSystem = GKComponentSystem(componentClass: RenderComponent.self)

    var componentSystems: [GKComponentSystem] {
        return [
            followerAgentSystem,
            physicsComponentSystem,
            movementComponentSystem,
            renderComponentSystem,
        ]
    }

    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self

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
                    for component in self.movementComponentSystem.components as! [MovementComponent] {
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

        makeFollower(vector_int2(8, 20))
        makeEnemy(vector_int2(8, 3))

        for componentsystem in componentSystems {
            for creature in creatures {
                componentsystem.addComponentWithEntity(creature)
            }
        }
    }

    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)

        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime;
        }

        guard view != nil else {
            return
        }

        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ? maximumUpdateDeltaTime : deltaTime
        lastUpdateTimeInterval = currentTime

        for system in componentSystems {
            system.updateWithDeltaTime(deltaTime)
        }
    }

    func makeFollower(position: vector_int2) -> Follower {
        let follower = Follower()
        fieldNode.addChild(follower.renderComponent.node)

        let onFieldComponent = OnFieldComponent(field: field)
        follower.addComponent(onFieldComponent)

        let movementComponent = MovementComponent()
        follower.addComponent(movementComponent)

        onFieldComponent.warpTo(position)

        creatures.append(follower)

        return follower
    }

    func makeEnemy(position: vector_int2) -> Enemy {
        let enemy = Enemy()
        fieldNode.addChild(enemy.renderComponent.node)

        let onFieldComponent = OnFieldComponent(field: field)
        enemy.addComponent(onFieldComponent)
        onFieldComponent.warpTo(position)

        creatures.append(enemy)

        return enemy
    }

    func didBeginContact(contact: SKPhysicsContact) {

    }
}
