import SpriteKit
import GameplayKit

class Enemy: Creature {
    override var textureSize: CGSize {
        return CGSize(width: 96, height: 96)
    }

    override var textureName: String {
        return "enemy"
    }

    required init(field: Field) {
        super.init(field: field)

        let physicsComponent = PhysicsComponent(physicsBody: SKPhysicsBody(circleOfRadius: 24, center: CGPoint(x: 0, y: -24)), colliderType: .Enemy)
        addComponent(physicsComponent)

        let node = renderComponent.node
        node.physicsBody = physicsComponent.physicsBody
    }
}
