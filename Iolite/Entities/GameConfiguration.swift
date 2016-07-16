import SpriteKit
import GameplayKit

struct GameConfiguration {
    struct UI {
        static let defaultFont = "ArialRoundedMTBold"
        static let damageFontSize: CGFloat = 9
        static let damageAnimationDelta = CGVector(dx: 0, dy: 20)
        static let damageAnimationDuration: NSTimeInterval = 1.0
    }

    struct Field {
        static let offset = CGPoint(x: 0, y: 28)
        static let size = CGSize(width: 256, height: 400)

        static let blockSize: CGFloat = 8
    }

    struct Creature {
        struct Follower {
            static let initialLife = 8
            static let maximumLife = 10

            static let textureName = "creature"
            static let textureSize = CGSize(width: 32, height: 32)

            static let physicsBodyCircleOfRadius: CGFloat = 8
            static let physicsBodyCenter = CGPoint(x: 0, y: -8)

            static let agentMass: Float = 0.25
            static let agentRadius: Float = 16.0
            static let agentMaxSpeed: Float = 50.0
            static let agentMaxAcceleration: Float = 300.0

            static let lifeGaugeOffset = CGPoint(x: 0.0, y: -24.0)

            static let preAttackStateDuration: NSTimeInterval = 0.8
            static let attackStateDuration: NSTimeInterval = 1.0
            static let damagedStateDuration: NSTimeInterval = 0.1
        }

        struct Enemy {
            static let initialLife = 1000
            static let maximumLife = 1000

            static let textureName = "enemy"
            static let textureSize = CGSize(width: 96, height: 96)

            static let physicsBodyCircleOfRadius: CGFloat = 24
            static let physicsBodyCenter = CGPoint(x: 0, y: -24)

            static let agentMass: Float = 0.25
            static let agentRadius: Float = 48.0
            static let agentMaxSpeed: Float = 50.0
            static let agentMaxAcceleration: Float = 300.0

            static let lifeGaugeOffset = CGPoint(x: 0.0, y: -60.0)

            static let preAttackStateDuration: NSTimeInterval = 0.8
            static let attackStateDuration: NSTimeInterval = 1.0
            static let damagedStateDuration: NSTimeInterval = 0.1
        }
    }
}
