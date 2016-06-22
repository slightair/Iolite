import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = LevelScene(size: CGSize(width: 320, height: 480))
        let skView = self.view as! SKView
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        scene.scaleMode = .AspectFill

        skView.presentScene(scene)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
