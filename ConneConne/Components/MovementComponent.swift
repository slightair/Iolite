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

    func moveTo(gridPosition: vector_int2) {
        let node = renderComponent.node
        let onFieldComponent = self.onFieldComponent

        node.removeAllActions()

        let targetPosition = onFieldComponent.pointForGridPosition(gridPosition)
        let moveAction = SKAction.moveTo(targetPosition, duration: 3.0)
        let updateAction = SKAction.runBlock {
            onFieldComponent.currentGridPosition = gridPosition
        }
        let sequence = [moveAction, updateAction]

        node.runAction(SKAction.sequence(sequence))
    }

    func moveToCreature(creature: Creature) {
        let targetGridPosition = creature.onFieldComponent.currentGridPosition
        moveTo(targetGridPosition)
    }
}
