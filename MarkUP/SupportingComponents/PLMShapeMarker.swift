//
//  PLMShapeMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 18/01/22.
//

import Foundation
import SwiftUI

public protocol PLMShapeTypeMarkerDelegate : AnyObject {
    func shapeMarkerMoved(pt : CGPoint, rowIndex: Int, sectionIndex : Int)
    func shapeMarkerHolderMoved(pt : CGPoint,type:PLMHolderType, rowIndex: Int, sectionIndex : Int)
    func shapeMarkerHolderMoveEnded(pt: CGPoint, type: PLMHolderType, rowIndex: Int, sectionIndex : Int)
    func shapeMarkerHolderMoveEnded(pt : CGPoint, rowIndex: Int, sectionIndex : Int)
    func shapeMarkerDisableAllHolder()
    func setSelectedMarker(rowIndex : Int, sectionIndex : Int)
    func attachRotatorToSelectedMarker()
    func disableRotator(val:Bool)
    func hideColorBar()
    func getImageSize()->CGSize
    func reAttachRotator()
    func getImageViewFrame()->CGRect
    func getSheetScale()->CGSize
    func getSheetScaleUnit()->String
    func setselectedRullerSize(dist:CGFloat)
    func getSheetId()->String
    func getSheetName()->String
    func showEditingOptionsForiPhone()
}
public class PLMShapeTypeMarker : UIView,UIGestureRecognizerDelegate,PLMHolderDelegate{
    
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var interactionforShapes : UIContextMenuInteraction!
    var markedInfos = markedInfoType(thisMarkerID: UUID().uuidString, type: .unknown, drawableDetails: drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: clearColor , drawableFillColor: clearColor, drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: .zero, originalStrokeWidth: 0, originalStrokeColor: clearColor, originalFillColor: clearColor, originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
    
    var groupIndex = 0
    var rowIndex = 0
    var visible = true
    var state = markerStateType.PUBLISHED
    
    
    let size : CGFloat = 26
    let halfSize : CGFloat = 13
    
    let selectionbox = UIView()
    let rullerpoint1Holder = PLMHolder.init(frame: .zero, type: .RULLERPOINT1)
    let rullerpoint2Holder = PLMHolder.init(frame: .zero, type: .RULLERPOINT2)
    
    let tlholder = PLMHolder.init(frame: .zero, type: .TL)
    let blholder = PLMHolder.init(frame: .zero, type: .BL)
    let trholder = PLMHolder.init(frame: .zero, type: .TR)
    let brholder = PLMHolder.init(frame: .zero, type: .BR)
    
    let lockImage = UIImageView()

    weak var delegate : PLMShapeTypeMarkerDelegate?
    
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 0.4
    var red: CGFloat = 1.0
    var green: CGFloat = 1.0
    var blue: CGFloat = 0.0
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setUpHolders(){
//        self.backgroundColor = .yellow
        self.addSubview(selectionbox)
        selectionbox.backgroundColor = .clear
        selectionbox.layer.borderColor = UIColor.blue.cgColor
        selectionbox.layer.borderWidth = 1
        
        addHolders(holder:tlholder)
        addHolders(holder:blholder)
        addHolders(holder:trholder)
        addHolders(holder:brholder)
        
        addHolders(holder:rullerpoint1Holder)
        addHolders(holder:rullerpoint2Holder)
        rullerpoint1Holder.layer.borderWidth = 1
        rullerpoint2Holder.layer.borderWidth = 1
        rullerpoint1Holder.layer.cornerRadius = halfSize
        rullerpoint2Holder.layer.cornerRadius = halfSize
        rullerpoint1Holder.layer.borderColor = UIColor.blue.cgColor
        rullerpoint2Holder.layer.borderColor = UIColor.blue.cgColor
        rullerpoint1Holder.backgroundColor = UIColor.white
        rullerpoint2Holder.backgroundColor = UIColor.white
        rullerpoint1Holder.frame = CGRect(x: 100, y: 100, width: size, height: size)
        rullerpoint2Holder.frame = CGRect(x: 200, y: 200, width: size, height: size)
        
        if markedInfos.type == .RULLER
        {
            tlholder.isHidden = true
            blholder.isHidden = true
            trholder.isHidden = true
            brholder.isHidden = true
            selectionbox.isHidden = true
        
        }
        else{
            rullerpoint1Holder.isHidden = true
            rullerpoint2Holder.isHidden = true
            
            let gestureRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(PLMShapeTypeMarker.moveMarkerGesture(_:)))
            gestureRecognizer1.delegate = self
            gestureRecognizer1.cancelsTouchesInView = true
            self.addGestureRecognizer(gestureRecognizer1)
            
            let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(PLMShapeTypeMarker.tappedMarkerGesture(_:)))
            gestureRecognizer2.numberOfTapsRequired = 2
            gestureRecognizer2.delegate = self
            gestureRecognizer2.cancelsTouchesInView = true
            self.addGestureRecognizer(gestureRecognizer2)
        }
 
