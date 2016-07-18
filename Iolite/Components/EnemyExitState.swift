import GameplayKit

class EnemyExitState: EnemyBaseState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return false
    }
}
