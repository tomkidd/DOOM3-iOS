//
//  MainMenuViewController.swift
//  DOOM3-iOS
//
//  Created by Tom Kidd on 1/26/19.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DEBUG -tkidd
//        performSegue(withIdentifier: "MozartsGhostSegue", sender: self)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitToMainMenu(segue: UIStoryboardSegue) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
