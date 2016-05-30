import SpriteKit
import GameplayKit

class LevelScene: SKScene, SKPhysicsContactDelegate {
    static let BlockSize = 8

    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0

    let fieldNode = SKNode()
    var field = Field()
    var creatures = [Creature]()

    lazy var componentSystems: [GKComponentSystem] = {
        let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        let physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
        let renderComponentSystem = GKComponentSystem(componentClass: RenderComponent.self)
        let intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)

        return [
            agentComponentSystem,
            physicsComponentSystem,
            renderComponentSystem,
            intelligenceSystem,
        ]
    }()

    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self

        fieldNode.position = CGPoint(x: 32, y: 460)
        addChild(fieldNode)

        let enemy = makeEnemy(vector_int2(16, 3))
        field.enemies.append(enemy)

        let follower1 = makeFollower(vector_int2(4, 45))
        follower1.mandate = .Target(enemy)

        let follower2 = makeFollower(vector_int2(16, 46))
        follower2.mandate = .Target(enemy)

        let follower3 = makeFollower(vector_int2(28, 44))
        follower3.mandate = .Target(enemy)

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
