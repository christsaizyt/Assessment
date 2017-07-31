//
//  Player.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/25.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

/*
Model: can be moved to Assessment1ViewController, but I prefer separate model and vc
*/

import Foundation
import RealmSwift

enum Country: Int{
    case France
    case Germany
    case USA
    case Spain
    case Australia
}

class Player: Object{
    dynamic var name: String = ""
    dynamic var country: Int = 0
    dynamic var height: Int = 72 //  inches
    dynamic var weight: Int = 150 //  lbs.
    dynamic var age: Int = 21
    dynamic var created: NSDate = NSDate()
    
    convenience init(name: String, country: Int, height: Int, weight: Int, age: Int) {
        self.init()
        self.name = name
        self.country = country
        self.height = height
        self.weight = weight
        self.age = age
    }
}
