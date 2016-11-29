//
//  FMTimerLabel.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 11/29/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import UIKit

class FMTimerLabel: UILabel {
    var secondsLeft: Int = 60{
        didSet{
            let minutes: Int = secondsLeft / 60
            let seconds: Int = secondsLeft % 60
            text = String(format: "%02d:%02d", minutes, seconds)
        }
    }

}
