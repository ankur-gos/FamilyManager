//
//  FMNotifications.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 11/29/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import Foundation

struct FMNotifications{
    static var TimerDone: Notification.Name{
        get{
            return Notification.Name(rawValue: "TimerDone")
        }
    }
}
