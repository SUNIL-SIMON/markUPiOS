//
//  PLMControlBar.swift
//  PlanMarkup
//
//  Created by SIMON on 18/01/22.
//

import Foundation
import UIKit

import AppearanceFramework
public protocol PLMControlBarDelegate : AnyObject {
    func newShapeMarkerAdd(shapeType : PLMShapeType, pt : CGPoint)
    func newShapeMarkerMoved(pt : CGPoint)
    func newShapeMarkerDropped(pt: CGPoint)
    func clearAll()
    func hideColorBar(colorMode : colorModeType)
    func selectedMarkerToBeAddedOnTouch(shape:PLMShapeType)
}
public class PLMControlBar : UIView, UIGestureRecognizerDelegate , UIScrollViewDelegate{

    var squareButton = PLMControBarButton1()
    var circleButton = PLMControBarButton1()
    var arrowButton = PLMControBarButton1()
    
    var textButton = PLMControBarButton1()
    var imageButton = PLMControBarButton1()
    
    var measureButton = PLMControBarButton1()
    var arcButton = PLMControBarButton1()
    
    var brushButton = PLMControBarButton1()
    var penButton = PLMControBarButton1()
    
    
    var strokeButton = PLMControBarButton1()
    var fillButton = PLMControBarButton1()
    
    var line = [UIView(),UIView(),UIView(),UIView(),UIView()]
    


    weak var delegate : PLMControlBarDelegate?
    
    
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)

        
        self.addSubview(squareButton)
        squareButton.imgView.image = UIImage(named: "square")?.withRenderingMode(.alwaysTemplate)
        //"square"
        squareButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        squareButton.lbl.text = "Square"
        squareButton.layer.cornerRadius = 10
