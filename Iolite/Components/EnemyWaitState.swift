import GameplayKit

class EnemyWaitState: EnemyBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Wait
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is EnemyPreAttackState.Type, is EnemyDamagedState.Type:
            return true
        default:
            return false
        }
    }
}
