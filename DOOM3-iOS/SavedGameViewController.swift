//
//  SavedGameViewController.swift
//  DOOM3-iOS
//
//  Created by Tom Kidd on 2/12/19.
//

import UIKit

class SavedGameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var savesList: UITableView!
    @IBOutlet weak var loadGameButton: UIButton!
    
    var selectedSavedGame = ""
    
    var saves = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savesList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        var gameDir = ""
        gameDir = "base"
        
        #if os(tvOS)
        let savesPath = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path + "/../Library/Application Support/dhewm3/\(gameDir)/savegames"
        #else
        let savesPath = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path + "/../Library/Application Support/dhewm3/\(gameDir)/savegames"
        #endif
        
        do {
            saves = try FileManager.default.contentsOfDirectory(atPath: savesPath).filter{ $0.contains(".save") }
            savesList.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoadGameSegue" {
            (segue.destination as! GameViewController).selectedSavedGame = selectedSavedGame
        }
    }
}

extension SavedGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSavedGame = saves[indexPath.row]
        loadGameButton.isHidden = false
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        #if os(iOS)
    //        return 100
    //        #endif
    //        #if os(tvOS)
    //        return 200
    //        #endif
    //    }
}

extension SavedGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = saves[indexPath.row]//.replacingOccurrences(of: ".svg", with: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saves.count
    }
}
