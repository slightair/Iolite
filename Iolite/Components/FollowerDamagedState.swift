import GameplayKit

class FollowerDamagedState: FollowerBaseState {
    var elapsedTime: NSTimeInterval = 0.0

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Damaged
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        elapsedTime += seconds

        if elapsedTime >= GameConfiguration.Creature.Follower.damagedStateDuration {
            if entity.lifeComponent.isDead {
                stateMachine?.enterState(FollowerDeathState.self)
            } else {
                stateMachine?.enterState(FollowerWaitState.self)
            }
        }
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FollowerWaitState.Type, is FollowerDeathState.Type:
            return true
        default:
            return false
        }
    }
}
