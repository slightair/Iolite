import SpriteKit
import GameplayKit

class Follower: GKEntity {
    let agent = GKAgent2D()

    var renderComponent: RenderComponent {
        guard let component = componentForClass(RenderComponent.self) else {
            fatalError("Follower must have a RenderComponent")
        }
        return component
    }

    var onFieldComponent: OnFieldComponent {
        guard let component = componentForClass(OnFieldComponent.self) else {
            fatalError("Follower must have a OnFieldComponent")
        }
        return component
    }

    var lifeComponent: LifeComponent {
        guard let component = componentForClass(LifeComponent.self) else {
            fatalError("Follower must have a LifeComponent")
        }
        return component
    }

    enum FollowerMandate {
        case Standby
        case Target(Enemy)
    }

    var mandate: FollowerMandate {
        didSet {
            switch mandate {
            case .Target(let enemy):
                agent.behavior = FollowerBehavior.behaviorForAgent(agent, targetAgent: enemy.agent)
            default:
                break
            }
        }
    }

    required init(field: Field) {
        mandate = .Standby

        super.init()

        setUpComponents(field)
    }

    func setUpComponents(field: Field) {
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Follower)
        addComponent(physicsComponent)

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        let lifeComponent = LifeComponent(life: initialLife, maximumLife: maximumLife)
        addComponent(lifeComponent)

        let intelligenceComponent = IntelligenceComponent(states: [
            FollowerAgentControlledState(entity: self),
            FollowerPreAttackState(entity: self),
            FollowerAttackState(entity: self),
            FollowerDamagedState(entity: self),
        ])
        addComponent(intelligenceComponent)

        setUpAgent(agent)
        addComponent(agent)

        let node = renderComponent.node
        node.physicsBody = physicsComponent.physicsBody
    }
}

extension Follower: CreatureConfiguration {
    var physicsBody: SKPhysicsBody {
        return SKPhysicsBody(circleOfRadius: GameConfiguration.Creature.Follower.physicsBodyCircleOfRadius,
                             center: GameConfiguration.Creature.Follower.physicsBodyCenter)
    }

    var textureSize: CGSize {
        return GameConfiguration.Creature.Follower.textureSize
    }

    var textureName: String {
        return GameConfiguration.Creature.Follower.textureName
    }

    var initialLife: Int {
        return GameConfiguration.Creature.Follower.initialLife
    }

    var maximumLife: Int {
        return GameConfiguration.Creature.Follower.maximumLife
    }

    func setUpAgent(agent: GKAgent2D) {
        agent.mass = GameConfiguration.Creature.Follower.agentMass
        agent.radius = GameConfiguration.Creature.Follower.agentRadius
        agent.maxSpeed = GameConfiguration.Creature.Follower.agentMaxSpeed
        agent.maxAcceleration = GameConfiguration.Creature.Follower.agentMaxAcceleration

        agent.delegate = self
    }
}

extension Follower: GKAgentDelegate {
    func agentWillUpdate(agent: GKAgent) {
        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            agent2D.position = vector_float2(Float(node.position.x), Float(node.position.y))
        }
    }

    func agentDidUpdate(agent: GKAgent) {
        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
        }
    }
}

extension Follower: ContactNotifiableType {
    func contactWithEntityDidBegin(entity: GKEntity) {
        guard let enemy = entity as? Enemy else {
            return
        }
        print("contact \(enemy)")
    }

    func contactWithEntityDidEnd(entity: GKEntity) {
        guard let enemy = entity as? Enemy else {
            return
        }
        print("leave \(enemy)")
    }
}
