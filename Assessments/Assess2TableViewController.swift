//
//  Assessment2ViewController.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/25.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit
import Firebase

class Assess2TableViewController: UITableViewController {

    //  MARK: - model
    fileprivate var events: [(uid: String, event: Event)] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    //  MARK: - parameters
    fileprivate var rootRef:DatabaseReference!{ get{ return Database.database().reference() } }
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFireBaseObserve()
        
        //tableView.estimatedRowHeight = tableView.rowHeight
        //tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //  MARK: - UITableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Assessments2.tableCellIdentifier, for: indexPath)
        
        let event = events[indexPath.row]
        if let eventCell = cell as? Assess2TableViewCell {
            eventCell.event = event.event
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.rootRef.child(Assessments2.firebaseChildName).child(events[indexPath.row].uid).removeValue()
        }
    }

    //  MARK: - Navigation
    @IBAction func unwindFromNewEvent(sender: UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let identifier = segue.identifier, identifier == Assessments2.segueShowEvent{
            if let showEventViewController = segue.destination as? Assess2AddEventViewController{
                if let selectedCell = sender as? Assess2TableViewCell{
                    if let indexPath = tableView.indexPath(for: selectedCell){
                        let event = events[indexPath.row]
                        showEventViewController.event = event.event
                        showEventViewController.uid = event.uid
                    }
                }
            }
        }
    }
    
    //  MARK: - Others
    private func updateFireBaseObserve(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        rootRef.child(Assessments2.firebaseChildName).queryOrdered(byChild: Assessments2.firebastSortBy).observe(.value , with: { snapshot in
            //  .value is not a good way, but it works.
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{ [unowned self] in
                var newEvents: [(String, Event)] = []
                for item in snapshot.children{
                    let newEvent = Event(snapshot: item as! DataSnapshot)
                    newEvents.append(((item as! DataSnapshot).key, newEvent))
                }
                self.events = newEvents
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        })
    }
}
