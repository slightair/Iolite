import GameplayKit

class FollowerDamagedState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Damaged
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FollowerPreAttackState.Type, is FollowerWaitState.Type, is FollowerDeathState.Type:
            return true
        default:
            return false
        }
    }
}
