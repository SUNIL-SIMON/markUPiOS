//
//  PLMDragHolders.swift
//  PlanMarkup
//
//  Created by SIMON on 22/01/22.
//

import UIKit
public protocol PLMHolderDelegate : AnyObject {
    func shapeMarkerHolderMoved(pt : CGPoint,type:PLMHolderType)
    func shapeMarkerHolderMoveEnded(pt : CGPoint,type:PLMHolderType)
    func disableRotator(val:Bool)
    func reAttachRotator()
    func hideColorBar()
}
public class PLMHolder : UIView, UIGestureRecognizerDelegate{

    let box = UIView()
    var type = PLMHolderType.BL
    weak var delegate : PLMHolderDelegate?
    public init(frame: CGRect, type : PLMHolderType)
    {
        super.init(frame: frame)
        self.type = type
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(PLMHolder.handleHolderGesture(_:)))
        gestureRecognizer1.delegate = self
        gestureRecognizer1.cancelsTouchesInView = true
        self.addGestureRecognizer(gestureRecognizer1)
        
        self.addSubview(box)
        box.isUserInteractionEnabled = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        box.frame = CGRect(x: 6.5, y: 6.5, width: self.frame.size.width - 13, height: self.frame.size.height - 13)
    }
    @objc public func handleHolderGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            delegate?.hideColorBar()
            delegate?.disableRotator(val: true)
            break
        case .changed:
            if gestureRecognizer.view?.layer.backgroundColor != UIColor.clear.cgColor{
                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
                print("drag location = ",pt)
                delegate?.shapeMarkerHolderMoved(pt: pt, type: type)
            }
            break
        case .possible:
            break
        case .ended:
            if gestureRecognizer.view?.layer.backgroundColor != UIColor.clear.cgColor{
                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
                delegate?.shapeMarkerHolderMoveEnded(pt: pt, type: type)
                delegate?.disableRotator(val: false)
                delegate?.reAttachRotator()
            }
            break
        case .cancelled:
            if gestureRecognizer.view?.layer.backgroundColor != UIColor.clear.cgColor{
                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
                delegate?.shapeMarkerHolderMoveEnded(pt: pt, type: type)
                delegate?.disableRotator(val: false)
                delegate?.reAttachRotator()
            }
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
}

