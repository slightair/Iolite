import SpriteKit
import GameplayKit

struct ColliderType: OptionSetType, Hashable {
    static var requestedContactNotifications = [ColliderType: [ColliderType]]()
    static var definedCollisions = [ColliderType: [ColliderType]]()

    let rawValue: UInt32

    static var Obstacle: ColliderType  { return self.init(rawValue: 1 << 0) }
    static var Follower: ColliderType { return self.init(rawValue: 1 << 1) }
    static var Enemy: ColliderType { return self.init(rawValue: 1 << 2) }

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

    func notifyOnContactWithColliderType(colliderType: ColliderType) -> Bool {
        if let requestedContacts = ColliderType.requestedContactNotifications[self] {
            return requestedContacts.contains(colliderType)
        }

        return false
    }
}
