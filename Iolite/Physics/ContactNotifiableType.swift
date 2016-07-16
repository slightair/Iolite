import SpriteKit
import GameplayKit

protocol ContactNotifiableType {
    func contactWithEntityDidBegin(entity: GKEntity, point: CGPoint)
    func contactWithEntityDidEnd(entity: GKEntity)
}
