//
//  SZButton.swift
//  SZCardAnimation
//
//  Created by Shuze Pang on 2017/3/31.
//  Copyright © 2017年 suze. All rights reserved.
//

import UIKit

class SZView: UIView {
    lazy var smalCirView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    var MaxDistance:CGFloat = 90.0
    var smallCircleR:CGFloat = 0.0
    
    lazy var shapeLayer:CAShapeLayer? = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.brown.cgColor
        return layer
    }()
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.size.width * 0.5;
        self.layer.masksToBounds = true
        self.setUp()

    }
    
    override func awakeFromNib() {
        self.setUp();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.smallCircleR = self.frame.size.width * 0.5
        self.smalCirView.bounds = self.bounds
        self.smalCirView.center = self.center
        self.smalCirView.layer.cornerRadius = self.smalCirView.frame.size.width * 0.5

    }
    
    func setUp(){

//        smallCircleR = self.frame.size.width * 0.5;
//        self.smalCirView.bounds = self.bounds;
//        self.smalCirView.center = self.center;
//        self.smalCirView.layer.cornerRadius = self.smalCirView.frame.size.width * 0.5
        shapeLayer?.path = self.getBezierPathWithSmallCir(bigCir: &smalCirView).cgPath
        self.superview?.addSubview(smalCirView)
        self.superview?.insertSubview(smalCirView, belowSubview: self)
        self.superview?.layer.addSublayer(shapeLayer!)
        
        self.superview?.layer.insertSublayer(shapeLayer!, at: 0)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(pant:)))
        self.addGestureRecognizer(pan)
        
    }
    
    //MARK:---移动手势
    func pan(gesture:UIPanGestureRecognizer) {
        let point = gesture.location(in: self)
        var center = self.center;
        center.x += point.x
        center.y += point.y
        self.center = center
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    
    //MARK:--移动时小圆大小发生变化
    /*
    func pan(pan:UIPanGestureRecognizer) {
        let transPoint = pan.translation(in: self)
        var center = self.center
        center.x += transPoint.x
        center.y += transPoint.y
        self.center = center
        pan.setTranslation(CGPoint.zero, in: self)
        
        //设置小圆变化
        var cirDistance = self.distance(pointA: self.center, pointB: self.smalCirView.center)
        var smallCirRadius = oriRadius - cirDistance/10.0
        if smallCirRadius < 0 {
            smallCirRadius = 0
        }
        smalCirView.bounds = CGRect(x: 0, y: 0, width: smallCirRadius*2, height: smallCirRadius*2)
        self.smalCirView.layer.cornerRadius = smallCirRadius
    }
    */
    func pan(pant:UIPanGestureRecognizer){
        let transPoint = pant.translation(in: self)
        var center = self.center
        center.x += transPoint.x
        center.y += transPoint.y
        self.center = center
        pant.setTranslation(CGPoint.zero, in: self)
        
        //设置小圆变化
        let cirDistance = self.distance(pointA: self.smalCirView.center, pointB: self.center)
        if cirDistance == 0 {
            return
        }
        let smallCirRadius = smallCircleR - cirDistance/15.0
        smalCirView.bounds = CGRect(x: 0, y: 0, width: smallCirRadius*2, height: smallCirRadius*2)
        smalCirView.layer.cornerRadius = smallCirRadius
        //画图
        
        if cirDistance > MaxDistance || smallCircleR <= 0{
            self.smalCirView.isHidden = true
            self.shapeLayer?.removeFromSuperlayer()
            self.shapeLayer = nil
        }
        if cirDistance <= MaxDistance && !self.smalCirView.isHidden {
            self.shapeLayer?.path = self.getBezierPathWithSmallCir(bigCir:&self.smalCirView).cgPath
        }
        
        //爆炸或者还原
        switch pant.state {
        case .began:
            print("self.frame:\(self.frame)")
            break
        case .ended:
            if cirDistance <= MaxDistance{
                self.shapeLayer?.removeFromSuperlayer()
                self.shapeLayer = nil
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.center=self.smalCirView.center
                }, completion: { (finished) in
                    self.smalCirView.isHidden = false
                })
            }else {
                let imageView = UIImageView(frame:self.bounds)
                var imageArr:[UIImage] = []
                for _ in 1..<9 {
                    let image = UIImage(named:"suite")
                    imageArr.append(image!)
                }
                imageView.animationImages = imageArr
                imageView.animationDuration = 0.5
                imageView.animationRepeatCount = 1
                imageView.stopAnimating()
                self.addSubview(imageView)
                let time = DispatchTime(uptimeNanoseconds: UInt64(0.4) * NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.removeFromSuperview()
                })
            }
            break
        default :
            break
        }
    }
    
    
    func distance(pointA:CGPoint,pointB:CGPoint)->CGFloat {
        let offsetX = pointA.x-pointB.x;
        let offsetY = pointA.y-pointB.y;
        return sqrt(offsetX*offsetX + offsetY*offsetY)
    }

    func getBezierPathWithSmallCir(bigCir:inout UIView)->UIBezierPath{
        let smallCir = self as UIView
//        if bigCir.frame.size.width < smallCir.frame.size.width {
//            let view = bigCir
//            bigCir = smallCir
//            smallCir = view
//        }
        
        let d = self.distance(pointA: bigCir.center, pointB: smallCir.center)
        let x1 = smallCir.center.x
        let y1 = smallCir.center.y
        let r1 = smallCir.bounds.size.width/2
        
        let x2 = bigCir.center.x
        let y2 = bigCir.center.y
        let r2 = bigCir.bounds.size.width/2
        
        let sinA = (y2-y1)/d
        let cosA = (x2-x1)/d
        
        let pointA = CGPoint(x: x1-cosA*r1, y: y1+sinA*r1)
        let pointB = CGPoint(x: x1+cosA*r1, y: y1-sinA*r1)
        let pointC = CGPoint(x: x2+cosA*r2, y: y2-sinA*r2)
        let pointD = CGPoint(x: x2-cosA*r2, y: y2+sinA*r2)
        
        //获取控制点，绘制曲线
        let pointControllO = CGPoint(x: pointA.x+d/2*sinA, y: pointA.y+d/2*cosA)
        let pointControllP = CGPoint(x: pointB.x+d/2*sinA, y: pointB.y+d/2*cosA)
        
        let path = UIBezierPath()
        path.move(to: pointD)
        path.addQuadCurve(to: pointA, controlPoint: pointControllO)
        path.addLine(to: pointB)
        path.addQuadCurve(to: pointC, controlPoint: pointControllP)
        path.addLine(to: pointD)
        return path
    }
    
}


















