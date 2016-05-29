import GameplayKit
import SpriteKit

class MovementComponent: GKComponent {
    var route: [GKGridGraphNode]? = nil {
        didSet {
            if let route = route {
                let onFieldComponent = self.onFieldComponent
                var points = route.map { onFieldComponent.pointForGridPosition($0.gridPosition) }
                routeNode = SKShapeNode(points: &points, count: points.count)
            } else {
                routeNode = nil
            }
        }
    }

    var routeNode: SKShapeNode? {
        willSet {
            routeNode?.removeFromParent()
        }

        didSet {
            if let node = routeNode {
                renderComponent.node.parent?.addChild(node)
            }
        }
    }

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

    func moveTo(gridPosition: vector_int2) {
        let node = renderComponent.node
        let onFieldComponent = self.onFieldComponent

        node.removeAllActions()

        let graph = onFieldComponent.field.graph
        guard let startNode = graph.nodeAtGridPosition(onFieldComponent.currentGridPosition),
            toNode = graph.nodeAtGridPosition(gridPosition) else {
                return
        }

        let result = graph.findPathFromNode(startNode, toNode: toNode) as! [GKGridGraphNode]
        route = result
        let sequence: [SKAction] = result.map { gridGraphNode in
            let location = onFieldComponent.pointForGridPosition(gridGraphNode.gridPosition)
            let moveAction = SKAction.moveTo(location, duration: 0.3)
            let updateAction = SKAction.runBlock {
                onFieldComponent.currentGridPosition = gridGraphNode.gridPosition
            }
            return [moveAction, updateAction]
        }.reduce([], combine: +)
        node.runAction(SKAction.sequence(sequence))
    }

    func moveToCreature(creature: Creature) {
        let targetGridPosition = creature.onFieldComponent.currentGridPosition
        moveTo(targetGridPosition)
    }
}
