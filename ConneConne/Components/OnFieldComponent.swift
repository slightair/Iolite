import GameplayKit
import SpriteKit

class OnFieldComponent: GKComponent {
    static var scene: SKScene?

    var field: Field
    var currentGridPosition = vector_int2(0, 0)

    var renderComponent: RenderComponent {
        guard let component = entity?.componentForClass(RenderComponent.self) else {
            fatalError("OnFieldComponent's entity must have a RenderComponent")
        }
        return component
    }

    init(field: Field) {
        self.field = field

        super.init()
    }

    func warpTo(gridPosition: vector_int2) {
        currentGridPosition = gridPosition
        renderComponent.node.position = pointForGridPosition(gridPosition)
    }

    func pointForGridPosition(gridPosition: vector_int2) -> CGPoint {
        guard let scene = OnFieldComponent.scene as? LevelScene else {
            return CGPoint.zero
        }

        let baseX = (scene.size.width - GameConfiguration.Field.size.width) / 2 + GameConfiguration.Field.offset.x
        let baseY = (scene.size.height - GameConfiguration.Field.size.height) / 2 + GameConfiguration.Field.offset.y

        return CGPoint(x: baseX + CGFloat(gridPosition.x) * GameConfiguration.Field.blockSize + GameConfiguration.Field.blockSize / 2,
                       y: baseY + CGFloat(gridPosition.y) * GameConfiguration.Field.blockSize + GameConfiguration.Field.blockSize / 2)
    }
}
