import GameplayKit

class FollowerExitState: FollowerBaseState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return false
    }
}
