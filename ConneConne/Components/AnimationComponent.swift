import SpriteKit
import GameplayKit

enum AnimationState: String {
    case Walk
    case PreAttack
    case Attack
    case Damaged
}

struct Animation {
    let animationState: AnimationState
    let textureName: String
    let color: SKColor
}

class AnimationComponent: GKComponent {
    static let textureActionKey = "textureAction"

    let node: SKSpriteNode
    let animations: [AnimationState: Animation]

    var requestedAnimationState: AnimationState?

    private(set) var currentAnimation: Animation?
    private var elapsedAnimationDuration: NSTimeInterval = 0.0

    init(textureSize: CGSize, animations: [AnimationState: Animation]) {
        node = SKSpriteNode(texture: nil, size: textureSize)
        self.animations = animations

        super.init()
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        if let animationState = requestedAnimationState {
            runAnimation(forState: animationState, deltaTime: seconds)
            requestedAnimationState = nil
        }
    }

    private func runAnimation(forState animationState: AnimationState,  deltaTime: NSTimeInterval) {
        elapsedAnimationDuration += deltaTime

        if let animation = currentAnimation where animation.animationState == animationState {
            return
        }
        let nextAnimation = currentAnimation!

        let action = SKAction.setTexture(SKTexture(imageNamed: nextAnimation.textureName))
        node.runAction(action, withKey: AnimationComponent.textureActionKey)

        currentAnimation = nextAnimation
        elapsedAnimationDuration = 0.0
    }

    class func animation(fromTextureName textureName: String,
                                         color: SKColor,
                                         animationState: AnimationState) -> Animation {
        return Animation(animationState: animationState, textureName: textureName, color: color)
    }
}
