import SpriteKit
import GameplayKit

class LifeComponent: GKComponent {
    var life: Int
    var maximumLife: Int
    var percentageLife: Double {
        if maximumLife == 0 {
            return 0.0
        }
        return Double(life) / Double(maximumLife)
    }
    let lifeGaugeNode = GaugeNode()

    var isDead: Bool {
        return life <= 0
    }

    init(life: Int, maximumLife: Int) {
        self.maximumLife = maximumLife
        self.life = life

        super.init()

        lifeGaugeNode.level = percentageLife
    }
}
