import GameplayKit

class EnemyDamagedState: EnemyBaseState {
    var elapsedTime: NSTimeInterval = 0.0

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        elapsedTime = 0.0
        animationComponent.requestedAnimationState = .Damaged
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        elapsedTime += seconds

        if elapsedTime >= GameConfiguration.Creature.Enemy.damagedStateDuration {
            stateMachine?.enterState(EnemyWaitState.self)
        }
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is EnemyPreAttackState.Type, is EnemyWaitState.Type, is EnemyDeathState.Type:
            return true
        default:
            return false
        }
    }
}
