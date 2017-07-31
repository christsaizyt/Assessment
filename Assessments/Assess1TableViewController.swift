//
//  Assessment1TableViewController.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/25.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit
import RealmSwift

class Assess1TableViewController: UITableViewController {

    //  MARK: - model
    let realm = try! Realm()
    fileprivate lazy var players: Results<Player> = { self.realm.objects(Player.self).sorted(byKeyPath: Assessments1.realmSortedBy, ascending: true) }()
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Assessments1.tableCellIdentifier, for: indexPath)

        let player = players[indexPath.row]
        if let playerCell = cell as? Assess1TableViewCell {
            playerCell.player = player
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let needdeletePlayer = players[indexPath.row]
            try! realm.write{
                realm.delete(needdeletePlayer)
                refreshUI()
            }
        }
    }
    
    //  MARK: - Navigation
    @IBAction func unwindFromNewPlyaer(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? Assess1AddPlayerViewController, let newPlayer = sourceViewController.newPlayer {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //  from show player, update
                let needUpdatePlayer = players[selectedIndexPath.row]
                try! realm.write{
                    needUpdatePlayer.name = newPlayer.name
                    needUpdatePlayer.height = newPlayer.height
                    needUpdatePlayer.weight = newPlayer.weight
                    needUpdatePlayer.age = newPlayer.age
                    needUpdatePlayer.country = newPlayer.country
                    refreshUI()
                }
            }else{
                //  from add player, add
                let realm = try! Realm()
                try! realm.write{
                    realm.add(newPlayer)
                    refreshUI()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let identifier = segue.identifier, identifier == Assessments1.segueShowPlayer{
            if let showPlayerViewController = segue.destination as? Assess1AddPlayerViewController{
                if let selectedCell = sender as? Assess1TableViewCell{
                    if let indexPath = tableView.indexPath(for: selectedCell){
                        let player = players[indexPath.row]
                        showPlayerViewController.newPlayer = player
                    }
                }
            }
        }
    }

    //  MARK: - Others
    private func refreshUI(){
        players = realm.objects(Player.self).sorted(byKeyPath: Assessments1.realmSortedBy, ascending: true)
        DispatchQueue.main.async {
            self.tableView?.setEditing(false, animated: true)
            self.tableView?.reloadData()
            
        }
    }
}
