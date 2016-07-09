import GameplayKit

class FollowerDamagedState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Damaged
    }
}
