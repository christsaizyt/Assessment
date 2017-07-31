//
//  Event.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/27.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import Foundation
import Firebase

class Event{
    
    // MARK - properties
    var name:String = ""
    var address:String = ""
    var price:Int = 0
    var time:String = ""
    var image:String = ""
    var created: String = NSDate().description
    
    init(name: String, address: String, price: Int, time: String, image: String) {
        self.name = name
        self.address = address
        self.price = price
        self.time = time
        self.image = image
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        self.name = (snapshotValue?[Assessments2.nameProperty] ?? "") as! String
        self.address = (snapshotValue?[Assessments2.addressProperty] ?? "") as! String
        self.price = (snapshotValue?[Assessments2.priceProperty] ?? 0) as! Int
        self.time = (snapshotValue?[Assessments2.timeProperty] ?? "") as! String
        self.image = (snapshotValue?[Assessments2.imageProperty] ?? "") as! String
        self.created = (snapshotValue?[Assessments2.createdProperty] ?? "") as! String
    }
    
    func toAnyObject() -> [String:AnyObject] {
        return [
            Assessments2.nameProperty : name as AnyObject,
            Assessments2.addressProperty : address as AnyObject,
            Assessments2.priceProperty : price as AnyObject,
            Assessments2.timeProperty : time as AnyObject,
            Assessments2.imageProperty : image as AnyObject,
            Assessments2.createdProperty: created as AnyObject
        ]
    }
}