//        let gestureRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleRectGesture(_:)))
//        gestureRecognizer1.delegate = self
//        gestureRecognizer1.cancelsTouchesInView = true
//        squareButton.addGestureRecognizer(gestureRecognizer1)
        squareButton.addTarget(self, action: #selector(selectedRectMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        
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
        
        self.addSubview(arrowButton)
        arrowButton.imgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        arrowButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        arrowButton.lbl.text = "Arrow"
        arrowButton.addTarget(self, action: #selector(selectedArrowtMarkerToBeAddedOnTouch), for: .touchUpInside)
        
    
        self.addSubview(textButton)
        textButton.imgView.image = UIImage(named: "text")?.withRenderingMode(.alwaysTemplate)
        textButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        textButton.lbl.text = "Text"
//        let gestureRecognizer3 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleTextGesture(_:)))
//        gestureRecognizer3.delegate = self
//        gestureRecognizer3.cancelsTouchesInView = true
//        textButton.addGestureRecognizer(gestureRecognizer3)
        textButton.addTarget(self, action: #selector(selectedTextMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        self.addSubview(imageButton)
        imageButton.imgView.image = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
        imageButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        imageButton.lbl.text = "Image"
//        let gestureRecognizer4 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleIMAGEGesture(_:)))
//        gestureRecognizer4.delegate = self
//        gestureRecognizer4.cancelsTouchesInView = true
//        imageButton.addGestureRecognizer(gestureRecognizer4)
        imageButton.addTarget(self, action: #selector(selectedImageMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        self.addSubview(brushButton)
        brushButton.imgView.image = UIImage(named: "highlighter")?.withRenderingMode(.alwaysTemplate)
        brushButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        brushButton.lbl.text = "Highlighter"
        brushButton.addTarget(self, action: #selector(selectedHighlightMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        self.addSubview(penButton)
        penButton.imgView.image = UIImage(named: "pen")?.withRenderingMode(.alwaysTemplate)
        penButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        penButton.lbl.text = "Pen"
        penButton.addTarget(self, action: #selector(selectedScribleMarkerToBeAddedOnTouch), for: .touchUpInside)
        
    
        
        self.addSubview(measureButton)
        measureButton.imgView.image = UIImage(named: "Measurment")?.withRenderingMode(.alwaysTemplate)
        measureButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        measureButton.lbl.text = "Scale"
        measureButton.addTarget(self, action: #selector(selectedRullerMarkerToBeAddedOnTouch), for: .touchUpInside)

        
        
        
       
        
        
        
        self.addSubview(strokeButton)
        strokeButton.imgView.layer.borderWidth = 5
        strokeButton.imgView.layer.cornerRadius = 15
        strokeButton.lbl.text = "Stroke"
        strokeButton.imgView.layer.shadowColor = UIColor.black.cgColor
        strokeButton.imgView.layer.shadowOpacity = 0.3
        strokeButton.imgView.layer.shadowOffset = .zero
        strokeButton.addTarget(self, action: #selector(showHideStrokeColorBar), for: .touchUpInside)
        

        self.addSubview(fillButton)
        fillButton.imgView.layer.cornerRadius = 15
        fillButton.lbl.text = "Fill"
        fillButton.layer.cornerRadius = 10
        fillButton.imgView.layer.shadowColor = UIColor.black.cgColor
        fillButton.imgView.layer.shadowOpacity = 0.3
        fillButton.imgView.layer.shadowOffset = .zero
        fillButton.addTarget(self, action: #selector(showHideFillColorBar), for: .touchUpInside)
        
//        pageControl.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        }
        
        self.addSubview(line[0])
        line[0].backgroundColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        self.addSubview(line[1])
        line[1].backgroundColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        self.addSubview(line[2])
        line[2].backgroundColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        self.addSubview(line[3])
        line[3].backgroundColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        self.addSubview(line[4])
        line[4].backgroundColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
        
    }
    @objc public func selectedArrowtMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .ARROW)
    }
    @objc public func selectedHighlightMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .HIGHLIGHTER)
    }
    @objc public func selectedScribleMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .PATH)
    }
    @objc public func selectedRullerMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .RULLER)
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
    @objc public func selectedTextMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .TEXT)
    }
    @objc public func selectedImageMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .IMAGE)
    }
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

        
        let s2 : CGFloat = 30
        let s : CGFloat = (self.frame.size.width - s2) / 11
        squareButton.frame = CGRect(x: 0, y: 0, width: s, height: self.frame.size.height)
        circleButton.frame = CGRect(x: (s * 1), y: 0, width: s, height: self.frame.size.height)
        arcButton.frame = CGRect(x: (s * 2), y: 0, width: s, height: self.frame.size.height)
        
        arrowButton.frame = CGRect(x: (s * 3), y: 0, width: s, height: self.frame.size.height)
        
        textButton.frame = CGRect(x: (s * 4), y: 0, width: s, height: self.frame.size.height)
        imageButton.frame = CGRect(x: (s * 5), y: 0, width: s, height: self.frame.size.height)
        
        penButton.frame = CGRect(x: (s * 6), y: 0, width: s, height: self.frame.size.height)
        brushButton.frame = CGRect(x: (s * 7), y: 0, width: s + s2,height: self.frame.size.height)
        
        measureButton.frame = CGRect(x: (s * 8) + s2, y: 0, width: s, height: self.frame.size.height)
        
        
        strokeButton.frame = CGRect(x: (s * 9) + s2, y: 0, width: s, height:self.frame.size.height)
        fillButton.frame = CGRect(x: (s * 10) + s2, y: 0, width: s, height: self.frame.size.height)

        
        line[0].frame = CGRect(x: (s * 3), y: 0, width: 0.5, height: self.frame.size.height)
        line[1].frame = CGRect(x: (s * 4), y: 0, width: 0.5, height: self.frame.size.height)
        line[2].frame = CGRect(x: (s * 6), y: 0, width: 0.5, height: self.frame.size.height)
        line[3].frame = CGRect(x: (s * 8) + s2, y: 0, width: 0.5, height: self.frame.size.height)
        line[4].frame = CGRect(x: (s * 9) + s2, y: 0, width: 0.5, height: self.frame.size.height)
        
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
//    @objc public func handleRectGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
//    {
//        handleGesture(gestureRecognizer, shapeType: .RECT)
//    }
//    @objc public func handleRoundGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
//    {
//        handleGesture(gestureRecognizer, shapeType: .ROUND)
//    }
//    @objc public func handleArcsGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
//    {
//        handleGesture(gestureRecognizer, shapeType: .ARCS)
//    }
//    @objc public func handleTextGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
//    {
//        handleGesture(gestureRecognizer, shapeType: .TEXT)
//    }
//    @objc public func handleIMAGEGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
//    {
//        handleGesture(gestureRecognizer, shapeType: .IMAGE)
//    }
//    @objc public func handleRullerGesture(_ gestureRecognizer: UILongPressGestureRecognizer)
//    {
//        handleGesture(gestureRecognizer, shapeType: .RULLER)
//    }
}
extension PLMControlBar{
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


public class PLMControBarButton1 : UIButton {
    let imgView = UIImageView()
    let lbl = UILabel()
    
    public init(){
        super.init(frame: .zero)
        self.addSubview(imgView)
        self.addSubview(lbl)
        
        self.backgroundColor =  UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        imgView.contentMode = .scaleToFill
        lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        imgView.frame = CGRect(x: (self.frame.size.width/2) - 15, y: 10, width: 30, height: 30 )
        lbl.frame = CGRect(x: 0, y: self.frame.size.height - 25, width: self.frame.size.width, height: 20 )
    }
}
public class PLMControBarButton2 : UIButton {
    let imgView = UIImageView()
    let lbl = UILabel()
    
