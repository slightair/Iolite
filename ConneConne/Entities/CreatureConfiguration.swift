import SpriteKit
import GameplayKit

protocol CreatureConfiguration: class {
    var textureSize: CGSize { get }
    var textureName: String { get }

    var initialLife: Int { get }
    var maximumLife: Int { get }

    func setUpAgent(agent: GKAgent2D)
}
