//
// Created by Ankur Goswami on 10/28/16.
// Copyright (c) 2016 SCProjects. All rights reserved.
//

import UIKit
import SnapKit

class FMAddMemberController: UIViewController {

    let container = UIView()
    let nameField = UITextField()
    let addButton = FMFontButton(fsize: 12, iname: "fa-plus")

    let ADDWIDTHHEIGHT: CGFloat = 25
    let ADDTOP: CGFloat = 5
    let CONTAINERWIDTH: CGFloat = 200
    let CONTAINERHEIGHT: CGFloat = 100
    let NAMEFIELDTOP: CGFloat = 5
    let NAMEFIELDLEFT: CGFloat = 5
    let NAMEFIELDRIGHT: CGFloat = -5
    let NAMEFIELDHEIGHT: CGFloat = 25
    let VIEWSHIFT: CGFloat = 50


    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isOpaque = false

        view.addSubview(container)
        container.backgroundColor = .white
        container.layer.cornerRadius = 4
        container.snp.makeConstraints{ (make) -> Void in
            make.center.equalTo(view)
            make.width.equalTo(CONTAINERWIDTH)
            make.height.equalTo(CONTAINERHEIGHT)

        }

        container.addSubview(nameField)
        nameField.borderStyle = .none
        nameField.placeholder = "  Member Name"
        nameField.layer.cornerRadius = 4
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        nameField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(container).offset(NAMEFIELDTOP)
            make.left.equalTo(container).offset(NAMEFIELDLEFT)
            make.right.equalTo(container).offset(NAMEFIELDRIGHT)
            make.height.equalTo(NAMEFIELDHEIGHT)
        }

        container.addSubview(addButton)
        addButton.backgroundColor = .blue
        addButton.layer.cornerRadius = ADDWIDTHHEIGHT / 2
        addButton.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(nameField.snp.bottom).offset(ADDTOP)
            make.width.height.equalTo(ADDWIDTHHEIGHT)
            make.centerX.equalTo(nameField)
        }
        addButton.addTarget(self, action: #selector(addMember), for: .touchUpInside)
      
        NotificationCenter.default.addObserver(self, selector: #selector(FMAddMemberController.shiftUp), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(FMAddMemberController.shiftDown), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func shiftUp(){
        view.frame = view.frame.offsetBy(dx: 0, dy: -VIEWSHIFT)
    }
    
    func shiftDown(){
        view.frame = view.frame.offsetBy(dx: 0, dy: VIEWSHIFT)
    }

    func addMember(){
        dismiss(animated: false)
    }
}
