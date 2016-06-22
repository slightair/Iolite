import GameplayKit

protocol ContactNotifiableType {
    func contactWithEntityDidBegin(entity: GKEntity)
    func contactWithEntityDidEnd(entity: GKEntity)
}
