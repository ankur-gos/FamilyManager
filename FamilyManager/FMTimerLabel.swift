//
//  FMTimerLabel.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 11/29/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import UIKit

class FMTimerLabel: UILabel {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var secondsLeft: Int = 60{
        didSet{
            let hours:   Int = secondsLeft / 3600
            let minutes: Int = (secondsLeft % 3600) / 60
            let seconds: Int = secondsLeft % 60
            text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

}
