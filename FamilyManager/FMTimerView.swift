//
//  FMTimerView.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 11/27/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import UIKit
import SnapKit

protocol FMDrawTimer{
    func drawProgress(context: CGContext, boundedBy rect: CGRect, progress: CGFloat)
}

class FMTimerView: UIView{
    
    var progress: CGFloat = 0
    var progressMax: CGFloat = 100
    var timer = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timer)
        timer.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(40)
            make.center.equalTo(self)
        }
        timer.text = "06:12"
    }
    
    convenience init(backgroundColor: UIColor){
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = backgroundColor
    }
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext(){
            drawProgress(context: context, boundedBy: rect, progress: progress)
        }
        super.draw(rect)
    }
    
    func drawProgress(context: CGContext, boundedBy rect: CGRect, progress: CGFloat) {
        context.setFillColor(UIColor.red.cgColor)
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: rect.width / 3, startAngle: 3 * .pi / 2, endAngle: ((progress * 360 / progressMax) * .pi / 180) - (.pi / 2), clockwise: true).cgPath
        let stroked = path.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .miter, miterLimit: 10)
        context.addPath(stroked)
        context.setStrokeColor(UIColor.red.cgColor)
        context.drawPath(using: .fillStroke)
        
    }
}
