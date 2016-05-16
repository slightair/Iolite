import GameplayKit
import SpriteKit

class MovementComponent: GKComponent {
    var renderComponent: RenderComponent {
        guard let component = entity?.componentForClass(RenderComponent.self) else {
            fatalError("MovementComponent's entity must have a RenderComponent")
        }
        return component
    }

    var onFieldComponent: OnFieldComponent {
        guard let component = entity?.componentForClass(OnFieldComponent.self) else {
            fatalError("MovementComponent's entity must have a OnFieldComponent")
        }
        return component
    }

    var agent: FollowerAgent {
        guard let component = entity?.componentForClass(FollowerAgent.self) else {
            fatalError("MovementComponent's entity must have a FollowerAgent")
        }
        return component
    }

    func moveTo(gridPosition: vector_int2) {
        let onFieldComponent = self.onFieldComponent

        let graph = onFieldComponent.field.graph
        guard let startNode = graph.nodeAtGridPosition(onFieldComponent.currentGridPosition),
            toNode = graph.nodeAtGridPosition(gridPosition) else {
                return
        }

        print("\(startNode.gridPosition) -> \(toNode.gridPosition)")

        let result = graph.findPathFromNode(startNode, toNode: toNode) as! [GKGridGraphNode]
        let graphNodes: [GKGraphNode2D] = result.map { gridGraphNode in
            let point = onFieldComponent.pointForGridPosition(gridGraphNode.gridPosition)
            return GKGraphNode2D(point: vector_float2(Float(point.x), Float(point.y)))
        }
        let path = GKPath(graphNodes: graphNodes, radius: 1.0)
        let behavior = GKBehavior(goals: [
            GKGoal(toFollowPath: path, maxPredictionTime: 1.0, forward: true),
            GKGoal(toStayOnPath: path, maxPredictionTime: 1.0)
        ])
        agent.behavior = behavior
    }
}
