//
//  ViewController.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 10/28/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import UIKit
import SnapKit
import FontAwesome_swift

class ViewController: UIViewController {

    lazy var familyCountLabel = UILabel()
    lazy var timer = FMTimerView(backgroundColor: UIColor.white, timeSet: 60)
    
    let FCHEIGHT: CGFloat = 50
    let FCWIDTH: CGFloat = 200
    let ABUTTONWIDTH: CGFloat = 60

    var familyCount = 0
    var timer1: Timer?
    var timer2: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(familyCountLabel)
        familyCountLabel.text = "Family Members: \(getCount())"
        familyCountLabel.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(FCHEIGHT)
            make.width.equalTo(FCWIDTH)
            make.center.equalTo(view)
        }
        view.addSubview(timer)
        timer.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(200)
            make.width.equalTo(200)
            make.center.equalTo(view)
        }
        timer.progressMax = 60
        addNavBar()
        addToolbar()
        timer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.set)))
        
    }
    
    func suspend(){
        let timeLeft = Int64(timer.timer.secondsLeft)
        let suspendTime: Int64 = Int64(NSDate().timeIntervalSince1970)
        resetTimer()
        do{
            try FMDB().updateBreastTimer(timeLeft: timeLeft, suspendTime: suspendTime)
        } catch{}
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.resume), name: FMNotifications.ResumeApp, object: nil)
    }
    
    func resolveTimes(timeLeft: Int64, suspendTimestamp: Int64){
        let currentTimestamp = Int64(NSDate().timeIntervalSince1970)
        let timeElapsed = currentTimestamp - suspendTimestamp
        var updatedTime = timeLeft - timeElapsed
        if updatedTime < 0{
            updatedTime = 0
        }
        timer.progress = timer.progressMax - CGFloat(updatedTime)
        timer.timer.secondsLeft = Int(updatedTime)
    }
    
    func resume(){
        NotificationCenter.default.removeObserver(self)
        do{
            let (leftOp, suspendOp) = try FMDB().getBreastTimer()
            guard let timeLeft = leftOp, let suspendTime = suspendOp else{
                return
            }
            setTimer()
            resolveTimes(timeLeft: timeLeft, suspendTimestamp: suspendTime)
        } catch{
            return
        }
    }
    
    func set(_ sender: UITapGestureRecognizer){
        setTimer()
    }
    
    func setTimer(){
        resetTimer()
        timer.timerOn = true
        timer.progress = 0
        timer.timer.secondsLeft = 25 * 6 * 60
        timer.progressMax = CGFloat(25 * 6 * 60)
        timer1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){tm in
            self.timer.progress = self.timer.progress + 1
            self.timer.setNeedsDisplay()
        }
        timer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){tm in
            self.timer.updateTimer()
            self.timer.setNeedsDisplay()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetTimer), name: FMNotifications.TimerDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.suspend), name: FMNotifications.SuspendApp, object: nil)
    }
    
    func resetTimer(){
        if let timer1 = timer1{
            timer1.invalidate()
        }
        if let timer2 = timer2{
            timer2.invalidate()
        }
        timer.timerOn = false
        NotificationCenter.default.removeObserver(self)
    }
    
    func addToolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        view.addSubview(toolbar)
    }
    
    func addNavBar(){
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: 44))
        navigationBar.backgroundColor = UIColor.blue
        let title = UINavigationItem()
        title.title = "Family Manager"
        let addFamilyMember = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addFamilyMember))
        title.rightBarButtonItem = addFamilyMember
        navigationBar.items = [title]
        view.addSubview(navigationBar)
    }

    func addFamilyMember(){
        showModal()
        updateCount()
        familyCountLabel.text = "Family Members: \(getCount())"
    }
    
    func getCount() -> Int64{
        let db = FMDB()
        do{
            return try db.getFamilyMemberCount()
        } catch{
            print("Get family member count failed")
        }
        return 0
    }
    
    func updateCount(){
        let db = FMDB()
        do{
            try db.updateFamilyMemberCount()
        } catch{
            print("Failed to update family member count")
        }
    }

    func showModal(){
        let vc = FMAddMemberController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
}
