import GameplayKit

class FollowerBehavior: GKBehavior {
    static func behaviorForAgent(agent: GKAgent2D, targetAgent: GKAgent2D) -> FollowerBehavior {
        let behavior = FollowerBehavior()

        behavior.setWeight(1.0, forGoal: GKGoal(toSeekAgent: targetAgent))

        return behavior
    }
}
