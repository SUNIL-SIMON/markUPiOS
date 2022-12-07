//
//  PLMArrowMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 24/01/22.
//

import Foundation
import UIKit
import SwiftUI
public class PLMArrowMarker : PLMShapeTypeMarker{
    let rect = UIView()
    let itemShapeLayer = CAShapeLayer()
    var shapepath = UIBezierPath()
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
            itemShapeLayer.path = shapepath.cgPath
            self.transform = t

                drawSVGPath()
                drawPath()
        }
    }
    public override func setStrokeWidth(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableStrokeWidth = val
        self.drawPath()
    }
    override public func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
        self.markedInfos.originalDetails.originalStrokeColor = val
        self.drawPath()
        
    }
    override public func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
        self.markedInfos.originalDetails.originalAngle = val
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
            self.setStrokeWidth(val: self.markedInfos.drawableDetails.drawableStrokeWidth)
            self.setStrokeColor(val: self.markedInfos.drawableDetails.drawableStrokeColor)
            self.setAngle(val: self.markedInfos.drawableDetails.drawableAngle)
            self.setLock(val: self.markedInfos.isLocked)
    }
    public func drawPath()
    {
        let t = self.transform
        self.transform = .identity
        itemShapeLayer.path = shapepath.cgPath
        itemShapeLayer.lineWidth = markedInfos.drawableDetails.drawableStrokeWidth
        itemShapeLayer.fillColor = getColor(val: markedInfos.drawableDetails.drawableStrokeColor).cgColor
        itemShapeLayer.strokeColor = getColor(val: markedInfos.drawableDetails.drawableStrokeColor).cgColor
        self.transform = t
    }

    public func drawSVGPath()
    {
        let t = self.transform
        let xrat = rect.frame.size.width/31.6
        let yrat = rect.frame.size.height/(26.9 - 4.6)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 21.2 * xrat, y: (5 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 19.6 * xrat, y: (5 - 4.6) * yrat), controlPoint1: CGPoint(x: 20.8 * xrat, y: (4.6 - 4.6) * yrat), controlPoint2: CGPoint(x: 20.1 * xrat, y: (4.6 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 19.6 * xrat, y: (6.6 - 4.6) * yrat), controlPoint1: CGPoint(x: 19.2 * xrat, y: (5.4 - 4.6) * yrat), controlPoint2: CGPoint(x: 19.2 * xrat, y: (6.1 - 4.6) * yrat))
        path.addLine(to: CGPoint(x: 27.7 * xrat, y: (14.6 - 4.6) * yrat))
        path.addLine(to: CGPoint(x: 1.1 * xrat, y: (14.6 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 0 * xrat, y: (15.7 - 4.6) * yrat), controlPoint1: CGPoint(x: 0.5 * xrat, y: (14.6 - 4.6) * yrat), controlPoint2: CGPoint(x: 0 * xrat, y: (15.1 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 1.1 * xrat, y: (16.9 - 4.6) * yrat), controlPoint1: CGPoint(x: 0 * xrat, y: (16.4 - 4.6) * yrat), controlPoint2: CGPoint(x: 0.5 * xrat, y: (16.9 - 4.6) * yrat))
        path.addLine(to: CGPoint(x: 27.7 * xrat, y: (16.9 - 4.6) * yrat))
        path.addLine(to: CGPoint(x: 19.6 * xrat, y: (24.9 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 19.6 * xrat, y: (26.5 - 4.6) * yrat), controlPoint1: CGPoint(x: 19.2 * xrat, y: (25.3 - 4.6) * yrat), controlPoint2: CGPoint(x: 19.2 * xrat, y: (26.1 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 21.2 * xrat, y: (26.5 - 4.6) * yrat), controlPoint1: CGPoint(x: 20.1 * xrat, y: (26.9 - 4.6) * yrat), controlPoint2: CGPoint(x: 20.8 * xrat, y: (26.9 - 4.6) * yrat))
        path.addLine(to: CGPoint(x: 31.2 * xrat, y: (16.5 - 4.6) * yrat))
        path.addCurve(to: CGPoint(x: 31.2 * xrat, y: (15 - 4.6) * yrat), controlPoint1: CGPoint(x: 31.6 * xrat, y: (16.1 - 4.6) * yrat), controlPoint2: CGPoint(x: 31.6 * xrat, y: (15.4 - 4.6) * yrat))
        path.addLine(to: CGPoint(x: 21.2 * xrat, y: (5 - 4.6) * yrat))
        path.close()
        shapepath =  path
        self.transform = t
    }
}

