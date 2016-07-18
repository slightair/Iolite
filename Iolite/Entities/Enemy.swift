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

    var lifeComponent: LifeComponent {
        guard let component = componentForClass(LifeComponent.self) else {
            fatalError("Follower must have a LifeComponent")
        }
        return component
    }

    required init(field: Field) {
        super.init()

        setUpComponents(field)
    }

    func setUpComponents(field: Field) {
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Enemy)
        addComponent(physicsComponent)

        let renderComponent = RenderComponent(entity: self)
        addComponent(renderComponent)

        let onFieldComponent = OnFieldComponent(field: field)
        addComponent(onFieldComponent)

        let lifeComponent = LifeComponent(life: initialLife, maximumLife: maximumLife)
        lifeComponent.delegate = self
        addComponent(lifeComponent)

        let intelligenceComponent = IntelligenceComponent(states: [
            EnemyWaitState(entity: self),
            EnemyPreAttackState(entity: self),
            EnemyAttackState(entity: self),
            EnemyDamagedState(entity: self),
            EnemyDeathState(entity: self),
            EnemyExitState(entity: self),
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

extension Enemy: CreatureConfiguration {
    var physicsBody: SKPhysicsBody {
        return SKPhysicsBody(circleOfRadius: GameConfiguration.Creature.Enemy.physicsBodyCircleOfRadius,
                             center: GameConfiguration.Creature.Enemy.physicsBodyCenter)
    }

    var textureSize: CGSize {
        return GameConfiguration.Creature.Enemy.textureSize
    }

    var textureName: String {
        return GameConfiguration.Creature.Enemy.textureName
    }

    var animations: [AnimationState: Animation] {
        return [
            .Wait: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.whiteColor(), animationState: .Wait),
            .Walk: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.greenColor(), animationState: .Walk),
            .PreAttack: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.yellowColor(), animationState: .PreAttack),
            .Attack: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.orangeColor(), animationState: .Attack),
            .Damaged: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.redColor(), animationState: .Damaged),
            .Death: AnimationComponent.animation(fromTextureName: textureName, color: SKColor.blackColor(), animationState: .Death),
        ]
    }

    var initialLife: Int {
        return GameConfiguration.Creature.Enemy.initialLife
    }

    var maximumLife: Int {
        return GameConfiguration.Creature.Enemy.maximumLife
    }

    func setUpAgent(agent: GKAgent2D) {
        agent.mass = GameConfiguration.Creature.Enemy.agentMass
        agent.radius = GameConfiguration.Creature.Enemy.agentRadius
        agent.maxSpeed = GameConfiguration.Creature.Enemy.agentMaxSpeed
        agent.maxAcceleration = GameConfiguration.Creature.Enemy.agentMaxAcceleration

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
        guard let intelligenceComponent = componentForClass(IntelligenceComponent.self) else {
            return
        }

        if intelligenceComponent.stateMachine.currentState is EnemyWaitState {

        }

        let node = renderComponent.node
        if let agent2D = agent as? GKAgent2D {
            node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
        }
    }
}

extension Enemy: ContactNotifiableType {
    func contactWithEntityDidBegin(entity: GKEntity, point: CGPoint) {
        guard let _ = entity as? Follower else {
            return
        }

        if let stateMachine = componentForClass(IntelligenceComponent.self)?.stateMachine {
            stateMachine.enterState(EnemyPreAttackState.self)
        }
    }

    func contactWithEntityDidEnd(entity: GKEntity) {
        guard let _ = entity as? Enemy else {
            return
        }

        if let stateMachine = componentForClass(IntelligenceComponent.self)?.stateMachine {
            stateMachine.enterState(EnemyWaitState.self)
        }
    }
}

extension Enemy: LifeComponentDelegate {
    func lifeComponentDidDamage(lifeComponent: LifeComponent) {
        guard let intelligenceComponent = componentForClass(IntelligenceComponent.self) else {
            return
        }
        intelligenceComponent.stateMachine.enterState(EnemyDamagedState.self)
    }
}
