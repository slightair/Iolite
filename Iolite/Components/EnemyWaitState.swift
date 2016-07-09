import GameplayKit

class EnemyWaitState: EnemyBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Wait
    }
}