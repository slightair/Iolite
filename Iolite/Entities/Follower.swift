import SpriteKit
import GameplayKit

class Follower: GKEntity {
    let agent = GKAgent2D()
    var contactPoint: CGPoint?

    var renderComponent: RenderComponent {
        guard let component = componentForClass(RenderComponent.self) else {
            fatalError("Follower must have a RenderComponent")
        }
        return component
    }

    var onFieldComponent: OnFieldComponent {
        guard let component = componentForClass(OnFieldComponent.self) else {
            fatalError("Follower must have a OnFieldComponent")
        }
        return component
    }

    var lifeComponent: LifeComponent {
        guard let component = componentForClass(LifeComponent.self) else {
            fatalError("Follower must have a LifeComponent")
        }
        return component
    }

    enum FollowerMandate {
        case Standby
        case Target(Enemy)
    }

    var mandate: FollowerMandate {
        didSet {
            switch mandate {
            case .Target(let enemy):
                agent.behavior = FollowerBehavior.behaviorForAgent(agent, targetAgent: enemy.agent)
            default:
                break
            }
        }
    }

    required init(field: Field) {
        mandate = .Standby

        super.init()

        setUpComponents(field)
    }

    func setUpComponents(field: Field) {
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Follower)
        addComponent(physicsComponent)

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        let lifeComponent = LifeComponent(life: initialLife, maximumLife: maximumLife)
        addComponent(lifeComponent)

        let intelligenceComponent = IntelligenceComponent(states: [
            FollowerAgentControlledState(entity: self),
            FollowerPreAttackState(entity: self),
            FollowerAttackState(entity: self),
            FollowerDamagedState(entity: self),
            FollowerWaitState(entity: self),
        ])
        addComponent(intelligenceComponent)

        let animationComponent = AnimationComponent(textureSize: textureSize, animations: animations)
        addComponent(animationComponent)

        setUpAgent(agent)
        addComponent(agent)

        let node = renderComponent.node
        node.physicsBody = physicsComponent.physicsBody
        node.addChild(animationComponent.node)
    }
}

extension Follower: CreatureConfiguration {
    var physicsBody: SKPhysicsBody {
        return SKPhysicsBody(circleOfRadius: GameConfiguration.Creature.Follower.physicsBodyCircleOfRadius,
                             center: GameConfiguration.Creature.Follower.physicsBodyCenter)
    }

    var textureSize: CGSize {
        return GameConfiguration.Creature.Follower.textureSize
    }

    var textureName: String {
        return GameConfiguration.Creature.Follower.textureName
    }

    var animations: [AnimationState: Animation] {
        return [
            .Wait: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.whiteColor(), animationState: .Wait),
            .Walk: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.greenColor(), animationState: .Walk),
            .PreAttack: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.yellowColor(), animationState: .PreAttack),
            .Attack: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.orangeColor(), animationState: .Attack),
            .Damaged: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.redColor(), animationState: .Damaged),
        ]
    }

    var initialLife: Int {
        return GameConfiguration.Creature.Follower.initialLife
    }

    var maximumLife: Int {
        return GameConfiguration.Creature.Follower.maximumLife
    }

    func setUpAgent(agent: GKAgent2D) {
        agent.mass = GameConfiguration.Creature.Follower.agentMass
        agent.radius = GameConfiguration.Creature.Follower.agentRadius
        agent.maxSpeed = GameConfiguration.Creature.Follower.agentMaxSpeed
        agent.maxAcceleration = GameConfiguration.Creature.Follower.agentMaxAcceleration

        agent.delegate = self
    }

    func updateAgentPositionToMatchNodePosition() {
        let node = renderComponent.node
        agent.position = vector_float2(Float(node.position.x), Float(node.position.y))
    }

    func updateNodePositionToMatchAgentPosition() {
        renderComponent.node.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
    }
}

extension Follower: GKAgentDelegate {
    func agentWillUpdate(agent: GKAgent) {
        updateAgentPositionToMatchNodePosition()
    }

    func agentDidUpdate(agent: GKAgent) {
        guard let intelligenceComponent = componentForClass(IntelligenceComponent.self) else {
            return
        }

        if intelligenceComponent.stateMachine.currentState is FollowerAgentControlledState {
            updateNodePositionToMatchAgentPosition()
        }
    }
}

extension Follower: ContactNotifiableType {
    func contactWithEntityDidBegin(entity: GKEntity, point: CGPoint) {
        guard let _ = entity as? Enemy else {
            return
        }

        contactPoint = point
        if let stateMachine = componentForClass(IntelligenceComponent.self)?.stateMachine {
            stateMachine.enterState(FollowerPreAttackState.self)
        }
    }

    func contactWithEntityDidEnd(entity: GKEntity) {
        guard let _ = entity as? Enemy else {
            return
        }

        contactPoint = nil
        if let stateMachine = componentForClass(IntelligenceComponent.self)?.stateMachine {
            stateMachine.enterState(FollowerAgentControlledState.self)
        }
    }
}
