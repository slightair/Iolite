import SpriteKit
import GameplayKit

class Follower: Creature {
    static let textureSize = CGSize(width: 32, height: 32)
    static let textureName = "creature"

    enum FollowerMandate {
        case Standby
        case Target(Enemy)
    }

    var mandate: FollowerMandate {
        didSet {
            switch mandate {
            case .Target(let enemy):
                movementComponent.moveToCreature(enemy)
            default:
                break
            }
        }
    }

    required init(field: Field) {
        mandate = .Standby

        super.init(field: field)

        let node = renderComponent.node
        let spriteNode = SKSpriteNode(imageNamed: Follower.textureName)
        spriteNode.size = Follower.textureSize
        node.addChild(spriteNode)

        let intelligenceComponent = IntelligenceComponent(states: [
            FollowerMarchState(entity: self)
        ])
        addComponent(intelligenceComponent)

        let physicsComponent = PhysicsComponent(physicsBody: SKPhysicsBody(circleOfRadius: 16, center: CGPoint(x: 16, y: 16)), colliderType: .Follower)
        addComponent(physicsComponent)

        node.physicsBody = physicsComponent.physicsBody
    }
}
