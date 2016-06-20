import GameplayKit

class FollowerAgentControlledState: GKState {
    unowned let entity: Follower

    required init(entity: Follower) {
        self.entity = entity
    }
}
