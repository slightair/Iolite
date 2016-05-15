import SpriteKit
import GameplayKit

class Follower: Creature {
    static let textureSize = CGSize(width: 32, height: 32)
    static let textureName = "creature"

    override init() {
        super.init()

        let spriteNode = SKSpriteNode(imageNamed: Follower.textureName)
        spriteNode.size = Follower.textureSize
        renderComponent.node.addChild(spriteNode)
    }
}
