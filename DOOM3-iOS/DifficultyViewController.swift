//
//  DifficultyViewController.swift
//  DOOM3-iOS
//
//  Created by Tom Kidd on 1/30/19.
//

import UIKit

class DifficultyViewController: UIViewController {
    
    var difficulty = 0
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!

    @IBOutlet weak var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func easyDifficulty(_ sender: UIButton) {
        difficulty = 0
        performSegue(withIdentifier: "StartGameSegue", sender: self)
    }
    
    @IBAction func normalDifficulty(_ sender: UIButton) {
        difficulty = 1
        performSegue(withIdentifier: "StartGameSegue", sender: self)
    }
    
    @IBAction func hardDifficulty(_ sender: UIButton) {
        difficulty = 2
        performSegue(withIdentifier: "StartGameSegue", sender: self)
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGameSegue" {
            (segue.destination as! GameViewController).difficulty = difficulty
            (segue.destination as! GameViewController).newgame = true
        }
    }

}
