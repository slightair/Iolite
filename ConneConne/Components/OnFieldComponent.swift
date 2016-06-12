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

        let baseX = (scene.size.width - scene.fieldSize.width) / 2 + scene.fieldOffset.x
        let baseY = (scene.size.height - scene.fieldSize.height) / 2 + scene.fieldOffset.y

        return CGPoint(x: baseX + CGFloat(gridPosition.x) * scene.blockSize + scene.blockSize / 2,
                       y: baseY + CGFloat(gridPosition.y) * scene.blockSize + scene.blockSize / 2)
    }
}
