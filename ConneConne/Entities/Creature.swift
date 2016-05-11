import GameplayKit

class Creature: GKEntity {
    enum Type {
        case Default
    }

    let type: Type

    init(type: Type = .Default) {
        self.type = type
    }
}
