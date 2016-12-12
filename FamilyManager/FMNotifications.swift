//
//  FMNotifications.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 11/29/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import Foundation

struct FMNotifications{
    static var BreastTimerDone: Notification.Name{
        get{
            return Notification.Name(rawValue: "BreastTimerDone")
        }
    }
    
    static var PoopTimerDone: Notification.Name{
        get{
            return Notification.Name(rawValue: "PoopTimerDone")
        }
    }
    
    static var SuspendApp: Notification.Name{
        get{
            return Notification.Name(rawValue: "SuspendApp")
        }
    }
    
    static var ResumeApp: Notification.Name{
        get{
            return Notification.Name(rawValue: "ResumeApp")
        }
    }
}
