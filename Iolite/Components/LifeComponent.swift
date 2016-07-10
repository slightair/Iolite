import SpriteKit
import GameplayKit

protocol LifeComponentDelegate: class {
    func lifeComponentDidDamage(lifeComponent: LifeComponent)
}

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

    weak var delegate: LifeComponentDelegate?

    init(life: Int, maximumLife: Int) {
        self.maximumLife = maximumLife
        self.life = life

        super.init()

        lifeGaugeNode.level = percentageLife
    }

    func damaged(damage: Int) {
        var newLife = life - damage
        newLife = min(max(newLife, 0), maximumLife)

        if newLife < life {
            life = newLife
            lifeGaugeNode.level = percentageLife
            delegate?.lifeComponentDidDamage(self)
        }
    }
}
