import SpriteKit
import GameplayKit

protocol CreatureConfiguration: class {
    var physicsBody: SKPhysicsBody { get }

    var textureSize: CGSize { get }
    var textureName: String { get }
    var animations: [AnimationState: Animation] { get }

    var initialLife: Int { get }
    var maximumLife: Int { get }

    func setUpAgent(agent: GKAgent2D)
}
