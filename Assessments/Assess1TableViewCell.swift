//
//  Assess1TableViewCell.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/25.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit

class Assess1TableViewCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    
    var player: Player? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        flagImage?.image = nil
        name?.text = nil
        age?.text = nil
        
        if let player = self.player{
            name?.text = player.name
            age?.text = (player.age == 1) ? String(player.age) + " year old" : String(player.age) + " years old"
            switch player.country{
            case Country.Australia.rawValue:
                flagImage?.image = resizeImage(UIImage(named: "australia.png"), boxSize: (flagImage?.frame.size), mode: ViewScaleMode.aspectToFit)
            case Country.USA.rawValue:
                flagImage?.image = resizeImage(UIImage(named: "usa.png"), boxSize: (flagImage?.frame.size), mode: ViewScaleMode.aspectToFit)
            case Country.Spain.rawValue:
                flagImage?.image = resizeImage(UIImage(named: "spain.png"), boxSize: (flagImage?.frame.size), mode: ViewScaleMode.aspectToFit)
            case Country.France.rawValue:
                flagImage?.image = resizeImage(UIImage(named: "france.png"), boxSize: (flagImage?.frame.size), mode: ViewScaleMode.aspectToFit)
            case Country.Germany.rawValue:
                flagImage?.image = resizeImage(UIImage(named: "germany.png"), boxSize: (flagImage?.frame.size), mode: ViewScaleMode.aspectToFit)
            default:
                break
            }
        }
    }
}
