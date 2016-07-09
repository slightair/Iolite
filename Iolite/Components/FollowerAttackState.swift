import GameplayKit

class FollowerAttackState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Attack
    }
}
