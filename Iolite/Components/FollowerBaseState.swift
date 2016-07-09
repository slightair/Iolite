import GameplayKit

class FollowerBaseState: GKState {
    unowned let entity: Follower

    var animationComponent: AnimationComponent {
        guard let component = entity.componentForClass(AnimationComponent.self) else {
            fatalError("entity must have a AnimationComponent")
        }
        return component
    }

    required init(entity: Follower) {
        self.entity = entity
    }
}
