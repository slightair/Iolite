import SpriteKit
import GameplayKit

struct GameConfiguration {
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
        }

        struct Enemy {
            static let initialLife = 100
            static let maximumLife = 100

            static let textureName = "enemy"
            static let textureSize = CGSize(width: 96, height: 96)

            static let physicsBodyCircleOfRadius: CGFloat = 24
            static let physicsBodyCenter = CGPoint(x: 0, y: -24)

            static let agentMass: Float = 0.25
            static let agentRadius: Float = 48.0
            static let agentMaxSpeed: Float = 50.0
            static let agentMaxAcceleration: Float = 300.0

            static let lifeGaugeOffset = CGPoint(x: 0.0, y: -60.0)
        }
    }
}
