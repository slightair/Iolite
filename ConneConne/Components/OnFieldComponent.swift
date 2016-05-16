import GameplayKit
import SpriteKit

class OnFieldComponent: GKComponent {
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
        return CGPoint(x: Int(gridPosition.x) * GameScene.BlockSize + GameScene.BlockSize / 2,
                       y: -Int(gridPosition.y) * GameScene.BlockSize - GameScene.BlockSize / 2)
    }
}
