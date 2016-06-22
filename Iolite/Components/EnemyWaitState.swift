import GameplayKit

class EnemyWaitState: GKState {
    unowned let entity: Enemy

    required init(entity: Enemy) {
        self.entity = entity
    }
}
