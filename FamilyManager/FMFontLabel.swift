//
// Created by Ankur Goswami on 10/28/16.
// Copyright (c) 2016 SCProjects. All rights reserved.
//

import UIKit
import FontAwesome_swift

class FMFontLabel: UILabel {
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    init(fsize: CGFloat, iname: String){
        super.init(frame: CGRect())
        font = UIFont.fontAwesome(ofSize: fsize)
        text = String.fontAwesomeIcon(code: iname)
    }
}