    public init(){
        super.init(frame: .zero)
        self.addSubview(imgView)
        self.addSubview(lbl)
        
        self.backgroundColor = .white
        imgView.contentMode = .scaleToFill
        lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        imgView.frame = CGRect(x: (self.frame.size.width/2) - 15, y: 2, width: 30, height: 30 )
        lbl.frame = CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width, height: 20 )
      
    }
    
}
public class PLMControBarButton3 : UIButton {
    let imgView = UIImageView()
    let lbl = UILabel()
    
    public init(){
        super.init(frame: .zero)
        
        self.backgroundColor =  UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        
        self.addSubview(imgView)
        self.addSubview(lbl)
        
        
        imgView.contentMode = .scaleToFill
        lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        lbl.font = UIFont.systemFont(ofSize: 11)
        lbl.textAlignment = .center
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        imgView.frame = CGRect(x: (self.frame.size.width/2) - (self.frame.width*0.6)/2, y: self.frame.size.height*0.05, width: self.frame.width*0.6, height: self.frame.size.height*0.6 )
        lbl.frame = CGRect(x: 0, y: self.frame.size.height*0.7, width: self.frame.size.width, height: self.frame.size.height*0.25 )
    }
}
public class PLMControBarUIView : UIView {
    let imgView = UIImageView()
    let lbl = UILabel()
    public init(){
        super.init(frame: .zero)
        self.addSubview(imgView)
        self.addSubview(lbl)
        
        self.backgroundColor = .white
        imgView.contentMode = .scaleToFill
        lbl.textColor = TCAppearance.shared.theme.color.PLMsecondaryColorui
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        imgView.frame = CGRect(x: (self.frame.size.width/2) - 15, y: 2, width: 30, height: 30 )
        lbl.frame = CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width, height: 20 )
      
    }
}


//-----------------------------------------FOR iPhone-----------------------------------------------------

public protocol PLMControlBariPhoneDelegate : AnyObject {
    func shapesClickedOniPhone()
}
public class PLMControlBarForiPhone : UIView, UIGestureRecognizerDelegate , UIScrollViewDelegate{

    var squareButton = PLMControBarButton3()
//    var circleButton = PLMControBarButton1()
    var arrowButton = PLMControBarButton3()
    
    var textButton = PLMControBarButton3()
    var imageButton = PLMControBarButton3()
    
    var measureButton = PLMControBarButton3()
    var arcButton = PLMControBarButton3()
    
    var brushButton = PLMControBarButton3()
    var penButton = PLMControBarButton3()
    var commentsButton = PLMControBarButton3()
    
    
//    var strokeButton = PLMControBarButton1()
//    var fillButton = PLMControBarButton1()
    
//    var line = [UIView(),UIView(),UIView(),UIView(),UIView()]
    


