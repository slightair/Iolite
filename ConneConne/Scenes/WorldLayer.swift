import SpriteKit

enum WorldLayer: CGFloat {
    static let zSpacePerCharacter: CGFloat = 10

    case Board = -1000
    case Shadows = -500
    case Obstacles = -25
    case Characters = 0
    case Info = 8000
    case Debug = 10000

    var nodeName: String {
        switch self {
        case .Board:
            return "board"
        case .Shadows:
            return "shadows"
        case .Obstacles:
            return "obstacles"
        case .Characters:
            return "characters"
        case .Info:
            return "info"
        case .Debug:
            return "debug"
        }
    }

    var nodePath: String {
        return "/world/\(nodeName)"
    }

    static let allLayers = [
        Board,
        Shadows,
        Obstacles,
        Characters,
        Info,
        Debug,
    ]
}
