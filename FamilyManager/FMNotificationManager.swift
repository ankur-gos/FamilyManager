//
//  FMNotificationManager.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 12/9/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import Foundation
import UserNotifications

struct FMNotificationManager{
    init() {
        
    }
    
    static var permissionGranted = false
    
    static func requestPermissions(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
            if !granted{
                // TODO define this behavior
                return
            }
            if let error = error{
                // TODO error handling
            }
            FMNotificationManager.permissionGranted = true
        }
    }
    
    static func scheduleLocalNotification(){
        if !permissionGranted{
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Timer", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Time to breastfeed!", arguments: nil)
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 9000, repeats: true)
        let request = UNNotificationRequest(identifier: "Breastfeed", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    static func unscheduleLocalNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
