//
//  Assess2TableViewCell.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/28.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit

class Assess2TableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var event: Event? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        eventImageView?.image = nil
        nameLabel?.text = nil
        priceLabel?.text = nil
        addressLabel?.text = nil
        dateLabel?.text = nil
        
        if let event = self.event{
            nameLabel?.text = event.name
            priceLabel?.text = "$ " + String(event.price)
            addressLabel?.text = event.address
            dateLabel?.text = event.time
            
            if !event.image.isEmpty{
                let image =  resizeImage(UIImage(data: Data(base64Encoded: (event.image), options: .ignoreUnknownCharacters)!)!, boxSize: (eventImageView?.frame.size), mode: ViewScaleMode.aspectToFit)
                eventImageView?.image = image
            }
        }
    }
}

enum ViewScaleMode{
    case originalSize
    case scaleToFill
    case aspectToFit
    case aspectToFill
}

func resizeImage(_ image: UIImage?, boxSize: CGSize?, mode: ViewScaleMode) -> UIImage? {
    if image == nil || boxSize == nil{
        return nil
    }else{
        if mode == .originalSize{
            return image
        }
        var newWidth = boxSize!.width
        var newHeight = boxSize!.height
        let widthScale = image!.size.width / boxSize!.width
        let heightScale = image!.size.height / boxSize!.height
        var scale:CGFloat
        if mode == .scaleToFill{}
        else if mode == .aspectToFit{
            scale = (widthScale > heightScale ? widthScale: heightScale)
            newWidth = image!.size.width / scale
            newHeight = image!.size.height / scale
        }else if mode == .aspectToFill{
            scale = (widthScale < heightScale ? widthScale: heightScale)
            newWidth = image!.size.width / scale
            newHeight = image!.size.height / scale
        }else{
            return image
        }
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image!.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
