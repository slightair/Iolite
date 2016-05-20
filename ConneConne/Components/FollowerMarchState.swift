import GameplayKit

class FollowerMarchState: GKState {
    unowned let entity: Follower

    required init(entity: Follower) {
        self.entity = entity
    }
}
