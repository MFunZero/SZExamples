//
//  PathBallView.swift
//  SZCardAnimation
//
//  Created by Shuze Pang on 2017/3/31.
//  Copyright © 2017年 suze. All rights reserved.
//

import UIKit

enum PathBallViewType {
    case normal,pull,rebounceDown,rebounceUp,
    refreshingStart,refreshEnd
}

class PathBallView: UIView {
    var mWidth:Int?
    var mHeight:Int?
    var mRect:CGRect?
    
    var circleStartX:CGFloat?
    var circleStartY:CGFloat?
    var radius:CGFloat=24
    var blackMagic:CGFloat=0.5519150224494
    var c:CGFloat?
    var rebounceY:CGFloat?
    var rebounceX:CGFloat?
    var p1:CGPoint?
    var p3:CGPoint?
    var p2:CGPoint?
    var p4:CGPoint?
    
    var mLinePath:CGPath?
    var lineStartY:CGFloat=0
    var lineWidth:CGFloat?
    
    //回弹
    var rebounceInterpolatedTime:CGFloat?
    var rebounceAnimate:CABasicAnimation?
    //
    var pullProgress:CGFloat?
    var PULL_MAX:CGFloat?
    
    var move_distance:CGFloat?
    var isFirstPull:Bool = true;
    var isFirstUp:Bool  = true;
    var moveEnd:Bool  = false;
    var isPullOver:Bool = false;
    var pullOverDistance:CGFloat?
    
    var mPath:CGPath?
//    var mCirclePaint
    var type:PathBallViewType = .normal;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

    
    }
    

}













