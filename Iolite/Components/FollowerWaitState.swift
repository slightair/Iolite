import GameplayKit

class FollowerWaitState: FollowerBaseState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        animationComponent.requestedAnimationState = .Wait
    }
}
