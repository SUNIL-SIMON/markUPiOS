//
//  PLMRectMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 18/01/22.
//

import UIKit
public class PLMRectMarker : PLMShapeTypeMarker{
    let rect = UIView()
    let areaLabel = UIButton()
    let lengthLabel = UIButton()
    let breadthLabel = UIButton()
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(rect)
        self.setUpHolders()
        self.addLabel(label: areaLabel)
        self.addLabel(label: lengthLabel)
        self.addLabel(label: breadthLabel)
        
        markedInfos = markedInfosParam
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addLabel(label : UIButton)
    {
        self.addSubview(label)
        label.setTitle("", for: .normal)
        label.setTitleColor(.black, for: .normal)
        label.titleLabel?.adjustsFontSizeToFitWidth = true
        label.titleLabel?.textAlignment = .center
        label.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.isUserInteractionEnabled = false
    }
    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
            let t = self.transform
            self.transform = .identity
            print("[rotation operation] rect trying to set frame 1")
            self.rect.frame = CGRect(x: self.halfSize, y: self.halfSize, width: self.frame.width-self.size, height: self.frame.height-self.size)
            setAreaText()
            self.transform = t
        }
    }
    public override func setAreaText()
    {
        let p = delegate?.getImageSize() ?? .zero
        let s = delegate?.getSheetScale() ?? .zero
        let dist = ((self.markedInfos.originalDetails.originalFrameRect.width/p.width) * s.width) * ((self.markedInfos.originalDetails.originalFrameRect.height/p.height) * s.height)

        areaLabel.alpha = markedInfos.measurmnetsVisible.areaShown ? 1 : 0
        areaLabel.setTitle(getMeasurmntext(val: dist), for: .normal)
        areaLabel.sizeToFit()
        areaLabel.center = rect.center
        let l = ((self.markedInfos.originalDetails.originalFrameRect.width/p.width) * s.width)
        lengthLabel.alpha = markedInfos.measurmnetsVisible.lengthShown ? 1 : 0
        lengthLabel.setTitle(getMeasurmntext(val: l), for: .normal)
        lengthLabel.sizeToFit()
        lengthLabel.frame.origin = CGPoint(x: rect.frame.size.width - lengthLabel.frame.size.width, y: 0)

        breadthLabel.alpha = markedInfos.measurmnetsVisible.breadthShown ? 1 : 0
        let b = ((self.markedInfos.originalDetails.originalFrameRect.height/p.height) * s.height)
        
        breadthLabel.setTitle(getMeasurmntext(val: b), for: .normal)

        breadthLabel.sizeToFit()
        breadthLabel.frame.origin = CGPoint(x: 0, y: rect.frame.size.height - breadthLabel.frame.size.height)
    }

    public override func setStrokeWidth(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableStrokeWidth = val
        rect.layer.borderWidth = val
        
    }
    public override func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
        self.markedInfos.originalDetails.originalStrokeColor = val
        rect.layer.borderColor = getColor(val: val).cgColor
        
    }
    public override func setFillColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableFillColor = val
        self.markedInfos.originalDetails.originalFillColor = val
        rect.backgroundColor = getColor(val:val)
        
    }
    public override func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
        self.markedInfos.originalDetails.originalAngle = val
        let rotateTransform  = CGAffineTransform(rotationAngle: val * CGFloat.pi / 180)
        self.transform = rotateTransform
        
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
