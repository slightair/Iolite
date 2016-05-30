import GameplayKit
import SpriteKit

class Creature: GKEntity {
    let agent = GKAgent2D()

    var textureSize: CGSize {
        fatalError("Must override textureSize")
    }

    var textureName: String {
        fatalError("Must override textureName")
    }

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

    required init(field: Field) {
        super.init()

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        agent.delegate = self
        addComponent(agent)

        let node = renderComponent.node
        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.size = textureSize
        node.addChild(spriteNode)
    }
}

extension Creature: GKAgentDelegate {
    func agentWillUpdate(agent: GKAgent) {
        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            agent2D.position = vector_float2(Float(node.position.x), Float(node.position.y))
        }
    }

    func agentDidUpdate(agent: GKAgent) {
        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
        }
    }
}