    weak var delegate : PLMControlBarDelegate?
    weak var iPhoneDelegate: PLMControlBariPhoneDelegate?
    
    
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)

        self.addSubview(squareButton)
        squareButton.imgView.image = UIImage(named: "square")?.withRenderingMode(.alwaysTemplate)
        //"square"
        squareButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        squareButton.lbl.text = "Shapes"
        squareButton.layer.cornerRadius = 10
        squareButton.addTarget(self, action: #selector(shapesButtonClicked), for: .touchUpInside)
        
        
        self.addSubview(arcButton)
        arcButton.imgView.image = UIImage(named: "couldshaper")?.withRenderingMode(.alwaysTemplate) //couldshaper
        arcButton.tintColor =  UIColor(TCAppearance.shared.theme.change.textLabelColor)
        arcButton.lbl.text = "Cloud"
//        let gestureRecognizer5 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleArcsGesture(_:)))
//        gestureRecognizer5.delegate = self
//        gestureRecognizer5.cancelsTouchesInView = true
//        arcButton.addGestureRecognizer(gestureRecognizer5)
        
        self.addSubview(arrowButton)
        arrowButton.imgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        arrowButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        arrowButton.lbl.text = "Arrow"
        arrowButton.addTarget(self, action: #selector(selectedArrowtMarkerToBeAddedOnTouch), for: .touchUpInside)
        
    
        self.addSubview(textButton)
        textButton.imgView.image = UIImage(named: "text")?.withRenderingMode(.alwaysTemplate)
        textButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        textButton.lbl.text = "Text"
//        let gestureRecognizer3 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleTextGesture(_:)))
//        gestureRecognizer3.delegate = self
//        gestureRecognizer3.cancelsTouchesInView = true
//        textButton.addGestureRecognizer(gestureRecognizer3)
        
        self.addSubview(imageButton)
        imageButton.imgView.image = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
        imageButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        imageButton.lbl.text = "Image"
//        let gestureRecognizer4 = UILongPressGestureRecognizer(target: self, action: #selector(PLMControlBar.handleIMAGEGesture(_:)))
//        gestureRecognizer4.delegate = self
//        gestureRecognizer4.cancelsTouchesInView = true
//        imageButton.addGestureRecognizer(gestureRecognizer4)
        
        self.addSubview(brushButton)
        brushButton.imgView.image = UIImage(named: "highlighter")?.withRenderingMode(.alwaysTemplate)
        brushButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        brushButton.lbl.text = "Highlighter"
        brushButton.addTarget(self, action: #selector(selectedHighlightMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        self.addSubview(penButton)
        penButton.imgView.image = UIImage(named: "pen")?.withRenderingMode(.alwaysTemplate)
        penButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        penButton.lbl.text = "Pen"
        penButton.addTarget(self, action: #selector(selectedScribleMarkerToBeAddedOnTouch), for: .touchUpInside)
        
    
        
        self.addSubview(measureButton)
        measureButton.imgView.image = UIImage(named: "Measurment")?.withRenderingMode(.alwaysTemplate)
        measureButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        measureButton.lbl.text = "Scale"
        measureButton.addTarget(self, action: #selector(selectedRullerMarkerToBeAddedOnTouch), for: .touchUpInside)
        
        self.addSubview(commentsButton)
        commentsButton.imgView.image = UIImage(named: "Collab")?.withRenderingMode(.alwaysTemplate)
        commentsButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor).withAlphaComponent(2)
        commentsButton.lbl.text = "Comments"
        commentsButton.addTarget(self, action: #selector(selectedScribleMarkerToBeAddedOnTouch), for: .touchUpInside)
        
//        self.addSubview(line[0])
//        line[0].backgroundColor = TCAppearance.shared.theme.color.PLMControlBarLine
//        self.addSubview(line[1])
//        line[1].backgroundColor = TCAppearance.shared.theme.color.PLMControlBarLine
//        self.addSubview(line[2])
//        line[2].backgroundColor = TCAppearance.shared.theme.color.PLMControlBarLine
//        self.addSubview(line[3])
//        line[3].backgroundColor = TCAppearance.shared.theme.color.PLMControlBarLine
//        self.addSubview(line[4])
//        line[4].backgroundColor = TCAppearance.shared.theme.color.PLMControlBarLine
        
        
    }
    @objc public func shapesButtonClicked(){
        iPhoneDelegate?.shapesClickedOniPhone()
    }
    @objc public func commentsButtonClicked(){
        print("comments")
    }
    @objc public func selectedArrowtMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .ARROW)
    }
    @objc public func selectedHighlightMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .HIGHLIGHTER)
    }
    @objc public func selectedScribleMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .PATH)
    }
    @objc public func selectedRullerMarkerToBeAddedOnTouch()
    {
        delegate?.selectedMarkerToBeAddedOnTouch(shape: .RULLER)
    }
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
//         80 - views 20 - space
//5 spaces - 4 each , 4 views - 20 each (20 * 4 = 80, 4 * 5 = 20 , total = 100)
        let space = (self.frame.size.width-240)/5
        let view: CGFloat = 60
        let s : CGFloat = 70
        let s2 : CGFloat = 30
        let height: CGFloat = 60
        squareButton.frame = CGRect(x: space, y: self.frame.size.height*0.1, width: view, height: height)
//        circleButton.frame = CGRect(x: (s * 1), y: 0, width: s, height: self.frame.size.height)
        brushButton.frame = CGRect(x: (space * 2)+view, y: self.frame.size.height*0.1, width: view, height: height)
        
        penButton.frame = CGRect(x: (space * 3)+(view*2), y: self.frame.size.height*0.1, width: view, height: height)
        
        measureButton.frame = CGRect(x: (space * 4)+(view*3), y: self.frame.size.height*0.1, width: view, height: height)
        textButton.frame = CGRect(x: space, y: self.frame.size.height*0.5, width: view, height: height)
        
        arrowButton.frame = CGRect(x: (space * 2)+view, y: self.frame.size.height*0.5, width: view, height: height)
        imageButton.frame = CGRect(x: (space * 3)+(view*2), y: self.frame.size.height*0.5, width: view,height: height)
        
        commentsButton.frame = CGRect(x: (space * 4)+(view*3), y: self.frame.size.height*0.5, width: view, height: height)
        
        

        
//        line[0].frame = CGRect(x: (s * 3), y: 0, width: 1, height: self.frame.size.height)
//        line[1].frame = CGRect(x: (s * 4), y: 0, width: 1, height: self.frame.size.height)
//        line[2].frame = CGRect(x: (s * 6), y: 0, width: 1, height: self.frame.size.height)
//        line[3].frame = CGRect(x: (s * 8) + s2, y: 0, width: 1, height: self.frame.size.height)
//        line[4].frame = CGRect(x: (s * 9) + s2, y: 0, width: 1, height: self.frame.size.height)
        
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

extension PLMControlBarForiPhone{
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
