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

    lazy var componentSystems: [GKComponentSystem] = {
        let physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
        let movementComponentSystem = GKComponentSystem(componentClass: MovementComponent.self)
        let renderComponentSystem = GKComponentSystem(componentClass: RenderComponent.self)
        let intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)

        return [
            physicsComponentSystem,
            movementComponentSystem,
            renderComponentSystem,
            intelligenceSystem,
        ]
    }()

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

        let enemy = makeEnemy(vector_int2(8, 3))
        field.enemies.append(enemy)

        let follower = makeFollower(vector_int2(8, 20))
        follower.mandate = .Target(enemy)

        enemy.movementComponent.moveToCreature(follower)

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
        let follower = Follower(field: field)
        fieldNode.addChild(follower.renderComponent.node)

        follower.onFieldComponent.warpTo(position)
        if let intelligenceComponent = follower.componentForClass(IntelligenceComponent.self) {
            intelligenceComponent.enterInitialState()
        }

        creatures.append(follower)

        return follower
    }

    func makeEnemy(position: vector_int2) -> Enemy {
        let enemy = Enemy(field: field)
        fieldNode.addChild(enemy.renderComponent.node)

        enemy.onFieldComponent.warpTo(position)

        creatures.append(enemy)

        return enemy
    }

    func didBeginContact(contact: SKPhysicsContact) {

    }
}
