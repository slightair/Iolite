import GameplayKit
import SpriteKit

class Creature: GKEntity {
    var renderComponent: RenderComponent {
        guard let component = componentForClass(RenderComponent.self) else {
            fatalError("Creature must have a RenderComponent")
        }
        return component
    }

    override init() {
        super.init()

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)
    }
}
