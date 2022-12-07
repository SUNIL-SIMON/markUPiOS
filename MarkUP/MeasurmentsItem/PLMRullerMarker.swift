//
//  PLMRullerMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 23/01/22.
//

import Foundation

import UIKit
public class PLMRullerMarker : PLMShapeTypeMarker{
    let rect = UIView()
    let measurmentLabel = UIButton()
    let itemShapeLayer = CAShapeLayer()
    let linePath = UIBezierPath()
    var dist1 : CGFloat = .zero
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(rect)
        self.layer.addSublayer(itemShapeLayer)
        self.addSubview(measurmentLabel)
        measurmentLabel.setTitle("", for: .normal)
        measurmentLabel.setTitleColor(.black, for: .normal)
        measurmentLabel.titleLabel?.adjustsFontSizeToFitWidth = true
        measurmentLabel.titleLabel?.textAlignment = .center
        measurmentLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        measurmentLabel.addTarget(self, action: #selector(selectedRullerScaleAction), for: .touchUpInside)
        markedInfos = markedInfosParam
        lockImage.alpha = 0
        self.setUpHolders()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        rect.frame = CGRect(x: halfSize, y: halfSize, width: self.frame.width-size, height: self.frame.height-size)
        linePath.removeAllPoints()
        itemShapeLayer.path = linePath.cgPath
        linePath.move(to: rullerpoint1Holder.center)
        linePath.addLine(to:  rullerpoint2Holder.center)
        drawPath(path: linePath)
        setAreaText()
    }
    public override func setAreaText() {
        let a = rullerpoint1Holder.center.x < rullerpoint2Holder.center.x ? (((rullerpoint2Holder.center.x - rullerpoint1Holder.center.x)/2) + rullerpoint1Holder.center.x) : (((rullerpoint1Holder.center.x - rullerpoint2Holder.center.x)/2) + rullerpoint2Holder.center.x)
        let b = rullerpoint1Holder.center.y < rullerpoint2Holder.center.y ? (((rullerpoint2Holder.center.y - rullerpoint1Holder.center.y)/2) + rullerpoint1Holder.center.y) : (((rullerpoint1Holder.center.y - rullerpoint2Holder.center.y)/2) + rullerpoint2Holder.center.y)
        measurmentLabel.frame.size = CGSize(width: 100, height: 20)
        measurmentLabel.center = CGPoint(x: a, y: b)
        let s = delegate?.getSheetScale() ?? .zero
        let p = delegate?.getImageViewFrame() ?? .zero
        let q = delegate?.getImageSize() ?? .zero
        let pt1 = CGPoint(x: ((rullerpoint1Holder.center.x/p.size.width) * s.width), y: ((rullerpoint1Holder.center.y/p.size.height) * s.height))
        let pt2 = CGPoint(x: ((rullerpoint2Holder.center.x/p.size.width) * s.width), y: ((rullerpoint2Holder.center.y/p.size.height) * s.height))
        let _pt1 = CGPoint(x: ((rullerpoint1Holder.center.x/p.size.width) * q.width), y: ((rullerpoint1Holder.center.y/p.size.height) * q.height))
        let _pt2 = CGPoint(x: ((rullerpoint2Holder.center.x/p.size.width) * q.width), y: ((rullerpoint2Holder.center.y/p.size.height) * q.height))
        dist1 = distance(_pt1, _pt2)
        let dist2 = distance(pt1, pt2)
        measurmentLabel.setTitle(getMeasurmntext(val: "\(dist2)"), for: .normal)
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
    public func drawPath(path:UIBezierPath)
    {
        itemShapeLayer.path = path.cgPath
        itemShapeLayer.lineWidth = 2
        itemShapeLayer.fillColor = UIColor.clear.cgColor
        itemShapeLayer.strokeColor = getColor(val:  self.markedInfos.drawableDetails.drawableStrokeColor).cgColor
    }
    override public func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
        self.markedInfos.originalDetails.originalStrokeColor = val
        layoutSubviews()
        
    }
    override public func resetAllProperties()
    {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            self.setStrokeColor(val: self.markedInfos.drawableDetails.drawableStrokeColor)
            self.setLock(val: self.markedInfos.isLocked)
//        })
    }
    @objc public func selectedRullerScaleAction()
    {
        delegate?.setselectedRullerSize(dist: dist1)
        PLMPresenter.shared.sheetDataSource.scaleSettextView = true
    }
    public override func setLock(val:Bool)
    {
        self.markedInfos.isLocked = val
        lockImage.alpha = self.markedInfos.isLocked ? 1 : 0
    }
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if rullerpoint1Holder.hitTest(convert(point, to: rullerpoint1Holder), with: event) != nil {
            return true
        }

        if rullerpoint2Holder.hitTest(convert(point, to: rullerpoint2Holder), with: event) != nil {
            return true
        }
        if measurmentLabel.hitTest(convert(point, to: measurmentLabel), with: event) != nil{
            return true
        }
        return false
    }
}
