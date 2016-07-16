import GameplayKit

class EnemyAttackState: EnemyBaseState {
    var elapsedTime: NSTimeInterval = 0.0

    var physicsComponent: PhysicsComponent {
        guard let component = entity.componentForClass(PhysicsComponent.self) else {
            fatalError("entity must have a PhysicsComponent.")
        }
        return component
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        elapsedTime = 0.0
        animationComponent.requestedAnimationState = .Attack

        let contactedBodies = physicsComponent.physicsBody.allContactedBodies()
        for contactedBody in contactedBodies {
            guard let entity = (contactedBody.node as? EntityNode)?.entity else {
                continue
            }
            if let follower = entity as? Follower {
                applyDamageToFollower(follower)
            }
        }
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        elapsedTime += seconds

        if elapsedTime >= GameConfiguration.Creature.Enemy.attackStateDuration {
            let contactedBodies = physicsComponent.physicsBody.allContactedBodies()
            for contactedBody in contactedBodies {
                guard let entity = (contactedBody.node as? EntityNode)?.entity else {
                    continue
                }
                if let _ = entity as? Follower {
                    stateMachine?.enterState(EnemyPreAttackState.self)
                    return
                }
            }
            stateMachine?.enterState(EnemyWaitState.self)
        }
    }

    func applyDamageToFollower(follower: Follower) {
        let damage = GameConfiguration.Creature.Enemy.attack

        follower.lifeComponent.damaged(damage)

        let damagePosition = follower.renderComponent.node.position

        if let levelScene = animationComponent.node.scene as? LevelScene {
            levelScene.addDamageInfo(damage, target: .Follower, position: damagePosition)
        }
    }
}
