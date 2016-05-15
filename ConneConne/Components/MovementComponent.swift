import GameplayKit
import SpriteKit

class MovementComponent: GKComponent {
    var nextGridPosition = vector_int2(0, 0)
    var route: [GKGridGraphNode]? = nil {
        didSet {
            if let route = route {
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

    var moveDuration: NSTimeInterval {
        return 0.3
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
        let onFieldComponent = self.onFieldComponent

        if route != nil {
            route = nil
            renderComponent.node.removeAllActions()
            onFieldComponent.warpTo(nextGridPosition)
        }

        let graph = onFieldComponent.field.graph
        guard let startNode = graph.nodeAtGridPosition(onFieldComponent.currentGridPosition),
            toNode = graph.nodeAtGridPosition(gridPosition) else {
                return
        }

        route = graph.findPathFromNode(startNode, toNode: toNode) as? [GKGridGraphNode]
    }

    func tick() {
        guard let route = route else {
            return
        }

        let onFieldComponent = self.onFieldComponent

        if onFieldComponent.currentGridPosition.x != nextGridPosition.x ||
            onFieldComponent.currentGridPosition.y != nextGridPosition.y {
            return
        } else if route.count > 0 {
            nextGridPosition = route.first!.gridPosition
            self.route = route.dropFirst().map { $0 }
            renderComponent.node.runAction(SKAction.moveTo(onFieldComponent.pointForGridPosition(nextGridPosition), duration: moveDuration)) {
                onFieldComponent.currentGridPosition = self.nextGridPosition
            }
        } else {
            self.route = nil
        }
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        tick()
    }
}