        self.addSubview(lockImage)
        lockImage.image = UIImage.init(systemName: "lock.fill")
        lockImage.tintColor = .black
        lockImage.backgroundColor = .white
    }
    public func addHolders(holder:PLMHolder)
    {
        self.addSubview(holder)
//        holder.backgroundColor = .red
        holder.box.backgroundColor = .clear
        holder.box.layer.borderColor = UIColor.clear.cgColor
        holder.box.layer.borderWidth = 1
        holder.delegate = self
    }
    public func shouldEnableHolders(enable:Bool)
    {
        if markedInfos.type == .RULLER
        {
//            let cgclr = enable ? UIColor.blue.cgColor : UIColor.clear.cgColor
//            rullerpoint1Holder.layer.borderColor = cgclr
//            rullerpoint2Holder.layer.borderColor = cgclr
//            let clr = enable ? UIColor.white : UIColor.clear
//            rullerpoint1Holder.backgroundColor = clr
//            rullerpoint2Holder.backgroundColor = clr
//
//            if enable{
//                delegate?.setSelectedMarker(rowIndex: rowIndex, sectionIndex: groupIndex)
//                delegate?.attachRotatorToSelectedMarker()
//            }
        }
        else{
            let cgclr = enable ? UIColor.blue.cgColor : UIColor.clear.cgColor
            tlholder.box.layer.borderColor = cgclr
            blholder.box.layer.borderColor = cgclr
            trholder.box.layer.borderColor = cgclr
            brholder.box.layer.borderColor = cgclr
            selectionbox.layer.borderColor = cgclr
            let clr = enable ? UIColor.white : UIColor.clear
            tlholder.box.backgroundColor = clr
            blholder.box.backgroundColor = clr
            trholder.box.backgroundColor = clr
            brholder.box.backgroundColor = clr
            
            tlholder.isUserInteractionEnabled = enable
            blholder.isUserInteractionEnabled = enable
            trholder.isUserInteractionEnabled = enable
            brholder.isUserInteractionEnabled = enable
            
            if enable{
                delegate?.setSelectedMarker(rowIndex: rowIndex, sectionIndex: groupIndex)
                delegate?.attachRotatorToSelectedMarker()
            }
        }
    }
    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
            let t = self.transform
            self.transform = .identity
            selectionbox.frame = CGRect(x: halfSize, y: halfSize, width: self.frame.width-size, height: self.frame.height-size)
            tlholder.frame = CGRect(x: 0, y: 0, width: size, height: size)
            blholder.frame = CGRect(x: 0, y: self.frame.height-size, width: size, height: size)
            trholder.frame = CGRect(x: (self.frame.width)-size, y: 0, width: size, height: size)
            brholder.frame = CGRect(x: (self.frame.width)-size, y: self.frame.height-size, width: size, height: size)
            
            lockImage.frame.size = CGSize(width: 15, height: 15)
            lockImage.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
            self.transform = t

        }
    }
    public func setAreaText()
    {
        
    }
    public func shapeMarkerHolderMoved(pt: CGPoint, type: PLMHolderType) {
        if !markedInfos.isLocked && (tlholder.box.backgroundColor != .clear || rullerpoint1Holder.alpha == 1){
            delegate?.shapeMarkerHolderMoved(pt: pt, type: type, rowIndex: rowIndex, sectionIndex: groupIndex)
        }
    }
    public func shapeMarkerHolderMoveEnded(pt : CGPoint,type:PLMHolderType)
    {
        if !markedInfos.isLocked && (tlholder.box.backgroundColor != .clear || rullerpoint1Holder.alpha == 1){
            delegate?.shapeMarkerHolderMoveEnded(pt: pt, type: type, rowIndex: rowIndex, sectionIndex: groupIndex)
            setAreaText()
        }
    }
    @objc public func tappedMarkerGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        showActiveSheetMenu()
    }
    @objc public func moveMarkerGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if !markedInfos.isLocked && state != .PUBLISHED{
            switch gestureRecognizer.state {
            case .began:
                delegate?.hideColorBar()
                self.delegate?.shapeMarkerDisableAllHolder()
                shouldEnableHolders(enable: true)
                break
            case .changed:

                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
                delegate?.shapeMarkerMoved(pt: pt, rowIndex: rowIndex, sectionIndex: groupIndex)
                self.delegate?.attachRotatorToSelectedMarker()
                break
            case .possible:
                break
            case .ended:
                print("showing menu here 1")
//                showMenu()
                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
                delegate?.shapeMarkerHolderMoveEnded(pt: pt, rowIndex: rowIndex, sectionIndex: groupIndex)
                break
            case .cancelled:
                print("showing menu here 2")
//                showMenu()
                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
                delegate?.shapeMarkerHolderMoveEnded(pt: pt, rowIndex: rowIndex, sectionIndex: groupIndex)
                break
            case .failed:
                break
            @unknown default:
                break
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    public func disableRotator(val:Bool)
    {
        delegate?.disableRotator(val:val)
    }
    public func reAttachRotator()
    {
        delegate?.reAttachRotator()
    }
    public func hideColorBar()
    {
        delegate?.hideColorBar()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////TO BE OVERRIDEN METHODS
//    public func showMenu()
//    {
//        if !iPad{
//            print("cmenu - \(markedInfos.type)")
//            interactionforShapes = UIContextMenuInteraction(delegate: self)
//            self.addInteraction(interactionforShapes)
//        }else{
//            if markedInfos.type == .TEXT || markedInfos.type == .IMAGE{
//                interactionforShapes = UIContextMenuInteraction(delegate: self)
//                self.addInteraction(interactionforShapes)
//            }
//        }
//    }
    public func setStrokeWidth(val:CGFloat)
    {
//        if state == .DRAFT &&  PLMPresenter.shared.selectedProject != nil
//        {
//            var m = markedInfos
//            let t = savedMarkupsType(plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: delegate?.getSheetName() ?? "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [m], lastUpdated: "", state: .DRAFT)
//            PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: PLMPresenter.shared.selectedProject!.projectID, marker: t)
//        }
    }
    public func setStrokeColor(val:RGB_O_ColorType)
    {
        if state == .DRAFT
        {
            var m = markedInfos
            let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: delegate?.getSheetName() ?? "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [m], lastUpdated: "", state: .DRAFT)
            PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
        }
    }
    public func setFillColor(val:RGB_O_ColorType)
    {
        if state == .DRAFT
        {
            var m = markedInfos
            let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: delegate?.getSheetName() ?? "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [m], lastUpdated: "", state: .DRAFT)
            PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
        }
    }
    public func setAngle(val:CGFloat)
    {
//        if state == .DRAFT &&  PLMPresenter.shared.selectedProject != nil
//        {
//            var m = markedInfos
//            let t = savedMarkupsType(plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: delegate?.getSheetName() ?? "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [m], lastUpdated: "", state: .DRAFT)
//            PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: PLMPresenter.shared.selectedProject!.projectID, marker: t)
//        }
    }
    public func setLock(val:Bool)
    {
        
    }
    public func resetAllProperties()
    {
        
    }
    func getColor(val : RGB_O_ColorType)->UIColor
    {
        if val.redValue == -1
        {
            return UIColor.clear
        }
        else {
            let clr = UIColor.init(red: val.redValue/255, green: val.greenValue/255, blue: val.blueValue/255, alpha: val.opacity)
            return clr
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////  SHOULD BE MOVED

    
    
    public func getAngle(markerFrame : CGRect, touch : CGPoint)->CGFloat
    {
        let t = CGPoint(x: touch.x, y: touch.y)
        let oX : CGFloat = markerFrame.origin.x + (markerFrame.size.width/2)
        let oY : CGFloat = markerFrame.origin.y + (markerFrame.size.height/2)
        let radians = atan2f( Float(t.y - oY) , Float(t.x - oX))
        print("origin line = ",t," ",oX," ",oY)
        let deg : CGFloat = CGFloat(radians * 180 / .pi) - 90
        return deg
    }
    public func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    public func getMeasurmntext(val : Double) -> String {
        if PLMPresenter.shared.sheetDataSource.selectedMeasurmentUnit ==  PLMPresenter.shared.sheetDataSource.sizes[0] {
            let afterPoint = val.truncatingRemainder(dividingBy: 1)
            let val1 = Double(val - afterPoint)
            let decToInch = afterPoint * 12
            let afterPoint2 = decToInch.truncatingRemainder(dividingBy: 1)
            let val2 = Double(decToInch - afterPoint2)
            return "\(Int(val1))'\(Int(val2))\""
            
        }
        else{
            let afterPoint = val.truncatingRemainder(dividingBy: 1)
            let val1 = Double(val - afterPoint)
            let lenString = "\(afterPoint)"
            
            if lenString.count >= 2 {
                let index1 = lenString.substring(with: lenString.count >= 4 ? (2..<4) : (2..<3))
                return "\(Int(val1))\(index1)"
            }
            else {
                return "\(Int(val1))"
            }
           
        }
    }
    public override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }
    func showActiveSheetMenu()
    {
    
    }
    func removeActiveSheetMenu()
    {
        let menucontroller = UIMenuController.shared
        if menucontroller.isMenuVisible {
            menucontroller.setMenuVisible(false, animated: true)
        }
    }
}
//extension PLMShapeTypeMarker: UIContextMenuInteractionDelegate {
//    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//
//            let editShapesiPhone = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
//                //                PLMPresenter.shared.sheetDataSource.showEditMarkertextView = true
//                //                PLMPresenter.shared.sheetDataSource.markertext = self.textBox.text
//                self.delegate?.hideColorBar()
//                self.delegate?.shapeMarkerDisableAllHolder()
//                self.shouldEnableHolders(enable: true)
//                self.delegate?.showEditingOptionsForiPhone()
//            }
//
//            let moveShapesiPhone = UIAction(title: "move", image: UIImage(systemName: "arrow.right.arrow.left")) { action in
//
//                //                self.delegate?.hideColorBar()
//                //                self.delegate?.shapeMarkerDisableAllHolder()
//                //                self.shouldEnableHolders(enable: true)
//                //                self.removeInteraction(interaction)
//                //                delegate?.hideColorBar()
//                //                self.delegate?.shapeMarkerDisableAllHolder()
////                self.shouldEnableHolders(enable: true)
//
//                self.removeInteraction(self.interactionforShapes)
//            }
//            let editText = UIAction(title: "Edit Text", image: UIImage(systemName: "square.and.pencil")) { action in
//                PLMPresenter.shared.sheetDataSource.showEditMarkertextView = true
//                PLMPresenter.shared.sheetDataSource.markertext = self.markedInfos.text
//            }
//
//            let moveText = UIAction(title: "Select", image: UIImage(systemName: "arrow.right.arrow.left")) { action in
//                print("showing menu here 3")
//                self.delegate?.hideColorBar()
//                self.delegate?.shapeMarkerDisableAllHolder()
//                self.shouldEnableHolders(enable: true)
//                self.removeInteraction(interaction)
//                self.removeInteraction(self.interactionforShapes)
//            }
//            //            self.delegate?.setSelectedMarker(rowIndex: self.rowIndex, sectionIndex: self.groupIndex)
//            //                        self.delegate?.attachRotatorToSelectedMarker()
//
//            let photo = UIAction(title: "Library", image: UIImage(systemName: "photo.on.rectangle")) { action in
//
//                PLMPresenter.shared.sheetDataSource.imagePickerType = .library
//                PLMPresenter.shared.sheetDataSource.attachmentPickerShown = true
//            }
//            let camera = UIAction(title: "Camera", image: UIImage(systemName: "camera")) { action in
//
//                PLMPresenter.shared.sheetDataSource.imagePickerType = .camera
//                PLMPresenter.shared.sheetDataSource.attachmentPickerShown = true
//            }
//            let moveImage = UIAction(title: "Select", image: UIImage(systemName: "arrow.right.arrow.left")) { action in
//                print("showing menu here 3")
//                self.delegate?.hideColorBar()
//                self.delegate?.shapeMarkerDisableAllHolder()
//                self.shouldEnableHolders(enable: true)
//                self.removeInteraction(interaction)
//                self.removeInteraction(self.interactionforShapes)
//            }
////          Create and return a UIMenu with all of the actions as children
//            if self.markedInfos.type == .IMAGE{
//                return UIMenu(title: "", children: [photo,camera,moveImage])
//            }
//            else if self.markedInfos.type == .TEXT{
//                return UIMenu(title: "", children: [editText,moveText])
//            }else{
//                return UIMenu(title: "", children: [editShapesiPhone,moveShapesiPhone])
//            }
//        }
//    }
//}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}


//from web to mobile*********************************SUPPORTED
//rect
//circle
//scale
//draw
//arrow
//Text

//create/edit in mobile*************************************SUPPORTED
//rect
//circle
//scale
//draw
//arrow
//image

//send to web***********************************SUPPORTED
//rect
//circle
//text
//draw

//********************************************************************************
//********************************************************************************
//from web to mobile*********************************NOT SUPPORTED
//Text font
//image
//Highlighter
//rotation misalligned
//scale

//create/edit in mobile*************************************NOT SUPPORTED
//Highlighter
//hardness border size for draw etc

//send to web***********************************NOT SUPPORTED
//image
//Highlighter
//scale
//cloud
//arrow
//rotation of any marker
//text font
//scale

//********************************************************************************
//********************************************************************************
//OTHERS******************************************
//disable control bar if markedViews.count == 0
//disable publish
//disable save
//side bar drag drop
//font size for text
//need original size conversion
//need undo redo
//need send url request
//

//VERIFY
//rotator attach
//when keyboard comes up size diff flicker, need flicker correction
//need out of bounds correction
//text frame center
//markerLayer.selectedMarkerIndex != -1
//sidebar select row vica versa select item
//crashes



//NEW
//no highlighter
//no single marker copy
//gesture overlaps when used pen while in zoomed image
