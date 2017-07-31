//
//  Assess3TableViewCell.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/30.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit

class Assess3TableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var unreadMessageLabel: UILabel!
    
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        profileImageView?.image = nil
        nameLabel?.text = nil
        timeLabel?.text = nil
        messageLabel?.text = nil
        unreadMessageLabel?.text = nil
        //unreadMessageImageView?.image = nil
        
        if let user = self.user{
            nameLabel?.text = user.name
            messageLabel?.text = user.messages?.last?.text
            
            if let lastMsgTime = user.messages?.last?.time{
                if Calendar.current.isDate(Date(), inSameDayAs:stringToDateConvert(lastMsgTime)){
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    timeLabel?.text = formatter.string(from: stringToDateConvert(lastMsgTime))
                }else if Calendar.current.isDateInYesterday(stringToDateConvert(lastMsgTime)){
                    timeLabel?.text = "Yesterday"
                }else{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yy-MM-dd"
                    timeLabel?.text = formatter.string(from: stringToDateConvert(lastMsgTime))
                }
            }
            
            if let imageStr = user.profileImage, !imageStr.isEmpty{
                let image =  resizeImage(UIImage(named: imageStr), boxSize: (profileImageView?.frame.size), mode: ViewScaleMode.aspectToFill)
                profileImageView?.image = updateUserImageWithBorderColor(image, color: 0, borderWidth: 1.0, alpha: 1.0)
                
                //  if favorite is true, add a green circle, else gray circle
                let circleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
                let circleImage = (user.favorite == true) ? UIImage(named: "green circle.png") : UIImage(named: "gray circle.png")
                circleImageView.image = circleImage
                circleImageView.center = CGPoint(x: profileImageView.frame.width * 0.9,
                                                 y: profileImageView.frame.height * 0.2)
                profileImageView.addSubview(circleImageView)
            }
            
            //  add how many unread messages blue circle
            let unreadMsgCnt = user.messages?.filter({stringToDateConvert($0.time!) > stringToDateConvert((self.user?.lastReadTime)!)}).count
            
            if let cnt = unreadMsgCnt, cnt > 0{
                if cnt > 99{
                    unreadMessageLabel.text = String(cnt) + "+"
                }else{
                    unreadMessageLabel.text = String(cnt)
                }
                
                unreadMessageLabel?.textColor = UIColor.white
                unreadMessageLabel?.layer.cornerRadius = min(unreadMessageLabel.frame.size.width, unreadMessageLabel.frame.size.height) / 2
                unreadMessageLabel?.layer.backgroundColor = UIColor(red: 0.3, green: 0.95, blue: 0.95, alpha: alpha).cgColor
                
                nameLabel?.textColor = UIColor.red
            }
        }
    }
}

func stringToDateConvert(_ str: String) -> Date{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"   //  2017-7-28 14:30
    return formatter.date(from: str)!
}

func updateUserImageWithBorderColor(_ image:UIImage?, color:Int, borderWidth:CGFloat, alpha:CGFloat)->UIImage?{
    if image == nil{
        return nil
    }
    
    let square = image!.size.width < image!.size.height ? CGSize(width: image!.size.width, height: image!.size.width) : CGSize(width: image!.size.height, height: image!.size.height)
    
    let resultImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
    resultImageView.contentMode = UIViewContentMode.scaleAspectFill
    resultImageView.image = image
    resultImageView.layer.cornerRadius = square.width/2
    //resultImageView.layer.borderColor = UIColor.whiteColor().CGColor
    var strokeColor:CGColor
    switch color{
    case 0: strokeColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: alpha).cgColor
    case 1: strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: alpha).cgColor
    case 2: strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: alpha).cgColor
    case 3: strokeColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: alpha).cgColor
    default: strokeColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: alpha).cgColor
    }
    resultImageView.layer.borderColor = strokeColor
    resultImageView.layer.borderWidth = borderWidth
    resultImageView.layer.masksToBounds = true
    
    UIGraphicsBeginImageContext(resultImageView.bounds.size)
    resultImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}
