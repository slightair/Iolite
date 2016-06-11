import SpriteKit
import GameplayKit

class Enemy: GKEntity {
    let agent = GKAgent2D()

    var renderComponent: RenderComponent {
        guard let component = componentForClass(RenderComponent.self) else {
            fatalError("Enemy must have a RenderComponent")
        }
        return component
    }

    var onFieldComponent: OnFieldComponent {
        guard let component = componentForClass(OnFieldComponent.self) else {
            fatalError("Enemy must have a OnFieldComponent")
        }
        return component
    }

    required init(field: Field) {
        super.init()

        setUpComponents(field)
    }

    func setUpComponents(field: Field) {
        let physicsBody = SKPhysicsBody(circleOfRadius: 24, center: CGPoint(x: 0, y: -24))

        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Enemy)
        addComponent(physicsComponent)

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        let lifeComponent = LifeComponent(life: initialLife, maximumLife: maximumLife)
        addComponent(lifeComponent)

        setUpAgent(agent)
        addComponent(agent)

        let node = renderComponent.node
        node.physicsBody = physicsComponent.physicsBody

        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.size = textureSize
        node.addChild(spriteNode)
    }
}

extension Enemy: CreatureConfiguration {
    var textureSize: CGSize {
        return CGSize(width: 96, height: 96)
    }

    var textureName: String {
        return "enemy"
    }

    var initialLife: Int {
        return 100
    }

    var maximumLife: Int {
        return 100
    }

    func setUpAgent(agent: GKAgent2D) {
        agent.delegate = self
    }
}

extension Enemy: GKAgentDelegate {
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
