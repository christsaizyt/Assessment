//
//  Messages.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/30.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import Foundation

class Message{
    // MARK - properties
    var fromUser:String?
    var toUser:String?
    
    var time:String?
    var text:String?
    
    init(fromUser: String?, toUser: String?, time: String?, text: String?) {
        self.fromUser = fromUser
        self.toUser = toUser
        self.time = time
        self.text = text
    }
}
