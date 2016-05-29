import SpriteKit
import GameplayKit

class Enemy: Creature {
    static let textureSize = CGSize(width: 96, height: 96)
    static let textureName = "enemy"

    required init(field: Field) {
        super.init(field: field)

        let spriteNode = SKSpriteNode(imageNamed: Enemy.textureName)
        spriteNode.size = Enemy.textureSize
        renderComponent.node.addChild(spriteNode)
    }
}
