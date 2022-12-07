//
//  SwiftUIView.swift
//
//
//  Created by Deepak1037 on 24/06/22.
//

import Foundation
import UIKit
import AppearanceFramework

public protocol PLMShapesBariPhoneDelegate : AnyObject {
    func showiPhoneControlBar()
}

public class PLMShapesBarForiPhone : UIView, UIGestureRecognizerDelegate , UIScrollViewDelegate{
    
    
    var squareButton = PLMControBarButton3()
    var circleButton = PLMControBarButton3()
    var arrowButton = PLMControBarButton3()
    
    var textButton = PLMControBarButton3()
    var imageButton = PLMControBarButton3()
    
    var measureButton = PLMControBarButton3()
    var arcButton = PLMControBarButton3()
    
    var brushButton = PLMControBarButton3()
    var penButton = PLMControBarButton3()
    var commentsButton = PLMControBarButton3()


    weak var delegate : PLMControlBarDelegate?
    weak var iPhoneShapesBarDelegate : PLMShapesBariPhoneDelegate?
    
    
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)

        self.addSubview(squareButton)
        squareButton.imgView.image = UIImage(named: "square")?.withRenderingMode(.alwaysTemplate)
        //"square"
        squareButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        squareButton.lbl.text = "Square"
        squareButton.layer.cornerRadius = 10
        squareButton.addTarget(self, action: #selector(selectedRectMarkerToBeAddedOnTouch), for: .touchUpInside)
//        let gestureRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleRectGesture(_:)))
//        gestureRecognizer1.delegate = self
//        gestureRecognizer1.cancelsTouchesInView = true
//        squareButton.addGestureRecognizer(gestureRecognizer1)
        
        self.addSubview(circleButton)
        circleButton.imgView.image = UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate)
        circleButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        circleButton.lbl.text = "Circle"
//        let gestureRecognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleRoundGesture(_:)))
//        gestureRecognizer2.delegate = self
//        gestureRecognizer2.cancelsTouchesInView = true
//        circleButton.addGestureRecognizer(gestureRecognizer2)
        circleButton.addTarget(self, action: #selector(selectedRoundMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        self.addSubview(arcButton)
        arcButton.imgView.image = UIImage(named: "couldshaper")?.withRenderingMode(.alwaysTemplate) //couldshaper
        arcButton.tintColor =  UIColor(TCAppearance.shared.theme.change.textLabelColor)
        arcButton.lbl.text = "Cloud"
//        let gestureRecognizer5 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleArcsGesture(_:)))
//        gestureRecognizer5.delegate = self
//        gestureRecognizer5.cancelsTouchesInView = true
//        arcButton.addGestureRecognizer(gestureRecognizer5)
        arcButton.addTarget(self, action: #selector(selectedArcsMarkerToBeAddedOnTouch), for: .touchUpInside)

    }
    @objc public func commentsButtonClicked(){
        print("comments")
    }
    @objc public func selectedRectMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .RECT)
    }
    @objc public func selectedRoundMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .ROUND)
    }
    @objc public func selectedArcsMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .ARCS)
    }
    
//    @objc public func selectedArrowtMarkerToBeAddedOnTouch()
//    {
//        delegate?.selectedMarkerToBeAddedOnTouch(shape: .ARROW)
//    }
//    @objc public func selectedHighlightMarkerToBeAddedOnTouch()
//    {
//        delegate?.selectedMarkerToBeAddedOnTouch(shape: .HIGHLIGHTER)
//    }
//    @objc public func selectedScribleMarkerToBeAddedOnTouch()
//    {
//        delegate?.selectedMarkerToBeAddedOnTouch(shape: .PATH)
//    }
//    @objc public func selectedRullerMarkerToBeAddedOnTouch()
//    {
//        delegate?.selectedMarkerToBeAddedOnTouch(shape: .RULLER)
//    }
    @objc public func showHideFillColorBar()
    {
        delegate?.hideColorBar(colorMode: .fill)
    }
    @objc public func showHideStrokeColorBar()
    {
        delegate?.hideColorBar(colorMode: .stroke)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {

        let cornerspace = self.frame.size.width*0.15
        let space = self.frame.size.width*0.06
        let width = self.frame.size.width*0.16
        let height = self.frame.size.height*0.5
        let yPosition = self.frame.size.height/2 - (80/2)
        let spacing = (self.frame.size.width-210)/4
        let s : CGFloat = 70
        let s2 : CGFloat = 30
        squareButton.frame = CGRect(x: spacing, y: yPosition, width: 70, height: 70)
        circleButton.frame = CGRect(x: (spacing*2)+70, y: yPosition, width: 70, height: 70)
        arcButton.frame = CGRect(x: (spacing*3)+140, y: yPosition, width: 70, height: 70)
        
    }
    

    
//    @objc func pagechange(_ sender : UIPageControl){
//
//        let current = sender.currentPage
//        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * 240, y: 0), animated: true)
//    }
//
//    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//    }
//
    @objc public func clearAll()
    {
        delegate?.clearAll()
    }
    @objc public func handleRectGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        handleGesture(gestureRecognizer, shapeType: .RECT)
    }
    @objc public func handleRoundGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        handleGesture(gestureRecognizer, shapeType: .ROUND)
    }
    @objc public func handleArcsGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        handleGesture(gestureRecognizer, shapeType: .ARCS)
    }
    @objc public func handleTextGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        handleGesture(gestureRecognizer, shapeType: .TEXT)
    }
    @objc public func handleIMAGEGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        handleGesture(gestureRecognizer, shapeType: .IMAGE)
    }
    @objc public func handleRullerGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        handleGesture(gestureRecognizer, shapeType: .RULLER)
    }
}

extension PLMShapesBarForiPhone{
    public func handleGesture(_ gestureRecognizer: UILongPressGestureRecognizer, shapeType: PLMShapeType) {
        switch gestureRecognizer.state {
        case .began:
            var pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
            if shapeType == .IMAGE || shapeType == .RULLER
            {
                pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview?.superview))
            }
            delegate?.newShapeMarkerAdd(shapeType: shapeType, pt: pt)
            break
        case .changed:
            var pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
            if shapeType == .IMAGE || shapeType == .RULLER
            {
                pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview?.superview))
            }
            delegate?.newShapeMarkerMoved(pt: pt)
            break
        case .possible:
            break
        case .ended:
            var pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
            if shapeType == .IMAGE || shapeType == .RULLER
            {
                pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
            }
            delegate?.newShapeMarkerDropped(pt: pt)
//            navigate to control bar here for iphone
            iPhoneShapesBarDelegate?.showiPhoneControlBar()
            break
        case .cancelled:
            var pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
            if shapeType == .IMAGE || shapeType == .RULLER
            {
                pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
            }
            delegate?.newShapeMarkerDropped(pt: pt)
            break
        case .failed:
            var pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
            if shapeType == .IMAGE || shapeType == .RULLER
            {
                pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview?.superview))
            }
            delegate?.newShapeMarkerDropped(pt: pt)
            break
        @unknown default:
            break
        }
    }
}
