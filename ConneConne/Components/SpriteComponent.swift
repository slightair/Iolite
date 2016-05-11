import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    let spriteNode: SKSpriteNode

    override init() {
        spriteNode = SKSpriteNode(imageNamed: "creature")
        spriteNode.size = CGSize(width: 32, height: 32)

        super.init()
    }
}
