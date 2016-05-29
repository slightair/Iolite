import GameplayKit
import SpriteKit

class Creature: GKEntity {
    var renderComponent: RenderComponent {
        guard let component = componentForClass(RenderComponent.self) else {
            fatalError("Creature must have a RenderComponent")
        }
        return component
    }

    var onFieldComponent: OnFieldComponent {
        guard let component = componentForClass(OnFieldComponent.self) else {
            fatalError("Creature must have a OnFieldComponent")
        }
        return component
    }

    var movementComponent: MovementComponent {
        guard let component = componentForClass(MovementComponent.self) else {
            fatalError("Creature must have a MovementComponent")
        }
        return component
    }

    required init(field: Field) {
        super.init()

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        let movementComponent = MovementComponent()
        addComponent(movementComponent)
    }
}
