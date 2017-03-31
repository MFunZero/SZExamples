//
//  SlideDownView.swift
//  SZCardAnimation
//
//  Created by Shuze Pang on 2017/3/31.
//  Copyright © 2017年 suze. All rights reserved.
//

import UIKit
private let screenSize = UIScreen.main.bounds.size

enum SuzeBulbState {
    case on,off
}
enum BuldImgString:String{
    case on="ballon",off="ball"
}



class SlideDownView: UIButton {
    lazy var shapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()
    var strokeColor:UIColor = UIColor.white
    var fillColor:UIColor = UIColor.white
    var originY:CGFloat = 0.0
    
    lazy var imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: BuldImgString.off.rawValue)
        return imgView
    }()
    
    var onState:SuzeBulbState = .off {
        didSet{
            if onState == .off {
                imgView.image = UIImage(named: BuldImgString.off.rawValue)
            }else{
                imgView.image = UIImage(named: BuldImgString.on.rawValue)
            }
        }
    }
    
   override func draw(_ rect: CGRect) {
        config()
    }
    
    func config(){
        imgView.frame = self.bounds
        self.addSubview(imgView)
        
        originY = self.frame.origin.y
        self.superview?.layer.addSublayer(shapeLayer)
        self.superview?.layer.insertSublayer(shapeLayer, at: 0)
        
        shapeLayer.strokeColor = strokeColor.cgColor
//        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.path = getShapeLayerPath().cgPath
       
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        self.addGestureRecognizer(pan)
    }
    
    func pan(pan:UIPanGestureRecognizer){
        let transPoint = pan.translation(in: self)
        
        print("x:\(transPoint.x),y:\(transPoint.y)")
        var center = self.center
        center.y += transPoint.y
        self.center = center
        pan.setTranslation(CGPoint.zero, in: self)
        shapeLayer.path = getShapeLayerPath().cgPath

        if pan.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                var center = self.center
                center.y = self.originY
                self.center = center
                self.shapeLayer.path = self.getShapeLayerPath().cgPath
            }, completion: { (finished) in
                self.onState = .on
            })
        }
    }
    
    func getselfPath()->UIBezierPath {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: self.center.x, y: 0)
        path.move(to: startPoint)
        let lineEndPoint = CGPoint(x: startPoint.x, y: self.frame.origin.y)
        path.addLine(to: lineEndPoint)
       
        return path
    }

    func getShapeLayerPath()->UIBezierPath{
        let path = UIBezierPath()
        let startPoint = CGPoint(x: self.center.x, y: 0)
        path.lineWidth = 10.0
        path.move(to: startPoint)
        let lineEndPoint = CGPoint(x: startPoint.x, y: self.frame.origin.y)
        path.addLine(to: lineEndPoint)
        

        return path
    }
    
    func offBulb(){
        imgView.image = UIImage(named: BuldImgString.off.rawValue)
    }
    
}


