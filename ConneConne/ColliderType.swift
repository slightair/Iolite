import SpriteKit
import GameplayKit

struct ColliderType: OptionSetType, Hashable {
    static var requestedContactNotifications = [ColliderType: [ColliderType]]()
    static var definedCollisions = [ColliderType: [ColliderType]]()

    let rawValue: UInt32

    var hashValue: Int {
        return Int(rawValue)
    }

    var categoryMask: UInt32 {
        return rawValue
    }

    var collisionMask: UInt32 {
        let mask = ColliderType.definedCollisions[self]?.reduce(ColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        return mask?.rawValue ?? 0
    }

    var contactMask: UInt32 {
        let mask = ColliderType.requestedContactNotifications[self]?.reduce(ColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        return mask?.rawValue ?? 0
    }
}
