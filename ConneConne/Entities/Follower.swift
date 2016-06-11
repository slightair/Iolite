import SpriteKit
import GameplayKit

class Follower: GKEntity {
    let agent = GKAgent2D()

    var textureSize: CGSize {
        return CGSize(width: 32, height: 32)
    }

    var textureName: String {
        return "creature"
    }

    var renderComponent: RenderComponent {
        guard let component = componentForClass(RenderComponent.self) else {
            fatalError("Creature must have a RenderComponent")
        }
        return component
    }

    var onFieldComponent: OnFieldComponent {
        guard let component = componentForClass(OnFieldComponent.self) else {
            fatalError("Creature must have a OnFieldComponent")
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

        let physicsBody = SKPhysicsBody(circleOfRadius: 8, center: CGPoint(x: 0, y: -8))

        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Follower)
        addComponent(physicsComponent)

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        let intelligenceComponent = IntelligenceComponent(states: [
            FollowerMarchState(entity: self)
        ])
        addComponent(intelligenceComponent)

        agent.mass = 0.25
        agent.radius = 16.0
        agent.maxSpeed = 50.0
        agent.maxAcceleration = 300.0
        agent.delegate = self
        addComponent(agent)

        let node = renderComponent.node
        node.physicsBody = physicsComponent.physicsBody

        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.size = textureSize
        node.addChild(spriteNode)
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
