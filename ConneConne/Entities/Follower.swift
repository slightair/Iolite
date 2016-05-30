import SpriteKit
import GameplayKit

class Follower: Creature {
    override var textureSize: CGSize {
        return CGSize(width: 32, height: 32)
    }

    override var textureName: String {
        return "creature"
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

        super.init(field: field)

        let intelligenceComponent = IntelligenceComponent(states: [
            FollowerMarchState(entity: self)
        ])
        addComponent(intelligenceComponent)

        let physicsComponent = PhysicsComponent(physicsBody: SKPhysicsBody(circleOfRadius: 8, center: CGPoint(x: 0, y: -8)), colliderType: .Follower)
        addComponent(physicsComponent)

        let node = renderComponent.node
        node.physicsBody = physicsComponent.physicsBody

        agent.mass = 0.25
        agent.radius = 16.0
        agent.maxSpeed = 50.0
        agent.maxAcceleration = 300.0
    }
}
