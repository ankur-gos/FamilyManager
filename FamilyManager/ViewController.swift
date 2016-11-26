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
    lazy var addMemberButton = FMFontButton(fsize: 20, iname: "fa-plus")

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
        view.addSubview(addMemberButton)
        addMemberButton.backgroundColor = .blue
        addMemberButton.layer.cornerRadius = ABUTTONWIDTH / 2
        addMemberButton.snp.makeConstraints{ (make) -> Void in
            make.height.width.equalTo(ABUTTONWIDTH)
            make.top.equalTo(familyCountLabel.snp.bottom).offset(10)
            make.centerX.equalTo(familyCountLabel)
        }
        addMemberButton.addTarget(self, action: #selector(self.addFamilyMember), for: .touchUpInside)
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
