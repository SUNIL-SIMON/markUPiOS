//
//  PLMHighLightMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 20/01/22.
//



import Foundation
import UIKit
import SwiftUI
public class PLMHighLightMarker : PLMShapeTypeMarker{
    let rect = UIView()
    let itemShapeLayer = CAShapeLayer()
    var shapepath = UIBezierPath()
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(rect)
        rect.layer.addSublayer(itemShapeLayer)
//        rect.backgroundColor = .green
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
            itemShapeLayer.path = shapepath.cgPath
            self.transform = t
            if markedInfos.originalDetails.originalLayerPath != ""{
                drawSVGPath(path: markedInfos.originalDetails.originalLayerPath)
                drawCGPOINTPath()
                drawPath()
            }
            else{
                drawCGPOINTPath()
                drawPath()
            }
        }
    }
    public override func setStrokeWidth(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableStrokeWidth = val
        self.drawPath()
    }
    override public func setStrokeColor(val:RGB_O_ColorType)
    {
        var clr = val
        clr.opacity = 0.3
        self.markedInfos.drawableDetails.drawableStrokeColor = clr
//        self.markedInfos.originalDetails.originalStrokeColor = val
        self.drawPath()
        
    }
    override public func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
//        self.markedInfos.originalDetails.originalAngle = val
        let rotateTransform  = CGAffineTransform(rotationAngle: val * CGFloat.pi / 180)
        self.transform = rotateTransform
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
            self.setAngle(val: self.markedInfos.drawableDetails.drawableAngle)
            self.setLock(val: self.markedInfos.isLocked)
//        })
    }
    public func drawPath()
    {
        let t = self.transform
        self.transform = .identity
        itemShapeLayer.path = shapepath.cgPath
        itemShapeLayer.lineWidth = markedInfos.drawableDetails.drawableStrokeWidth
        itemShapeLayer.fillColor = UIColor.clear.cgColor
        itemShapeLayer.strokeColor = getColor(val: markedInfos.drawableDetails.drawableStrokeColor).cgColor
        self.transform = t
    }
    public func drawCGPOINTPath()
    {
        let t = self.transform
        self.transform = .identity
        shapepath.removeAllPoints()
        for i in 0..<markedInfos.drawableDetails.drawableLayerPoints.count
        {
            let ptrX = (markedInfos.drawableDetails.drawableLayerPoints[i].x * rect.frame.size.width)//t.size.width) * s.size.width
            let ptrY = (markedInfos.drawableDetails.drawableLayerPoints[i].y * rect.frame.size.height)///t.size.height) * s.size.height
            if i == 0
            {
                shapepath.move(to: CGPoint(x: ptrX, y: ptrY))
            }
            else{
                shapepath.addLine(to: CGPoint(x: ptrX, y: ptrY))
            }
        }
        self.transform = t
    }
    public func drawSVGPath(path : String)
    {
        let s2 = markedInfos.originalDetails.originalFrameRect
        let s1 = delegate?.getImageSize() ?? .zero
        let imageViewFrame = delegate?.getImageViewFrame().size ?? .zero
        
        let strArr = path.components(separatedBy: " ")
        var convertedStr = ""
        var xcoordinate = true
        for stritem in strArr
        {
            if stritem != ""
            {
                if Double(stritem) == nil
                {
                    convertedStr = "\(convertedStr) \(stritem)"
                }
                else
                {
                    if xcoordinate
                    {
                        xcoordinate = false
                        let c  = (s2.origin.y/s1.width)
                        let b = ((Double(stritem) ?? 1)/s1.width) - c
                        let a = (b * imageViewFrame.width)//-rectFrame.origin.x
                        convertedStr = "\(convertedStr) \(a),"
                    }
                    else{
                        xcoordinate = true
                        let c = (s2.origin.x/s1.height)
                        let b = ((Double(stritem) ?? 1)/s1.height) - c
                        let a = (b * imageViewFrame.height)//-rectFrame.origin.y
                        convertedStr = "\(convertedStr)\(a)"
                    }
                }
            }
        }
//        if markedInfos.drawableDetails.drawableStrokeColor == RGB_O_ColorType(redValue: 255, greenValue: 255, blueValue: 255, opacity: 0.4)
//           shapepath = UIBezierPath(svgPath: convertedStr, radius: (markedInfos.drawableDetails.drawableStrokeWidth/10))
//        }
//        else{
            shapepath = UIBezierPath(svgPath:convertedStr)
        if markedInfos.drawableDetails.drawableLayerPoints.count == 0{
            let wd : CGFloat = s2.size.width
            let ht : CGFloat = s2.size.height
            markedInfos.drawableDetails.drawableLayerPoints = shapepath.applyCommandsGetPoints(from: SVGPath(path), offset: 0, wd : wd, ht: ht, x: s2.origin.y, y : s2.origin.x)
        }
    }

}

