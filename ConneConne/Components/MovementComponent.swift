import GameplayKit
import SpriteKit

class MovementComponent: GKComponent {
    var field: Field
    var currentGridPosition = vector_int2(0, 0)
    var nextGridPosition = vector_int2(0, 0)
    var route: [GKGridGraphNode]? = nil {
        didSet {
            if let route = route {
                var points = route.map { pointForGridPosition($0.gridPosition) }
                routeNode = SKShapeNode(points: &points, count: points.count)
            } else {
                routeNode = nil
            }
        }
    }

    init(field: Field) {
        self.field = field
        super.init()
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

    func moveTo(gridPosition: vector_int2) {
        if route != nil {
            route = nil
            renderComponent.node.removeAllActions()
            warpTo(nextGridPosition)
        }

        guard let startNode = field.graph.nodeAtGridPosition(currentGridPosition),
            toNode = field.graph.nodeAtGridPosition(gridPosition) else {
                return
        }

        route = field.graph.findPathFromNode(startNode, toNode: toNode) as? [GKGridGraphNode]
    }

    func warpTo(gridPosition: vector_int2) {
        currentGridPosition = gridPosition
        nextGridPosition = gridPosition

        renderComponent.node.position = pointForGridPosition(gridPosition)
    }

    func tick() {
        guard let route = route else {
            return
        }

        if currentGridPosition.x != nextGridPosition.x ||
            currentGridPosition.y != nextGridPosition.y {
            return
        } else if route.count > 0 {
            nextGridPosition = route.first!.gridPosition
            self.route = route.dropFirst().map { $0 }
            renderComponent.node.runAction(SKAction.moveTo(pointForGridPosition(nextGridPosition), duration: moveDuration)) {
                self.currentGridPosition = self.nextGridPosition
            }
        } else {
            self.route = nil
        }
    }

    func pointForGridPosition(gridPosition: vector_int2) -> CGPoint {
        return CGPoint(x: Int(gridPosition.x) * GameScene.BlockSize + GameScene.BlockSize / 2,
                       y: -Int(gridPosition.y) * GameScene.BlockSize - GameScene.BlockSize / 2)
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        tick()
    }
}
