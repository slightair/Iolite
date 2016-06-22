import GameplayKit

class FollowerDamagedState: GKState {
    unowned let entity: Follower

    required init(entity: Follower) {
        self.entity = entity
    }
}
