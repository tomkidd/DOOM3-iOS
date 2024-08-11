import UIKit
import GameController

class GameViewController: UIViewController, JoystickDelegate {
    
    var difficulty = -1
    var newgame = false

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!

    var selectedSavedGame = ""
    
    // New properties for joystick and controller support
    var joyStickView: JoyStickView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up touch-based joystick
        joyStickView = JoyStickView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        joyStickView.delegate = self
        view.addSubview(joyStickView)
        
        // Set up controller input system
        ControllerInputSystem.shared.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            
            var argv: [String?] = [ Bundle.main.resourcePath! + "/doom3"];
            
            #if os(tvOS)
                let savesPath = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
                argv.append("+set")
                argv.append("fs_savepath")
                argv.append(savesPath)
            #endif

            if self.difficulty >= 0 {
                argv.append("+set")
                argv.append("g_skill")
                argv.append("\(self.difficulty)")
            }

            // Mission Pack
            #if _D3XP
                argv.append("+set")
                argv.append("fs_game")
                argv.append("d3xp")

                let startMap = "erebus1"
            #else
                let startMap = "mars_city1"
            #endif

            if self.newgame {
                argv.append("+map")
                argv.append("game/\(startMap)")
            }

            if !self.selectedSavedGame.isEmpty {
                argv.append("+loadGame")
                argv.append(self.selectedSavedGame)
            }
            
            var commandLine = ""
            
            for arg in argv {
                commandLine += " " + arg!
            }
            
            print(commandLine)
            
            argv.append(nil)
            let argc:Int32 = Int32(argv.count - 1)
            var cargs = argv.map { $0.flatMap { UnsafeMutablePointer<Int8>(strdup($0)) } }
            
            // todo: fix for DOOM3 -tkidd
            Sys_Startup(argc, &cargs)

            for ptr in cargs { free(UnsafeMutablePointer(mutating: ptr)) }
        }
    }
    
    // MARK: - JoystickDelegate methods
    
    func handleJoyStick(angle: CGFloat, displacement: CGFloat) {
        // Handle joystick input (works for both touch and controller)
        print("Angle: \(angle), Displacement: \(displacement)")
        // Add your game logic here to handle joystick input
        // You might want to call a method in your game engine to move the player
        // For example: movePlayer(angle: angle, displacement: displacement)
    }
    
    func handleJoyStickPosition(x: CGFloat, y: CGFloat) {
        // Handle joystick position (works for both touch and controller)
        print("X: \(x), Y: \(y)")
        // Add your game logic here to handle joystick position
        // You might want to call a method in your game engine to move the player
        // For example: movePlayer(x: x, y: y)
    }
    
    #if os(iOS)
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    #endif
}
