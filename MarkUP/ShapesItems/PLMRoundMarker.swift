//
//  PLMRoundMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 18/01/22.
//

import UIKit
public class PLMRoundMarker : PLMShapeTypeMarker{
    let round = UIView()
    let oval = CAShapeLayer()
    let measurmentLabel = UIButton()
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(round)
        round.layer.addSublayer(oval)
        self.setUpHolders()
        self.addSubview(measurmentLabel)
        measurmentLabel.setTitle("", for: .normal)
        measurmentLabel.setTitleColor(.black, for: .normal)
        measurmentLabel.titleLabel?.adjustsFontSizeToFitWidth = true
        measurmentLabel.titleLabel?.textAlignment = .center
        measurmentLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        measurmentLabel.isUserInteractionEnabled = false
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
            round.frame = CGRect(x: halfSize, y: halfSize, width: self.frame.width-size, height: self.frame.height-size)
            setAreaText()
            self.transform = t
            drawOval()
        }
    }
    public override func setAreaText()
    {
        let p = delegate?.getImageSize() ?? .zero
        let s = delegate?.getSheetScale() ?? .zero
        measurmentLabel.alpha = markedInfos.measurmnetsVisible.areaShown ? 1 : 0
        let dist = CGFloat.pi * (((self.markedInfos.originalDetails.originalFrameRect.width/p.width) * s.width)/2) * (((self.markedInfos.originalDetails.originalFrameRect.height/p.height) * s.height)/2)
        measurmentLabel.setTitle(getMeasurmntext(val: "\(dist)"), for: .normal)
        measurmentLabel.sizeToFit()
        measurmentLabel.center = round.center
    }
    func getMeasurmntext(val:String)->String
    {
        let lenString = "\(val)"
        let index1 = lenString.index(lenString.startIndex, offsetBy: (lenString.count > 6 ? 6 : lenString.count))
        let trucatedStr = lenString.substring(to: index1)
        if delegate?.getSheetScaleUnit() == PLMPresenter.shared.sheetDataSource.sizes[0]
        {
            let a = trucatedStr.components(separatedBy: ".")
            var str = ""
            if a.count > 0
            {
                str = "\(a[0])'"
            }
            if a.count > 1 && a[1].count > 1
            {
                let index2 = a[1].index(a[1].startIndex, offsetBy: (a[1].count > 2 ? 2 : a.count))
                let trucatedStr2 = a[1].substring(to: index2)
                let feetmsr : Int = Int(((CGFloat(Int(trucatedStr2) ?? 0))/100) * 12)
                str = "\(str) \(feetmsr)''"
            }
            return str
        }
        else{
            return trucatedStr
        }
    }
    public func drawOval()
    {
        let t = self.transform
        self.transform = .identity
        oval.path = UIBezierPath(ovalIn: CGRect(x: markedInfos.drawableDetails.drawableStrokeWidth/2, y: markedInfos.drawableDetails.drawableStrokeWidth/2, width: self.frame.width-size-markedInfos.drawableDetails.drawableStrokeWidth, height: self.frame.height-size-markedInfos.drawableDetails.drawableStrokeWidth)).cgPath
        oval.strokeColor = getColor(val:  markedInfos.drawableDetails.drawableStrokeColor).cgColor
        oval.fillColor = getColor(val: markedInfos.drawableDetails.drawableFillColor).cgColor
        oval.lineWidth = markedInfos.drawableDetails.drawableStrokeWidth
        self.transform = t
    }
    public override func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
        self.markedInfos.originalDetails.originalAngle = val
        let rotateTransform  = CGAffineTransform(rotationAngle: val * CGFloat.pi / 180)
        self.transform = rotateTransform
        drawOval()
        
    }
    public override func setStrokeWidth(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableStrokeWidth = val
        drawOval()
        
    }
    public override func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
        self.markedInfos.originalDetails.originalStrokeColor = val
        drawOval()
        
    }
    public override func setFillColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableFillColor = val
        self.markedInfos.originalDetails.originalFillColor = val
        drawOval()
        
    }
    public override func setLock(val:Bool)
    {
        self.markedInfos.isLocked = val
        lockImage.alpha = self.markedInfos.isLocked ? 1 : 0
    }
    public override func resetAllProperties()
    {
            self.setStrokeWidth(val: self.markedInfos.drawableDetails.drawableStrokeWidth)
            self.setStrokeColor(val: self.markedInfos.drawableDetails.drawableStrokeColor)
            self.setFillColor(val: self.markedInfos.drawableDetails.drawableFillColor)
            self.setAngle(val: self.markedInfos.drawableDetails.drawableAngle)
            self.setLock(val: self.markedInfos.isLocked)
    }
}
