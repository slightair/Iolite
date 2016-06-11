import GameplayKit

class LifeComponent: GKComponent {
    var hp: Int
    var maxHP: Int

    var isDead: Bool {
        return hp <= 0
    }

    init(maxHP: Int) {
        self.maxHP = maxHP
        self.hp = maxHP
    }
}
