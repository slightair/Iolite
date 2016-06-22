import GameplayKit

class FollowerAttackState: GKState {
    unowned let entity: Follower

    required init(entity: Follower) {
        self.entity = entity
    }
}
