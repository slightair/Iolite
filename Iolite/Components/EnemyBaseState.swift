import GameplayKit

class EnemyBaseState: GKState {
    unowned let entity: Enemy

    var animationComponent: AnimationComponent {
        guard let component = entity.componentForClass(AnimationComponent.self) else {
            fatalError("entity must have a AnimationComponent")
        }
        return component
    }

    required init(entity: Enemy) {
        self.entity = entity
    }
}
