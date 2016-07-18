import GameplayKit

class FollowerPreAttackState: FollowerBaseState {
    var elapsedTime: NSTimeInterval = 0.0

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        elapsedTime = 0.0
        animationComponent.requestedAnimationState = .PreAttack
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        elapsedTime += seconds

        if elapsedTime >= GameConfiguration.Creature.Follower.preAttackStateDuration {
            stateMachine?.enterState(FollowerAttackState.self)
        }
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FollowerAttackState.Type, is FollowerDamagedState.Type:
            return true
        default:
            return false
        }
    }
}
