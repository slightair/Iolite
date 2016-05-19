import SpriteKit
import GameplayKit

class IntelligenceComponent: GKComponent {
    let stateMachine: GKStateMachine
    let initialStateClass: AnyClass

    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        initialStateClass = states.first!.dynamicType
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        stateMachine.updateWithDeltaTime(seconds)
    }

    func enterInitialState() {
        stateMachine.enterState(initialStateClass)
    }
}
