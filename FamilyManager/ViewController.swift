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
    lazy var breastTimer = FMTimerView(backgroundColor: UIColor.white, timeSet: 60)
    lazy var resetBreast = UIButton()
    lazy var repeatSwitch = UISwitch()
    lazy var repeatLabel = UILabel()
    lazy var poopTimer = FMTimerView(backgroundColor: UIColor.white, timeSet: 60)
    
    let FCHEIGHT: CGFloat = 50
    let FCWIDTH: CGFloat = 200
    let ABUTTONWIDTH: CGFloat = 60

    var familyCount = 0
    
    class Timers{
        init(){
            timer1 = nil
            timer2 = nil
        }
        var timer1: Timer?
        var timer2: Timer?
    }
    
    var breastTimers = Timers()
    var poopTimers = Timers()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(breastTimer)
        breastTimer.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(150)
            make.width.equalTo(150)
            make.top.equalTo(view.snp.topMargin).offset(80)
            make.centerX.equalTo(view.snp.centerX)
        }
        addSwitch()
        breastTimer.progressMax = 60
        addNavBar()
        addToolbar()
        addResetBreast()
        breastTimer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.set)))
        addPoopTimer()
        FMNotificationManager.requestPermissions()
    }
    
    func addPoopTimer(){
        view.addSubview(poopTimer)
        poopTimer.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(150)
            make.width.equalTo(150)
            make.top.equalTo(resetBreast.snp.bottom).offset(8)
            make.centerX.equalTo(view)
        }
        poopTimer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.set)))
    }
    
    func addSwitch(){
        view.addSubview(repeatSwitch)
        repeatSwitch.snp.makeConstraints{ make in
            make.height.equalTo(40)
            make.top.equalTo(breastTimer.snp.bottom).offset(20)
            make.left.equalTo(breastTimer.snp.centerX)
        }
        view.addSubview(repeatLabel)
        repeatLabel.snp.makeConstraints{ make in
            make.height.equalTo(40)
            make.centerY.equalTo(repeatSwitch.snp.centerY)
            make.right.equalTo(repeatSwitch.snp.left).offset(-8)
        }
        repeatLabel.text = "Repeat:"
        
        repeatSwitch.addTarget(self, action: #selector(ViewController.repeatTimer), for: UIControlEvents.valueChanged)
        do{
            repeatSwitch.isOn = try FMDB().getRepeatBreastTimer()
        } catch{
            repeatSwitch.isOn = false
        }
    }
    
    func addResetBreast(){
        view.addSubview(resetBreast)
        resetBreast.snp.makeConstraints{ make in
            make.height.equalTo(20)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(repeatSwitch.snp.bottom).offset(8)
        }
        resetBreast.setTitleColor(UIColor.purple, for: .normal)
        resetBreast.setTitle("Stop Timer", for: .normal)
        resetBreast.addTarget(self, action: #selector(ViewController.reset), for: .touchUpInside)
    }
    
    func reset(){
        resetTimer(timer: breastTimer, timers: breastTimers, shouldRepeat: false)
    }
    
    func repeatTimer(){
        do{
            try FMDB().setRepeatBreastTimer(rep: repeatSwitch.isOn)
        } catch{}
    }
    
    func suspend(){
        let timeLeft = Int64(breastTimer.timer.secondsLeft)
        let suspendTime: Int64 = Int64(NSDate().timeIntervalSince1970)
        resetTimer(timer: breastTimer, timers: breastTimers, timerOn: true)
        breastTimer.timerOn = true
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
        breastTimer.progress = breastTimer.progressMax - CGFloat(updatedTime)
        breastTimer.timer.secondsLeft = Int(updatedTime)
        if breastTimer.timer.secondsLeft == 0{
            resetTimer(timer: breastTimer, timers: breastTimers)
        }
    }
    
    func resume(){
        NotificationCenter.default.removeObserver(self)
        do{
            let (leftOp, suspendOp) = try FMDB().getBreastTimer()
            guard let timeLeft = leftOp, let suspendTime = suspendOp else{
                return
            }
            setTimer(timer: breastTimer, timers: breastTimers)
            resolveTimes(timeLeft: timeLeft, suspendTimestamp: suspendTime)
        } catch{
            return
        }
    }
    
    func set(_ sender: UITapGestureRecognizer){
        if sender.view == breastTimer{
            if !breastTimer.timerOn{
                setAndNotify(timer: breastTimer, timers: breastTimers)
            }
            return
        }
        
        if sender.view == poopTimer{
            if !poopTimer.timerOn{
                setAndNotify(timer: poopTimer, timers: poopTimers)
            }
            return
        }
    }
    
    func setAndNotify(timer: FMTimerView, timers: Timers){
        setTimer(timer: timer, timers: timers)
        FMNotificationManager.scheduleLocalNotification()
    }
    
    func setTimer(timer: FMTimerView, timers: Timers){
        timer.timerOn = true
        timer.progress = 0
        timer.timer.secondsLeft = 25 * 6 * 60
        timer.progressMax = CGFloat(25 * 6 * 60)
        timers.timer1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){tm in
            self.breastTimer.progress = self.breastTimer.progress + 1
            self.breastTimer.setNeedsDisplay()
        }
        timers.timer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){tm in
            self.breastTimer.updateTimer()
            self.breastTimer.setNeedsDisplay()
        }
        if timer == breastTimer{
            NotificationCenter.default.addObserver(self, selector: #selector(self.shouldResetBreastTimer), name: FMNotifications.BreastTimerDone, object: nil)
        } else if timer == poopTimer{
            NotificationCenter.default.addObserver(self, selector: #selector(self.shouldResetPoopTimer), name: FMNotifications.PoopTimerDone, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.suspend), name: FMNotifications.SuspendApp, object: nil)
    }
    
    func shouldResetPoopTimer(){
        resetTimer(timer: poopTimer, timers: poopTimers)
    }
    
    func shouldResetBreastTimer(){
        resetTimer(timer: breastTimer, timers: breastTimers)
    }
    
    func resetTimer(timer: FMTimerView, timers: Timers, timerOn: Bool = false, shouldRepeat: Bool = true){
        if let timer1 = timers.timer1{
            timer1.invalidate()
        }
        if let timer2 = timers.timer2{
            timer2.invalidate()
        }
        timer.timerOn = false
        NotificationCenter.default.removeObserver(self)
        if shouldRepeat{
            if(repeatSwitch.isOn){
                setAndNotify()
            }
        }
    }
    
    func addToolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        view.addSubview(toolbar)
    }
    
    func addNavBar(){
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: 44))
        navigationBar.backgroundColor = UIColor.blue
        let title = UINavigationItem()
        title.title = "Baby Manager"
        navigationBar.items = [title]
        view.addSubview(navigationBar)
    }
}
