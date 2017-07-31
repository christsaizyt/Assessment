//
//  Assessment3TableViewController.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/30.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit

class Assess3TableViewController: UITableViewController {

    var users: [User] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    let formatter = DateFormatter()
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"   //  2017-7-28 14:30
        loadSample()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Assessment3", for: indexPath)
        
        let user = users[indexPath.row]
        if let userCell = cell as? Assess3TableViewCell {
            userCell.user = user
        }
        return cell
    }
    
    private func loadSample(){
        //  update self.users
        let toUser = "focusassessments"
        let catUserID = "GarfieldCat"
        let dogUserID = "GoofyDog"
        let PantherID = "Pink Panther"
        let lionID = "Lion King"
        let pandaID = "Kung Fu Panda"
        
        let catMessage1 = Message(fromUser: catUserID, toUser: toUser, time: "2017-7-29 12:00",
                                  text: "I'll rise, but I won't shine.")
        let catMessage2 = Message(fromUser: catUserID, toUser: toUser, time: "2017-7-29 13:00",
                                  text: "I'm not messy. I'm organizationally challenged!")
        let catMessage3 = Message(fromUser: catUserID, toUser: toUser, time: "2017-7-29 14:00",
                                  text: "Love me, feed me, never leave me.")
        let catMessage4 = Message(fromUser: catUserID, toUser: toUser, time: "2017-7-29 15:00",
                                  text: "I eat too much because I'm depressed, and I'm depressed because I eat too much. It's a vicious circle... that took years to perfect!")
        let catMessage5 = Message(fromUser: catUserID, toUser: toUser, time: "2017-7-29 16:00",
                                  text: "I shall now attempt to eat a diet lunch consisting of one leaf of lettuce lightly seasoned with ... one quart of Mayonnaise.")
        let catMessages:[Message] = [catMessage1, catMessage2, catMessage3, catMessage4, catMessage5]
        let catUser = User(name: "Garfield", profileImage: "cat.jpeg", messages: catMessages, lastReadTime: "2017-7-30 16:40", favorite: true)
        
        let dogMessage1 = Message(fromUser: dogUserID, toUser: toUser, time: "2017-7-28 12:00",
                                  text: "Gawrsh!")
        let dogMessage2 = Message(fromUser: dogUserID, toUser: toUser, time: "2017-7-28 13:00",
                                  text: "A-hyuck!")
        let dogMessage3 = Message(fromUser: dogUserID, toUser: toUser, time: "2017-7-28 14:00",
                                  text: "Somethin's wrong here!")
        let dogMessages:[Message] = [dogMessage1, dogMessage2, dogMessage3]
        let dogUser = User(name: "Goffy", profileImage: "dog.png", messages: dogMessages, lastReadTime: "2017-7-27 16:40", favorite: false)
        
        let patherMessage1 = Message(fromUser: PantherID, toUser: toUser, time: "2017-7-30 12:00",
                                     text: "Do not take life too seriously. You will never get out of it alive.")
        let patherMessage2 = Message(fromUser: PantherID, toUser: toUser, time: "2017-7-30 13:00",
                                     text: "Always remember that you are absolutely unique. Just like everyone else.")
        let patherMessage3 = Message(fromUser: PantherID, toUser: toUser, time: "2017-7-30 14:00",
                                     text: "I'm sorry, if you were right, I'd agree with you.")
        let patherMessage4 = Message(fromUser: PantherID, toUser: toUser, time: "2017-7-30 15:00",
                                     text: "Any girl can be glamorous. All you have to do is stand still and look stupid.")
        let patherMessages:[Message] = [patherMessage1, patherMessage2, patherMessage3, patherMessage4]
        let patherUser = User(name: "Pink Panther", profileImage: "pather.jpg", messages: patherMessages, lastReadTime: "2017-7-28 16:40", favorite: false)
        
        let lionMessage1 = Message(fromUser: lionID, toUser: toUser, time: "2017-7-30 12:00",
                                     text: "You said you’d always be there for me!")
        let lionMessage2 = Message(fromUser: lionID, toUser: toUser, time: "2017-7-30 13:00",
                                   text: "Run away, Scar. And never return.")
        let lionMessage3 = Message(fromUser: lionID, toUser: toUser, time: "2017-7-30 14:00",
                                   text: "Bad things happen, and you can’t do anything about them.")
        let lionMessage4 = Message(fromUser: lionID, toUser: toUser, time: "2017-7-30 15:00",
                                   text: "Pinned ya! Pinned ya again!")
        let lionMessage5 = Message(fromUser: lionID, toUser: toUser, time: "2017-7-30 16:00",
                                   text: "See, I told you having a lion on our side wasn’t such a bad idea.")
        let lionMessages:[Message] = [lionMessage1,lionMessage2,lionMessage3,lionMessage4,lionMessage5]
        let lionUser = User(name: "Simba", profileImage: "lion.jpeg", messages: lionMessages, lastReadTime: "2017-7-29 16:40", favorite: true)
        
        let pandaMessage1 = Message(fromUser: pandaID, toUser: toUser, time: "2017-7-1 12:00",
                                   text: "Your story may not have such a happy beginning but that does not make you who you are, it is the rest of it- who you choose to be")
        let pandaMessage2 = Message(fromUser: pandaID, toUser: toUser, time: "2017-7-1 12:00",
                                    text: "There are no coincidences in this world.")
        let pandaMessage3 = Message(fromUser: pandaID, toUser: toUser, time: "2017-7-1 12:00",
                                    text: "Your mind is like this water, my friend. When it is agitated, it becomes difficult to see. But if you allow it to settle, the answer becomes clear.")
        let pandaMessages:[Message] = [pandaMessage1,pandaMessage2,pandaMessage3]
        let pandaUser = User(name: "Kung Fu Panda", profileImage: "panda.jpeg", messages: pandaMessages, lastReadTime: "2017-7-31 16:40", favorite: true)
        
        self.users = ([catUser, dogUser, patherUser, lionUser, pandaUser]).sorted(by:{stringToDateConvert($0.messages!.last!.time!) > stringToDateConvert($1.messages!.last!.time!)})
    }

}
