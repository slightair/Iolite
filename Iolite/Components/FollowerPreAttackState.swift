import GameplayKit

class FollowerPreAttackState: GKState {
    unowned let entity: Follower

    required init(entity: Follower) {
        self.entity = entity
    }
}
