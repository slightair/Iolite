import GameplayKit

class FollowerAttackState: FollowerBaseState {
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
            if let enemy = entity as? Enemy {
                applyDamageToEnemy(enemy)
            }
        }
    }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

        elapsedTime += seconds

        if elapsedTime >= GameConfiguration.Creature.Follower.attackStateDuration {
            let contactedBodies = physicsComponent.physicsBody.allContactedBodies()
            for contactedBody in contactedBodies {
                guard let entity = (contactedBody.node as? EntityNode)?.entity else {
                    continue
                }
                if let _ = entity as? Enemy {
                    stateMachine?.enterState(FollowerPreAttackState.self)
                    return
                }
            }
            stateMachine?.enterState(FollowerAgentControlledState.self)
        }
    }

    func applyDamageToEnemy(enemy: Enemy) {
        let damage = 1

        enemy.lifeComponent.damaged(damage)

        guard let damagePosition = entity.contactPoint else {
            return
        }

        if let levelScene = animationComponent.node.scene as? LevelScene {
            levelScene.addDamageInfo(damage, position: damagePosition)
        }
    }
}
