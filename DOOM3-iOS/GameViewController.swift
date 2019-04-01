//
//  GameViewController.swift
//  DOOM3-iOS
//
//  Created by Tom Kidd on 1/26/19.
//

import UIKit

class GameViewController: UIViewController {
    
    var difficulty = -1
    var newgame = false

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!

    var selectedSavedGame = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var gameDir = ""
        gameDir = "base"
        
        #if os(tvOS)
        let documentsDir = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        let documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif

//        print("documentsDir: \(documentsDir)")
        
        // todo: fix for DOOM3 -tkidd
        //Sys_SetHomeDir(documentsDir)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            
            var argv: [String?] = [ Bundle.main.resourcePath! + "/doom3"];
            
//            argv.append("+map")
//            argv.append("game/alphalabs2")
        //    argv.append("\(self.difficulty)")

            
            if self.difficulty >= 0 {
                argv.append("+set")
                argv.append("g_skill")
                argv.append("\(self.difficulty)")
            }
            
            if self.newgame {
//                argv.append("+startGame")
//                mars_city1
                argv.append("+map")
                argv.append("game/mars_city1")
            }
            
            // Mission Pack
            #if _D3XP
            argv.append("+set")
            argv.append("fs_game")
            argv.append("d3xp")
            #endif
            
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
    
    #if os(iOS)
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    #endif
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
