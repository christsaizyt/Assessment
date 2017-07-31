//
//  MessageCell.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/30.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import Foundation

class User{
    // MARK - properties
    var name: String?
    var profileImage: String?
    //var profileImageStr: String = ""
    var messages: [Message]?
    var lastReadTime: String?
    var favorite: Bool?
    
    init(name: String?, profileImage: String?, messages: [Message]?, lastReadTime: String?, favorite: Bool?) {
        self.name = name
        self.profileImage = profileImage
        self.messages = messages
        self.lastReadTime = lastReadTime
        self.favorite = favorite
    }
}
