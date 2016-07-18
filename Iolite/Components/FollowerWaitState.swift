import GameplayKit

class FollowerWaitState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Wait
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        switch entity.mandate {
        case .Target:
            stateMachine?.enterState(FollowerAgentControlledState.self)
        default:
            break
        }
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FollowerAgentControlledState.Type, is FollowerDamagedState.Type:
            return true
        default:
            return false
        }
    }
}
