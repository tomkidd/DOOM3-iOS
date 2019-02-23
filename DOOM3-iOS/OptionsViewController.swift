//
//  OptionsViewController.swift
//  DOOM3-iOS
//
//  Created by Tom Kidd on 2/6/19.
//

import UIKit

class OptionsViewController: UIViewController {

    let defaults = UserDefaults()
    
    #if os(iOS)
    @IBOutlet weak var tiltAimingSwitch: UISwitch!
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
        tiltAimingSwitch.isOn = defaults.integer(forKey: "tiltAiming") == 1
        #endif

        // Do any additional setup after loading the view.
    }
    
    #if os(iOS)
    @IBAction func tiltAimingToggle(_ sender: UISwitch) {
        defaults.set(sender.isOn ? 1 : 0, forKey: "tiltAiming")
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
