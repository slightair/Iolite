import GameplayKit

class FollowerPreAttackState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .PreAttack
    }
}
