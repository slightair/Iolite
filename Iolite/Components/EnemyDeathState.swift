import GameplayKit

class EnemyDeathState: EnemyBaseState {
    var elapsedTime: NSTimeInterval = 0.0

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        elapsedTime = 0.0
        animationComponent.requestedAnimationState = .Death
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        elapsedTime += seconds

        if elapsedTime >= GameConfiguration.Creature.Enemy.preAttackStateDuration {
            stateMachine?.enterState(EnemyExitState.self)
        }
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is EnemyExitState.Type:
            return true
        default:
            return false
        }
    }
}
