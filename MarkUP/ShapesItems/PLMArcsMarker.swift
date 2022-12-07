//
//  PLMArcsMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 14/03/22.
//

import Foundation
import UIKit
import SwiftUI
import AppearanceFramework
public class PLMArcsMarker : PLMShapeTypeMarker{
    let rect = UIView()
    let itemShapeLayer = CAShapeLayer()
    var shapepath = UIBezierPath()
    var s2 = CGRect.zero
    var s1 = CGSize.zero
    var imageViewFrame = CGSize.zero
    var constantStrokeWidth : CGFloat = 3
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(rect)
        rect.layer.addSublayer(itemShapeLayer)
        itemShapeLayer.path = shapepath.cgPath
        self.setUpHolders()
        markedInfos = markedInfosParam
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
            let t = self.transform
            self.transform = .identity
            rect.frame = CGRect(x: halfSize, y: halfSize, width: self.frame.width-size, height: self.frame.height-size)
            itemShapeLayer.frame = CGRect(x: 0, y: 0, width: rect.frame.size.width, height: rect.frame.size.height)
            shapepath.removeAllPoints()
            itemShapeLayer.path = shapepath.cgPath
            self.transform = t
            drawCGPOINTPath()
            drawPath()
        }
    }
    public override func setStrokeWidth(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableStrokeWidth = val
        drawCGPOINTPath()
        self.drawPath()
        
    }
    override public func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
        self.markedInfos.originalDetails.originalStrokeColor = val
        drawCGPOINTPath()
        self.drawPath()
        
    }
    override public func setFillColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableFillColor = val
        self.markedInfos.originalDetails.originalFillColor = val
        drawCGPOINTPath()
        self.drawPath()
        
    }
    override public func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
        self.markedInfos.originalDetails.originalAngle = val
        let rotateTransform  = CGAffineTransform(rotationAngle: val * CGFloat.pi / 180)
        self.transform = rotateTransform
        drawCGPOINTPath()
        self.drawPath()
        
    }
    public override func setLock(val:Bool)
    {
        self.markedInfos.isLocked = val
        lockImage.alpha = self.markedInfos.isLocked ? 1 : 0
    }
    override public func resetAllProperties()
    {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            self.setStrokeWidth(val: self.markedInfos.drawableDetails.drawableStrokeWidth)
            self.setStrokeColor(val: self.markedInfos.drawableDetails.drawableStrokeColor)
            self.setFillColor(val: self.markedInfos.drawableDetails.drawableFillColor)
            self.setAngle(val: self.markedInfos.drawableDetails.drawableAngle)
            self.setLock(val: self.markedInfos.isLocked)
//        })
    }
    public func drawPath()
    {
        let t = self.transform
        self.transform = .identity
        itemShapeLayer.path = shapepath.cgPath
        itemShapeLayer.lineWidth = self.markedInfos.drawableDetails.drawableStrokeWidth//constantStrokeWidth
        itemShapeLayer.fillColor = getColor(val: markedInfos.drawableDetails.drawableFillColor).cgColor
        itemShapeLayer.strokeColor = getColor(val: markedInfos.drawableDetails.drawableStrokeColor).cgColor
        self.transform = t
    }
    public func drawCGPOINTPath()
    {
        let t = self.transform
        self.transform = .identity
        let diam : CGFloat = self.markedInfos.drawableDetails.drawableStrokeWidth * 3
        constantStrokeWidth = self.markedInfos.drawableDetails.drawableStrokeWidth
        let rad : CGFloat = diam/2
        let hdist = rect.frame.size.width - diam - constantStrokeWidth
        let hcount = (Int(hdist/diam))
        let hbal = (hdist - (CGFloat((Int(hdist/diam))) * diam))/2
        let vdist = rect.frame.size.height - diam - constantStrokeWidth
        let vcount = (Int(vdist/diam))
        let vbal = (vdist - (CGFloat((Int(vdist/diam))) * diam))/2
        shapepath.removeAllPoints()
        shapepath.move(to: CGPoint(x: rad + (constantStrokeWidth/2) + hbal, y: rad + (constantStrokeWidth/2)))
        if hcount != 0 && vcount != 0{
            northArc(diam: diam, rad: rad, count: hcount, gap : hbal)
            eastArc(diam: diam, rad: rad, count: vcount, gap : vbal)
            southArc(diam: diam, rad: rad, count: hcount, gap : hbal)
            westArc(diam: diam, rad: rad, count: vcount, gap : vbal)
        }
        else{
            shapepath = UIBezierPath(ovalIn: CGRect(x: markedInfos.drawableDetails.drawableStrokeWidth/2, y: markedInfos.drawableDetails.drawableStrokeWidth/2, width: self.frame.width-size-markedInfos.drawableDetails.drawableStrokeWidth, height: self.frame.height-size-markedInfos.drawableDetails.drawableStrokeWidth))
        }
        
        shapepath.close()
        self.transform = t
    }
    public func northArc(diam : CGFloat,rad : CGFloat, count : Int, gap : CGFloat)
    {
        if count > 0{
            for i in 0..<count{
                shapepath.addArc(withCenter: CGPoint(x : (constantStrokeWidth/2) + gap + rad + (diam * CGFloat(i)) + rad,y:rad + (constantStrokeWidth/2)), radius: rad , startAngle:  CGFloat.pi, endAngle: 0, clockwise: true)
            }
        }
    }
    public func southArc(diam : CGFloat,rad : CGFloat, count : Int, gap : CGFloat)
    {
        if count > 0{
        for i in 0..<count{
            shapepath.addArc(withCenter: CGPoint(x : (constantStrokeWidth/2) + gap + rad + (diam * CGFloat(count - i)) - (rad),y:rect.frame.size.height - rad - (constantStrokeWidth/2)), radius: rad , startAngle:  0, endAngle: CGFloat.pi, clockwise: true)
        }
        }
    }
    public func westArc(diam : CGFloat,rad : CGFloat, count : Int, gap : CGFloat)
    {
        if count > 0{
        for i in 0..<count{
            shapepath.addArc(withCenter: CGPoint(x : rad + (constantStrokeWidth/2),y: (constantStrokeWidth/2) + gap + rad + (diam * CGFloat(count - i)) - (rad)), radius: rad , startAngle:  DEGREES_TO_RADIANS(90), endAngle: DEGREES_TO_RADIANS(270), clockwise: true)
        }
        }
    }
    public func eastArc(diam : CGFloat,rad : CGFloat, count : Int, gap : CGFloat)
    {
        if count > 0{
        for i in 0..<count{
            shapepath.addArc(withCenter: CGPoint(x : rect.frame.size.width - rad - (constantStrokeWidth/2),y: (constantStrokeWidth/2) + gap + rad + (diam * CGFloat(i)) + (rad)), radius: rad , startAngle:  DEGREES_TO_RADIANS(270), endAngle: DEGREES_TO_RADIANS(90), clockwise: true)
        }
        }
    }
}
extension UIView {

    func rotate(angle: CGFloat) {
//        let radians = angle / 180.0 * CGFloat.pi
//        let rotation = self.transform.rotated(by: radians)
        var rads = DEGREES_TO_RADIANS(angle)
        self.transform = CGAffineTransform(rotationAngle: rads)//rotation
        
//        let degrees : Double = -angle; //the value in degrees
//        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    func DEGREES_TO_RADIANS(_ degrees: Double) -> Double {
        (.pi * degrees) / 180
    }
}
