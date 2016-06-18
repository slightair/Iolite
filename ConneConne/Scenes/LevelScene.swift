import SpriteKit
import GameplayKit

class LevelScene: SKScene {
    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0

    let worldNode = SKNode()
    var worldLayerNodes = [WorldLayer: SKNode]()
    var field = Field()

    lazy var componentSystems: [GKComponentSystem] = {
        let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        let physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
        let renderComponentSystem = GKComponentSystem(componentClass: RenderComponent.self)
        let onFieldComponentSystem = GKComponentSystem(componentClass: OnFieldComponent.self)
        let lifeComponentSystem = GKComponentSystem(componentClass: LifeComponent.self)
        let intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)

        return [
            agentComponentSystem,
            physicsComponentSystem,
            renderComponentSystem,
            onFieldComponentSystem,
            lifeComponentSystem,
            intelligenceSystem,
        ]
    }()

    override func didMoveToView(view: SKView) {
        OnFieldComponent.scene = self

        worldNode.name = "world"
        addChild(worldNode)

        for layer in WorldLayer.allLayers {
            let layerNode = SKNode()
            layerNode.name = layer.nodeName
            worldLayerNodes[layer] = layerNode
            worldNode.addChild(layerNode)
        }

        setUpPhysics()

        let enemy = addEnemy(vector_int2(16, 45))

        let follower1 = addFollower(vector_int2(4, 5))
        follower1.mandate = .Target(enemy)

        let follower2 = addFollower(vector_int2(16, 4))
        follower2.mandate = .Target(enemy)

        let follower3 = addFollower(vector_int2(28, 6))
        follower3.mandate = .Target(enemy)
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

    func addChild(node: SKNode, toWorldLayer worldLayer: WorldLayer) {
        let worldLayerNode = worldLayerNodes[worldLayer]!
        worldLayerNode.addChild(node)
    }

    func setUpPhysics() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self

        ColliderType.definedCollisions[.Follower] = [
            .Obstacle,
            .Follower,
            .Enemy,
        ]

        ColliderType.requestedContactNotifications[.Follower] = [
            .Obstacle,
            .Follower,
            .Enemy,
        ]
    }

    func addFollower(position: vector_int2) -> Follower {
        let follower = Follower(field: field)

        let renderNode = follower.renderComponent.node
        addChild(renderNode, toWorldLayer: .Characters)

        let lifeGaugeNode = follower.lifeComponent.lifeGaugeNode
        addChild(lifeGaugeNode, toWorldLayer: .Info)

        let xRange = SKRange(constantValue: GameConfiguration.Creature.Follower.lifeGaugeOffset.x)
        let yRange = SKRange(constantValue: GameConfiguration.Creature.Follower.lifeGaugeOffset.y)

        let constraint = SKConstraint.positionX(xRange, y: yRange)
        constraint.referenceNode = renderNode

        lifeGaugeNode.constraints = [constraint]

        follower.onFieldComponent.warpTo(position)
        if let intelligenceComponent = follower.componentForClass(IntelligenceComponent.self) {
            intelligenceComponent.enterInitialState()
        }

        field.followers.append(follower)

        for componentsystem in componentSystems {
            componentsystem.addComponentWithEntity(follower)
        }

        return follower
    }

    func addEnemy(position: vector_int2) -> Enemy {
        let enemy = Enemy(field: field)

        let renderNode = enemy.renderComponent.node
        addChild(renderNode, toWorldLayer: .Characters)

        let lifeGaugeNode = enemy.lifeComponent.lifeGaugeNode
        addChild(lifeGaugeNode, toWorldLayer: .Info)

        let xRange = SKRange(constantValue: GameConfiguration.Creature.Enemy.lifeGaugeOffset.x)
        let yRange = SKRange(constantValue: GameConfiguration.Creature.Enemy.lifeGaugeOffset.y)

        let constraint = SKConstraint.positionX(xRange, y: yRange)
        constraint.referenceNode = renderNode

        lifeGaugeNode.constraints = [constraint]

        enemy.onFieldComponent.warpTo(position)

        field.enemies.append(enemy)

        for componentsystem in componentSystems {
            componentsystem.addComponentWithEntity(enemy)
        }

        return enemy
    }
}

extension LevelScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        handleContact(contact) { (notifiableType: ContactNotifiableType, otherEntity: GKEntity) in
            notifiableType.contactWithEntityDidBegin(otherEntity)
        }
    }

    func didEndContact(contact: SKPhysicsContact) {
        handleContact(contact) { (notifiableType: ContactNotifiableType, otherEntity: GKEntity) in
            notifiableType.contactWithEntityDidEnd(otherEntity)
        }
    }

    func handleContact(contact: SKPhysicsContact, contactCallback: (ContactNotifiableType, GKEntity) -> Void) {
        let colliderTypeA = ColliderType(rawValue: contact.bodyA.categoryBitMask)
        let colliderTypeB = ColliderType(rawValue: contact.bodyB.categoryBitMask)

        let aWantsCallback = colliderTypeA.notifyOnContactWithColliderType(colliderTypeB)
        let bWantsCallback = colliderTypeB.notifyOnContactWithColliderType(colliderTypeA)

        assert(aWantsCallback || bWantsCallback, "Unhandled physics contact - A = \(colliderTypeA), B = \(colliderTypeB)")

        let entityA = (contact.bodyA.node as? EntityNode)?.entity
        let entityB = (contact.bodyB.node as? EntityNode)?.entity

        if let notifiableEntity = entityA as? ContactNotifiableType, otherEntity = entityB where aWantsCallback {
            contactCallback(notifiableEntity, otherEntity)
        }

        if let notifiableEntity = entityB as? ContactNotifiableType, otherEntity = entityA where bWantsCallback {
            contactCallback(notifiableEntity, otherEntity)
        }
    }
}

extension LevelScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let follower = addFollower(vector_int2(
            Int32(arc4random_uniform(UInt32(Field.Width))),
            Int32(arc4random_uniform(UInt32(Field.Height)))))
        follower.mandate = .Target(field.enemies.first!)
    }
}
