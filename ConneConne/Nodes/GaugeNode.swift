import SpriteKit

class GaugeNode: SKSpriteNode {
    struct Configuration {
        static let size = CGSize(width: 38.0, height: 6.0)
        static let levelNodeSize = CGSize(width: 36.0, height: 4.0)
        static let levelUpdateDuration: NSTimeInterval = 0.1
        static let backgroundColor = SKColor.blackColor()
        static let levelColor = SKColor.greenColor()
    }

    var level: Double = 1.0 {
        didSet {
            let action = SKAction.scaleXTo(CGFloat(level), duration: Configuration.levelUpdateDuration)
            action.timingMode = .EaseInEaseOut

            levelNode.runAction(action)
        }
    }

    let levelNode = SKSpriteNode(color: Configuration.levelColor, size: Configuration.levelNodeSize)

    init() {
        super.init(texture: nil, color: Configuration.backgroundColor, size: Configuration.size)

        addChild(levelNode)

        let xRange = SKRange(constantValue: levelNode.size.width / -2.0)
        let yRange = SKRange(constantValue: 0.0)

        let constraint = SKConstraint.positionX(xRange, y: yRange)
        constraint.referenceNode = self

        levelNode.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        levelNode.constraints = [constraint]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

