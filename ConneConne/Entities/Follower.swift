import SpriteKit
import GameplayKit

class Follower: Creature, GKAgentDelegate {
    static let textureSize = CGSize(width: 32, height: 32)
    static let textureName = "creature"

    let agent = FollowerAgent()

    override init() {
        super.init()

        agent.delegate = self
        agent.radius = 30.0
        agent.maxSpeed = 250.0
        agent.maxAcceleration = 300.0

        addComponent(agent)

        let spriteNode = SKSpriteNode(imageNamed: Follower.textureName)
        spriteNode.size = Follower.textureSize
        renderComponent.node.addChild(spriteNode)
    }

    func agentWillUpdate(agent: GKAgent) {
        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            agent2D.position = vector_float2(Float(node.position.x), Float(node.position.y))
            print(agent2D.position)
        }
    }

    func agentDidUpdate(agent: GKAgent) {
        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
            print(node.position)
        }
    }
}
