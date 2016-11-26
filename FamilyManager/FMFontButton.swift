//
// Created by Ankur Goswami on 10/28/16.
// Copyright (c) 2016 SCProjects. All rights reserved.
//

import UIKit
import FontAwesome_swift

class FMFontButton: UIButton {

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    init(fsize: CGFloat, iname: String){
        super.init(frame: CGRect())
        titleLabel?.font = UIFont.fontAwesome(ofSize: fsize)
        setTitle(String.fontAwesomeIcon(code: iname), for: .normal)
    }
}
