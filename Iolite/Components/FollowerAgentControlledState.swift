import GameplayKit

class FollowerAgentControlledState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Walk
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        switch entity.mandate {
        case .Standby:
            stateMachine?.enterState(FollowerWaitState.self)
        default:
            if entity.contactPoint != nil {
                stateMachine?.enterState(FollowerPreAttackState.self)
            }
            break
        }
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FollowerWaitState.Type, is FollowerPreAttackState.Type, is FollowerDamagedState.Type:
            return true
        default:
            return false
        }
    }
}
