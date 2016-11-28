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
    lazy var timer = FMTimerView(backgroundColor: UIColor.white)
    
    let FCHEIGHT: CGFloat = 50
    let FCWIDTH: CGFloat = 200
    let ABUTTONWIDTH: CGFloat = 60

    var familyCount = 0

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
        timer.progressMax = 10
        addNavBar()
        addToolbar()
        Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true){tm in
            self.timer.progress = self.timer.progress + 0.005
            self.timer.setNeedsDisplay()
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
