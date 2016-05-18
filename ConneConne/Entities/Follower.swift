import SpriteKit
import GameplayKit

class Follower: Creature {
    static let textureSize = CGSize(width: 32, height: 32)
    static let textureName = "creature"

    override init() {
        super.init()

        let node = renderComponent.node
        let spriteNode = SKSpriteNode(imageNamed: Follower.textureName)
        spriteNode.size = Follower.textureSize
        node.addChild(spriteNode)

        let physicsComponent = PhysicsComponent(physicsBody: SKPhysicsBody(circleOfRadius: 16, center: CGPoint(x: 16, y: 16)), colliderType: .Follower)
        addComponent(physicsComponent)

        node.physicsBody = physicsComponent.physicsBody
    }
}
