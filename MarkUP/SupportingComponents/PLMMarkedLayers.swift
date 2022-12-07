//
//  PLMMarkedLayers.swift
//  PlanMarkup
//
//  Created by SIMON on 18/01/22.
//

import Foundation
import UIKit
import AppearanceFramework

public protocol PLMMarkedLayersDelegate : AnyObject {
    func layerListReload()
    func getImageViewFrame()->CGRect
    func getImage()->UIImage
    func getStrokeWidth()->CGFloat
    func getStrokeColor()->RGB_O_ColorType
    func getFillColor()->RGB_O_ColorType
    func hideColorBar()
    func getSheetScale()->CGSize
    func getSheetScaleUnit()->String
    func setselectedRullerSize(dist:CGFloat)
    func getSheetId()->String
    func getSheetName()->String
    func showEditingOptionsForiPhone()
}
public class PLMMarkedLayers : UIView, PLMShapeTypeMarkerDelegate, UIGestureRecognizerDelegate{
    

    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var borderClosed = false
    
    
    let size : CGFloat = 20
    let halfSize : CGFloat = 10

    var markedViews = [markedGroupCellType]()
    var rotator = UIView()
    var imageHolderFrame = CGRect.zero
    var drawableDefaultCollection = drawableDefaultCollectionType(strokeWidth: 10, fillColor: clearColor, strokeColor: redColor,angle:0)
    var drawableHighlighterDefaultCollection = drawableDefaultCollectionType(strokeWidth: 15, fillColor: clearColor, strokeColor: redColor,angle:0)
    weak var delegate : PLMMarkedLayersDelegate?
    let textViewinalert = UITextView(frame: CGRect.zero)
    var selectedMarkerIndex = -1
    var selectedGroupIndex = 0
    var selectedMarkerToBeAdded = PLMShapeType.unknown
    
    let dv = UIView()
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.addSubview(rotator)
       
        self.addSubview(dv)
        dv.backgroundColor = .clear
        dv.isUserInteractionEnabled = false
        rotator.backgroundColor = TCAppearance.shared.theme.color.UItableviewunderlyingbackground
        rotator.layer.cornerRadius = 12.5
        rotator.alpha = 0

        let imv = UIImageView()
        rotator.addSubview(imv)
        imv.contentMode = .scaleAspectFit
        imv.image = UIImage(systemName: "gobackward")
        imv.frame = CGRect(x: 2.5, y: 2.5, width: 20, height: 20)
        
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(PLMMarkedLayers.handleRotationGesture(_:)))
        gestureRecognizer1.delegate = self
//        gestureRecognizer1.cancelsTouchesInView = true
        rotator.addGestureRecognizer(gestureRecognizer1)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
       
    }
    public func deSelectMarker()
    {
        if markedViews.count > selectedGroupIndex && selectedGroupIndex >= 0
        {
            if markedViews[selectedGroupIndex].markers.count > selectedMarkerIndex && selectedMarkerIndex >= 0
            {
                rotator.alpha = 0
                let v = markedViews[selectedGroupIndex].markers[selectedMarkerIndex]
                v.shouldEnableHolders(enable: false)
            }
        }
        selectedMarkerIndex = -1
        delegate?.layerListReload()
//        selectedGroupIndex = 0
    }
    public func setSelectedMarker(rowIndex: Int, sectionIndex: Int) {
        selectedMarkerIndex = rowIndex
        selectedGroupIndex = sectionIndex
        delegate?.layerListReload()
    }
    public func showEditingOptionsForiPhone(){
        delegate?.showEditingOptionsForiPhone()
    }
    public func attachRotatorToSelectedMarker()
    {
        if markedViews.count > selectedGroupIndex && selectedGroupIndex >= 0
        {
            if markedViews[selectedGroupIndex].markers.count > selectedMarkerIndex && selectedMarkerIndex >= 0
            {
                rotator.alpha = 1
                let v = markedViews[selectedGroupIndex].markers[selectedMarkerIndex]
//                v as PLMRullerMarker
//                if v.transform != .identity{
                    dv.transform = .identity
                    let pt = v.transform
                    v.transform = .identity
                    dv.frame.size = CGSize(width: 1, height: v.frame.size.height + 10)
                    dv.center = v.center
                    v.transform = pt
                    dv.transform = v.transform
//                }
//                else{
//                    dv.frame.size = CGSize(width: 1, height: v.frame.size.height + 10)
//                    dv.center = v.center
//                }
                let tl = dv.newBottomRight
    //            let s : CGFloat = 10//v.markedInfos.drawableDetails. > 180 ? 10 : 0
                rotator.frame.size = CGSize(width: 25, height: 25)
                rotator.center = tl
            }
            else{
                rotator.alpha = 0
            }
        }
        else{
            rotator.alpha = 0
        }
    }
    public func disableRotator(val:Bool)
    {
        rotator.alpha = val == true ? 0 : 1
    }
    public func reAttachRotator()
    {
        self.attachRotatorToSelectedMarker()
    }
    public func newShapeMarkerAdd(shapeType : PLMShapeType, pt : CGPoint)
    {
        if delegate != nil{
            drawableDefaultCollection.strokeWidth = 3
            drawableDefaultCollection.strokeColor = delegate?.getStrokeColor() ?? clearColor
            let f = delegate?.getImageViewFrame() ?? CGRect.zero
            if selectedGroupIndex >= markedViews.count
            {
                markedViews.append(markedGroupCellType(expanded: true, typeStr : "", allHidden: false, title: "Draft", permissionType: .EDITABLE, state: .DRAFT, markers: []))
                selectedGroupIndex = markedViews.count - 1
            }
            else if markedViews[selectedGroupIndex].state == .PUBLISHED
            {
                markedViews.append(markedGroupCellType(expanded: true, typeStr : "", allHidden: false, title: "Draft", permissionType: .EDITABLE, state: .DRAFT, markers: []))
                selectedGroupIndex = markedViews.count - 1
            }
            if shapeType == .RECT
            {
                let r = CGRect(x: 0, y: 0, width: 100, height: 100)
                let a = markedInfoType(thisMarkerID: UUID().uuidString, type: .RECT, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: delegate!.getStrokeWidth(), drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: delegate!.getStrokeWidth(), originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                createRectMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: r, enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)//need original size conversion
            }
            if shapeType == .ROUND
            {
                let r = CGRect(x: 0, y: 0, width: 100, height: 100)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .ROUND, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: delegate!.getStrokeWidth(), drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: delegate!.getStrokeWidth(), originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                createRoundMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: r, enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)//need original size conversion

            }
            if shapeType == .ARCS
            {
                let r = CGRect(x: 0, y: 0, width: 100, height: 100)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .ARCS, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: delegate!.getStrokeWidth(), drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: delegate!.getStrokeWidth(), originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                createArcsMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: r, enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)//need original size conversion
            }
            if shapeType == .TEXT
            {
                let r = CGRect(x: 0, y: 0, width: 100, height: 100)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .TEXT, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: drawableDefaultCollection.strokeWidth, drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: drawableDefaultCollection.strokeWidth, originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "Add Text", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                createTextMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: r, enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)//need original size conversion
            }
            if shapeType == .IMAGE
            {
                let r = CGRect(x: 0, y: 0, width: 100, height: 100)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .IMAGE, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: drawableDefaultCollection.strokeWidth, drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: drawableDefaultCollection.strokeWidth, originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "Add Text", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                createImageMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: r, enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)//need original size conversion
            }
            if shapeType == .RULLER
            {
                let r = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .RULLER, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: drawableDefaultCollection.strokeWidth, drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: drawableDefaultCollection.strokeWidth, originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                
                createRullerMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height), enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)
                
                markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].frame = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
                
 
            }
            if shapeType == .PATH
            {
                let r = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .PATH, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: drawableDefaultCollection.strokeWidth, drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: drawableDefaultCollection.strokeWidth, originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                
                createPathMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height), enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)
                markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].frame = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
            }
            if shapeType == .HIGHLIGHTER
            {
                let r = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
                var clr = delegate!.getStrokeColor()
                clr.opacity = 0.3
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .HIGHLIGHTER, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: drawableHighlighterDefaultCollection.strokeWidth, drawableStrokeColor:  clr, drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: drawableHighlighterDefaultCollection.strokeWidth, originalStrokeColor: clr, originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                
                createHighlightMarker(lineWidth: drawableHighlighterDefaultCollection.strokeWidth, pt: pt, frameRect: CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height), enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)
                markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].frame = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
            }
            if shapeType == .ARROW
            {
                let r = CGRect(x: 0, y: 0, width: 100, height: 50)
                let a = markedInfoType(thisMarkerID: UUID().uuidString,type: .ARROW, drawableDetails: drawableMarkerInfoType(drawableframeRect: r, drawableStrokeWidth: drawableDefaultCollection.strokeWidth, drawableStrokeColor:  delegate!.getStrokeColor(), drawableFillColor: delegate!.getFillColor(), drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero)), originalDetails: originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: drawableDefaultCollection.strokeWidth, originalStrokeColor: delegate!.getStrokeColor(), originalFillColor: delegate!.getFillColor(), originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero)), text: "", image: imageMarkerType(image: UIImage(systemName: "camera")!, urlID: ""),measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
                
                createArrowMarker(lineWidth: drawableDefaultCollection.strokeWidth, pt: pt, frameRect: r, enableHolders: true, originalSizeParam: r, markedInfos: a, state : .DRAFT)//need original size conversion
            }
        
        let v = markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1]
        let x = v.frame.origin.x+halfSize
        let y = v.frame.origin.y+halfSize
        let w = v.frame.size.width-size
        let h = v.frame.size.height-size

        let p = delegate?.getImage().size ?? CGSize.zero
        let x1 = ((x / f.size.width) * p.width)
        let y1 = ((y / f.size.height) * p.height)
        let w1 = ((w / f.size.width) * p.width)
        let h1 = ((h / f.size.height) * p.height)
            
        let size2 = (f.size.width < f.size.height) ? f.size.width : f.size.height
        let size3 = (p.width < p.height) ? p.width : p.height
        let strWidth = ((markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.drawableDetails.drawableStrokeWidth/size2) * size3)
            

//        if shapeType == .RULLER
//        {
//            markedViews[markedViews.count - 1].originalSize = CGRect(x: 0, y: 0, width: p.width, height: p.height)
//        }
//        else{
            markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)
            markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.originalDetails.originalStrokeWidth = strWidth
//        }
//
//        let size2 = (f.size.width < f.size.height) ? f.size.width : f.size.height
//        let size3 = (p.width < p.height) ? p.width : p.height
//        let strWidth = (drawableDefaultCollection.strokeWidth/size2) * size3
//        markedViews[markedViews.count - 1].markedInfos.strokeWidth = strWidth
//        markedViews[markedViews.count - 1].markedInfos.strokeColor = getsetColorString()
        markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].resetAllProperties()
//        reset(strokeWidth: drawableDefaultCollection.strokeWidth, strokeColor: getsetColorString(), angle: 0)
            
            if shapeType != .PATH && shapeType != .HIGHLIGHTER{
                if markedViews[markedViews.count-1].state == .DRAFT
                {
                    let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos], lastUpdated: "", state: .DRAFT)
                    PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
                }
            }
        }
    }
    
    public func newShapeMarkerMoved(pt : CGPoint)
    {
        let v = markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1]
        v.center = pt
        print("location 2 = ",pt)
    }
    public func newShapeMarkerDropped(pt : CGPoint)
    {
        let v = markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1]
        v.shouldEnableHolders(enable:false)
        delegate?.layerListReload()
        if v.frame.origin.x < 0{
            v.frame.origin.x = 0
        }
        if v.frame.origin.y < 0{
            v.frame.origin.y = 0
        }
        if v.frame.origin.y + v.frame.size.height > imageHolderFrame.size.height{
            v.frame.origin.y = imageHolderFrame.size.height - v.frame.size.height
        }
        if v.frame.origin.x + v.frame.size.width > imageHolderFrame.size.width{
            v.frame.origin.x = imageHolderFrame.size.width - v.frame.size.width
        }
        
        let x = v.frame.origin.x+halfSize
        let y = v.frame.origin.y+halfSize
        let w = v.frame.size.width-size
        let h = v.frame.size.height-size
        let f = delegate?.getImageViewFrame() ?? CGRect.zero
        let p = delegate?.getImage().size ?? CGSize.zero
        let x1 = ((x / f.size.width) * p.width)
        let y1 = ((y / f.size.height) * p.height)
        let w1 = ((w / f.size.width) * p.width)
        let h1 = ((h / f.size.height) * p.height)
        markedViews[markedViews.count - 1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)
        
        if v.markedInfos.type == .TEXT
        {
            PLMPresenter.shared.sheetDataSource.showEditMarkertextView = true
            PLMPresenter.shared.sheetDataSource.markertext = ""
            markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.text =  "Add Text"
            (markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1] as! PLMTextMarker).textBox.text = markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.text
        }
        if markedViews[markedViews.count-1].state == .DRAFT
        {
            let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos], lastUpdated: "", state: .DRAFT)
            PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
        }
    }
    public func addImageToLastAddedMarker(image:UIImage)
    {
        if markedViews.count > selectedGroupIndex && selectedGroupIndex >= 0
        {
            if markedViews[selectedGroupIndex].markers.count > 0{
                let ix = selectedMarkerIndex != -1 ? selectedMarkerIndex : markedViews.count-1
                if markedViews[selectedGroupIndex].markers[ix].markedInfos.type == .IMAGE
                {
                    markedViews[selectedGroupIndex].markers[ix].markedInfos.image.image =  image
                    (markedViews[selectedGroupIndex].markers[ix] as! PLMImageMarker).rect.image = markedViews[selectedGroupIndex].markers[ix].markedInfos.image.image
                    (markedViews[selectedGroupIndex].markers[ix] as! PLMImageMarker).layoutSubviews()
                    
                    if markedViews[selectedGroupIndex].state == .DRAFT
                    {
                        let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[selectedGroupIndex].markers[ix].markedInfos], lastUpdated: "", state: .DRAFT)
                        PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
                    }
                }
                else if  markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.type == .IMAGE{
                    markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.image.image =  image
                    (markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1] as! PLMImageMarker).rect.image = markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos.image.image
                    (markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1] as! PLMImageMarker).layoutSubviews()
                    if markedViews[markedViews.count-1].state == .DRAFT
                    {
                        let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos], lastUpdated: "", state: .DRAFT)
                        PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
                    }
                }
            }
        }
    }
    public func deleteMarkerAt(groupIndex:Int, rowIndex:Int)
    {
        if groupIndex < markedViews.count{
            markedViews[groupIndex].markers[rowIndex].removeFromSuperview()
            markedViews[groupIndex].markers.remove(at: rowIndex)
        }
        for i in 0..<markedViews.count {
            for j in 0..<markedViews[i].markers.count {
                markedViews[i].markers[j].groupIndex = i
                markedViews[i].markers[j].rowIndex = j
            }
        }
    }
    public func addTextToLastAddedMarker(text:String)
    {
        if markedViews.count > 0{
            let jx = selectedGroupIndex != -1 ? selectedGroupIndex : markedViews.count-1
            let ix = selectedMarkerIndex != -1 ? selectedMarkerIndex : markedViews[jx].markers.count-1
            if markedViews[jx].markers[ix].markedInfos.type == .TEXT
            {
                if text == ""{
//                    deleteMarkerAt(index:ix)
                }
                else{
                    markedViews[jx].markers[ix].markedInfos.text =  text
                    (markedViews[jx].markers[ix] as! PLMTextMarker).textBox.text = markedViews[jx].markers[ix].markedInfos.text
                    (markedViews[jx].markers[ix] as! PLMTextMarker).layoutSubviews()
                    
                    if markedViews[jx].state == .DRAFT
                    {
                        let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[jx].markers[ix].markedInfos], lastUpdated: "", state: .DRAFT)
                        PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
                    }
                }
            }
            else if  markedViews[markedViews.count-1].markers[markedViews[markedViews.count-1].markers.count - 1].markedInfos.type == .TEXT
            {
                if text == ""{
//                    deleteMarkerAt(index:markedViews.count-1)
                }
                else{
                    let k = markedViews[markedViews.count-1].markers[markedViews[markedViews.count-1].markers.count - 1]
                    k.markedInfos.text =  text
                    (k as! PLMTextMarker).textBox.text = k.markedInfos.text
                    (k as! PLMTextMarker).layoutSubviews()
                }
                if markedViews[markedViews.count-1].state == .DRAFT
                {
                    let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[markedViews.count-1].markers[markedViews[markedViews.count - 1].markers.count - 1].markedInfos], lastUpdated: "", state: .DRAFT)
                    PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
                }
            }
            
            
        }
    }
    public func clearAll()
    {
        for t in markedViews
        {
            for v in t.markers
            {
                v.removeFromSuperview()
            }
        }
        markedViews.removeAll()
        borderClosed = false
        imageHolderFrame = CGRect.zero
        drawableDefaultCollection = drawableDefaultCollectionType(strokeWidth: 10, fillColor: clearColor, strokeColor: redColor,angle:0)
        selectedMarkerIndex = -1
        selectedGroupIndex = 0
        selectedMarkerToBeAdded = PLMShapeType.unknown
    }
    public func shapeMarkerDisableAllHolder() {
        for t in markedViews
        {
            for v in t.markers
            {
                v.shouldEnableHolders(enable: false)
                v.removeActiveSheetMenu()
            }
        }
        delegate?.layerListReload()
    }
    func isInsideBorder(pt : CGPoint)->Bool
    {
        let s = delegate?.getImageViewFrame() ?? .zero
        if pt.x > 0 &&  pt.x < (s.size.width) && pt.y > 0 &&  pt.y < (s.size.height)
        {
            return true
        }
        return false
    }
    public func shapeMarkerMoved(pt: CGPoint, rowIndex: Int, sectionIndex: Int) {
        //view drag reach here
        let v = markedViews[sectionIndex].markers[rowIndex]
        let storedPt = v.center
        let s = delegate?.getImageViewFrame() ?? CGRect.zero
        var pt1 = pt
        pt1.x = pt1.x - s.origin.x
        pt1.y = pt1.y - s.origin.y
        v.center = pt1
        if isInsideBorder(pt : v.newTopLeft) && isInsideBorder(pt : v.newTopRight) && isInsideBorder(pt : v.newBottomLeft) && isInsideBorder(pt : v.newBottomRight){
            let x = v.frame.origin.x+halfSize
            let y = v.frame.origin.y+halfSize
            let w = v.frame.size.width-size
            let h = v.frame.size.height-size
            let f = delegate?.getImageViewFrame() ?? CGRect.zero
            let p = delegate?.getImage().size ?? CGSize.zero
            let x1 = ((x / f.size.width) * p.width)
            let y1 = ((y / f.size.height) * p.height)
            let w1 = ((w / f.size.width) * p.width)
            let h1 = ((h / f.size.height) * p.height)
            markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)
        }
        else{
            v.center = storedPt
        }
    }
    public func shapeMarkerHolderMoved(pt: CGPoint, type: PLMHolderType, rowIndex: Int, sectionIndex: Int) {
        
        //holders reach here
        if !borderClosed{
            UIView.performWithoutAnimation {
            
                let mv = self.markedViews[sectionIndex].markers[rowIndex]
                if    mv.markedInfos.drawableDetails.drawableAngle != 0 {
                    self.borderClosed = true
                }

                let s = self.delegate?.getImageViewFrame() ?? CGRect.zero
                let t = self.delegate?.getImage().size ?? .zero
                var pt1 = pt
                pt1.x = pt1.x - s.origin.x
                pt1.y = pt1.y - s.origin.y
                if pt1.x > 0 && pt1.y > 0 && pt1.x < self.frame.size.width && pt1.y < self.frame.size.height {
                    
                    var temp_v = CGRect.zero
                    
                    let pre_TL = mv.newTopLeft
                    let pre_BL = mv.newBottomLeft
                    let pre_BR = mv.newBottomRight
                    let pre_TR = mv.newTopRight
                    var cpt = mv.center
                    
                    
                    switch (type)
                    {
                    case .TL:
                        let unknownPoint1 = CGPoint(x: pre_BL.x-(pre_TL.x-pt1.x), y: pre_BL.y)
                        let unknownPoint2 = CGPoint(x: pre_TR.x, y: pre_TR.y-(pre_TL.y-pt1.y))
                        mv.transform = .identity
                        cpt = mv.center
                        let t1 = getIntersectionOfLines(line1: (a:pre_BR,b:pre_BL), line2: (a:pt1,b:unknownPoint1))
                        let d1 = distance(pre_BR, t1 ?? pre_BL)
                        let t2 = getIntersectionOfLines(line1: (a:pre_BR,b:pre_TR), line2: (a:pt1,b:unknownPoint2))
                        let d2 = distance(pre_BR, t2 ?? pre_TR)
                        temp_v = CGRect(x: mv.frame.origin.x, y: mv.frame.origin.y, width: d1, height: d2)
                        break
                    case .BL:
                        let unknownPoint1 = CGPoint(x: pre_TL.x-(pre_BL.x-pt1.x), y: pre_TL.y)
                        let unknownPoint2 = CGPoint(x: pre_BR.x, y: pre_BR.y+(pt1.y-pre_BL.y))
                        mv.transform = .identity
                        cpt = mv.center
                        let t1 = getIntersectionOfLines(line1: (a:pre_TR,b:pre_TL), line2: (a:pt1,b:unknownPoint1))
                        let d1 = distance(pre_TR, t1 ?? pre_TL)
                        let t2 = getIntersectionOfLines(line1: (a:pre_TR,b:pre_BR), line2: (a:pt1,b:unknownPoint2))
                        let d2 = distance(pre_TR, t2 ?? pre_BR)
                        temp_v = CGRect(x: mv.frame.origin.x, y: mv.frame.origin.y, width: d1, height: d2)
                        break
                    case .TR:
                        let unknownPoint1 = CGPoint(x: pre_BR.x+(pt1.x-pre_TR.x), y: pre_BR.y)
                        let unknownPoint2 = CGPoint(x: pre_TL.x, y: pre_TL.y-(pre_TR.y-pt1.y))
                        mv.transform = .identity
                        cpt = mv.center
                        let t1 = getIntersectionOfLines(line1: (a:pre_BL,b:pre_BR), line2: (a:pt1,b:unknownPoint1))
                        let d1 = distance(pre_BL, t1 ?? pre_BR)
                        let t2 = getIntersectionOfLines(line1: (a:pre_BL,b:pre_TL), line2: (a:pt1,b:unknownPoint2))
                        let d2 = distance(pre_BL, t2 ?? pre_TL)
                        temp_v = CGRect(x: mv.frame.origin.x, y: mv.frame.origin.y, width: d1, height: d2)
                        break
                    case .BR:
                        let unknownPoint1 = CGPoint(x: pre_BL.x, y: pre_BL.y+(pt1.y-pre_BR.y))
                        let unknownPoint2 = CGPoint(x: pre_TR.x+(pt1.x-pre_BR.x), y: pre_TR.y)
                        mv.transform = .identity
                        cpt = mv.center
                        let t1 = getIntersectionOfLines(line1: (a:pre_TL,b:pre_BL), line2: (a:pt1,b:unknownPoint1))
                        let d1 = distance(pre_TL, t1 ?? pre_BL)
                        let t2 = getIntersectionOfLines(line1: (a:pre_TL,b:pre_TR), line2: (a:pt1,b:unknownPoint2))
                        let d2 = distance(pre_TL, t2 ?? pre_TR)
                        temp_v = CGRect(x: mv.frame.origin.x, y: mv.frame.origin.y, width: d2, height: d1)
                        break
                    case .RULLERPOINT1:
                        if pt1.x > 0 && pt1.x < s.size.width && pt1.y > 0 && pt1.y < s.size.height{
                            mv.rullerpoint1Holder.center = pt1
                            rotator.alpha = 0
                            let p1 =  mv.rullerpoint1Holder.center
                            let p2 =  mv.rullerpoint2Holder.center
                            let p3 =  CGPoint(x: (p1.x/s.size.width) * t.width, y: (p1.y/s.size.height) * t.height)
                            let p4 =  CGPoint(x: (p2.x/s.size.width) * t.width, y: (p2.y/s.size.height) * t.height)
                            mv.markedInfos.drawableDetails.drawableRullerPosition = _2PointsType(point1: p1, point2: p2)
                            mv.markedInfos.originalDetails.originalRullerPosition = _2PointsType(point1: p3, point2: p4)
                            mv.layoutSubviews()
                        }
                        break
                    case .RULLERPOINT2:
                        if pt1.x > 0 && pt1.x < s.size.width && pt1.y > 0 && pt1.y < s.size.height{
                            mv.rullerpoint2Holder.center = pt1
                            rotator.alpha = 0
                            let p1 =  mv.rullerpoint1Holder.center
                            let p2 =  mv.rullerpoint2Holder.center
                            let p3 =  CGPoint(x: (p1.x/s.size.width) * t.width, y: (p1.y/s.size.height) * t.height)
                            let p4 =  CGPoint(x: (p2.x/s.size.width) * t.width, y: (p2.y/s.size.height) * t.height)
                            mv.markedInfos.drawableDetails.drawableRullerPosition = _2PointsType(point1: p1, point2: p2)
                            mv.markedInfos.originalDetails.originalRullerPosition = _2PointsType(point1: p3, point2: p4)
                            mv.layoutSubviews()
                        }
                        break
                    }
                    
                    if mv.frame != temp_v && type != .RULLERPOINT1 && type != .RULLERPOINT2{
                        let storedFrame = mv.frame
                        let storedDrawableframeRect = mv.markedInfos.drawableDetails.drawableframeRect
                        let storedCenter = mv.center
                        mv.frame.size = temp_v.size
                        mv.center = CGPoint(x: cpt.x, y: cpt.y)
                        mv.markedInfos.drawableDetails.drawableframeRect = mv.frame//origin is wrong, frame might not have holder size
                        mv.setAngle(val: mv.markedInfos.drawableDetails.drawableAngle)
                        var cnt = CGPoint(x: cpt.x, y: cpt.y)
                        switch (type)
                        {
                        case .TL:
                            let cp2 = mv.newBottomRight
                            let x = pre_BR.x-cp2.x
                            let y = pre_BR.y-cp2.y
                            cnt = CGPoint(x: cpt.x + x, y: cpt.y + y)
                            break
                        case .BL:
                            let cp2 = mv.newTopRight
                            let x = pre_TR.x-cp2.x
                            let y = pre_TR.y-cp2.y
                            cnt = CGPoint(x: cpt.x + x, y: cpt.y + y)
                            break
                        case .TR:
                            let cp2 = mv.newBottomLeft
                            let x = pre_BL.x-cp2.x
                            let y = pre_BL.y-cp2.y
                            cnt = CGPoint(x: cpt.x + x, y: cpt.y + y)
                            break
                        case .BR:
                            let cp2 = mv.newTopLeft
                            let x = pre_TL.x-cp2.x
                            let y = pre_TL.y-cp2.y
                            cnt = CGPoint(x: cpt.x + x, y: cpt.y + y)
                            break
                        case .RULLERPOINT1:
                            break
                        case .RULLERPOINT2:
                            break
                        }
                        mv.center = cnt
//                        if isInsideBorder(pt : mv.newTopLeft) && isInsideBorder(pt : mv.newTopRight) && isInsideBorder(pt : mv.newBottomLeft) && isInsideBorder(pt : mv.newBottomRight){
//                        }
//                        else{
//                            mv.transform = .identity
//                            mv.markedInfos.drawableDetails.drawableframeRect = storedDrawableframeRect
//                            mv.frame = storedFrame
//                            mv.center =  storedCenter
//                            mv.setAngle(val: mv.markedInfos.drawableDetails.drawableAngle)
//                        }
                        self.borderClosed = false
                    }
                    else{
                        mv.setAngle(val: mv.markedInfos.drawableDetails.drawableAngle)
                        self.borderClosed = false
                    }
                }
                else{
                    mv.setAngle(val: mv.markedInfos.drawableDetails.drawableAngle)
                    self.borderClosed = false
                }
             }
        }
    }
    public func shapeMarkerHolderMoveEnded(pt: CGPoint, type: PLMHolderType, rowIndex: Int, sectionIndex : Int) {
        
        //holders reach here
        if sectionIndex < markedViews.count{
            if rowIndex < markedViews[sectionIndex].markers.count{
                let v = markedViews[sectionIndex].markers[rowIndex]
                v.transform = .identity
                let x = v.frame.origin.x+halfSize
                let y = v.frame.origin.y+halfSize
                let w = v.frame.size.width-size
                let h = v.frame.size.height-size
                let f = delegate?.getImageViewFrame() ?? CGRect.zero
                let p = delegate?.getImage().size ?? CGSize.zero
                let x1 = ((x / f.size.width) * p.width)
                let y1 = ((y / f.size.height) * p.height)
                let w1 = ((w / f.size.width) * p.width)
                let h1 = ((h / f.size.height) * p.height)
                markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableframeRect = v.frame
                markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)
                markedViews[sectionIndex].markers[rowIndex].setAngle(val: markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableAngle)
                
                if markedViews[sectionIndex].markers[rowIndex].markedInfos.type == .PATH || markedViews[sectionIndex].markers[rowIndex].markedInfos.type == .HIGHLIGHTER{
                    let wd = markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.size.width
                    let ht = markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.size.height
//                    if markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalLayerPath == ""{
                        var str = ""
                        for i in 0..<markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableLayerPoints.count
                        {
                            let ptrX = (markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
                            let ptrY = (markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
                            if i == 0
                            {
                                str = "M \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                            }
                            else{
                                str = "\(str) L \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                            }
                        }
                        markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalLayerPath = str
//                    }
                }
            }
            if markedViews[sectionIndex].state == .DRAFT
            {
                let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[sectionIndex].markers[rowIndex].markedInfos], lastUpdated: "", state: .DRAFT)
                PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
            }
        }
    }
    public func shapeMarkerHolderMoveEnded(pt: CGPoint, rowIndex: Int, sectionIndex: Int) {
        if sectionIndex < markedViews.count{
            if rowIndex < markedViews[sectionIndex].markers.count{
                let v = markedViews[sectionIndex].markers[rowIndex]
    //            if v.frame.origin.x < 0{
    //                v.frame.origin.x = 0
    //            }
    //            if v.frame.origin.y < 0{
    //                v.frame.origin.y = 0
    //            }
    //            if v.frame.origin.y + v.frame.size.height > imageHolderFrame.size.height{
    //                v.frame.origin.y = imageHolderFrame.size.height - v.frame.size.height
    //            }
    //            if v.frame.origin.x + v.frame.size.width > imageHolderFrame.size.width{
    //                v.frame.origin.x = imageHolderFrame.size.width - v.frame.size.width
    //            }
                v.transform = .identity
                let x = v.frame.origin.x+halfSize
                let y = v.frame.origin.y+halfSize
                let w = v.frame.size.width-size
                let h = v.frame.size.height-size
                let f = delegate?.getImageViewFrame() ?? CGRect.zero
                let p = delegate?.getImage().size ?? CGSize.zero
                let x1 = ((x / f.size.width) * p.width)
                let y1 = ((y / f.size.height) * p.height)
                let w1 = ((w / f.size.width) * p.width)
                let h1 = ((h / f.size.height) * p.height)
                markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableframeRect = v.frame
                markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)
                markedViews[sectionIndex].markers[rowIndex].setAngle(val: markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableAngle)
                
                if markedViews[sectionIndex].markers[rowIndex].markedInfos.type == .PATH || markedViews[sectionIndex].markers[rowIndex].markedInfos.type == .HIGHLIGHTER{
                    let wd = markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.size.width
                    let ht = markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.size.height
//                    if markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalLayerPath == ""{
                        var str = ""
                        for i in 0..<markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableLayerPoints.count
                        {
                            let ptrX = (markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
                            let ptrY = (markedViews[sectionIndex].markers[rowIndex].markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
                            if i == 0
                            {
                                str = "M \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                            }
                            else{
                                str = "\(str) L \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                            }
                        }
                        markedViews[sectionIndex].markers[rowIndex].markedInfos.originalDetails.originalLayerPath = str
//                    }
                }
                
                if markedViews[sectionIndex].state == .DRAFT
                {
                    let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : delegate?.getSheetId() ?? "", sheetName: "", markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markedViews[sectionIndex].markers[rowIndex].markedInfos], lastUpdated: "", state: .DRAFT)
                    PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
                }
            }
        }
    }
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    public func setselectedRullerSize(dist:CGFloat)
    {
        delegate?.setselectedRullerSize(dist:dist)
    }
    public func hideColorBar()
    {
        delegate?.hideColorBar()
    }
    public func getImageSize() -> CGSize {
        return delegate?.getImage().size ?? .zero
    }
    public func getImageViewFrame() -> CGRect {
        return delegate?.getImageViewFrame() ?? .zero
    }
    public func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> CGPoint? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return CGPoint(x: intersectX, y: intersectY)
            }
        }

        // lines don't cross
        return nil
    }
    public func getIntersectionOfLines(line1: (a: CGPoint, b: CGPoint), line2: (a: CGPoint, b: CGPoint)) -> CGPoint? {

        let distance = (line1.b.x - line1.a.x) * (line2.b.y - line2.a.y) - (line1.b.y - line1.a.y) * (line2.b.x - line2.a.x)
        if distance == 0 {
            print("error, parallel lines")
            return nil
        }

        let u = ((line2.a.x - line1.a.x) * (line2.b.y - line2.a.y) - (line2.a.y - line1.a.y) * (line2.b.x - line2.a.x)) / distance
//        let v = ((line2.a.x - line1.a.x) * (line1.b.y - line1.a.y) - (line2.a.y - line1.a.y) * (line1.b.x - line1.a.x)) / distance

//        if (u < 0.0 || u > 1.0) {
//            print("error, intersection not inside line1")
//            return nil
//        }
//        if (v < 0.0 || v > 1.0) {
//            print("error, intersection not inside line2")
//            return nil
//        }

        return CGPoint(x: line1.a.x + u * (line1.b.x - line1.a.x), y: line1.a.y + u * (line1.b.y - line1.a.y))
    }
    public func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    public func getSheetScale()->CGSize
    {
        return delegate?.getSheetScale() ?? .zero
    }
    public func getSheetScaleUnit()->String
    {
        return delegate?.getSheetScaleUnit() ?? ""
    }
    public func getSheetId()->String
    {
        return delegate?.getSheetId() ?? ""
    }
    public func getSheetName()->String
    {
        return delegate?.getSheetName() ?? ""
    }
}
extension PLMMarkedLayers
{
    
    @objc public func handleRotationGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            rotator.alpha = 0
            break
        case .changed:
            if gestureRecognizer.view?.layer.backgroundColor != UIColor.clear.cgColor{
                let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview))
                
                if markedViews.count > selectedGroupIndex && selectedGroupIndex >= 0
                {
                    if markedViews[selectedGroupIndex].markers.count > selectedMarkerIndex && selectedMarkerIndex >= 0
                    {
                        let v = markedViews[selectedGroupIndex].markers[selectedMarkerIndex]
                        let deg = v.getAngle(markerFrame: v.frame, touch: pt)
                        print("frame =", v.frame," location = ",pt," degrees = ",deg)
                        v.markedInfos.drawableDetails.drawableAngle = deg
                        v.setAngle(val: deg)
                        
    //                    v.reset(strokeWidth: v.drawableDefaultCollection.strokeWidth, strokeColor: "red", angle: deg)
                    }
                }
            }

            break
        case .possible:
            break
        case .ended:
            rotator.alpha = 1
            attachRotatorToSelectedMarker()
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }

}
extension UIImageView {
    func PLMgetImageAspectCropFrame(for image: UIImage, borderDisplacement : CGFloat) -> CGRect {
        let imageRatio = ((self.image?.size.width)! / (self.image?.size.height)!)
        let viewRatio = self.frame.size.width / self.frame.size.height
        if imageRatio > viewRatio
        {
            let ratio = (self.frame.size.width) / (self.image?.size.width)!
            let hth = (self.image?.size.height)! * ratio
            let y = (self.frame.size.height * 0.5) - (hth * 0.5)
             return CGRect(x: 0 - borderDisplacement, y: (y) - borderDisplacement, width: self.frame.size.width + (borderDisplacement * 2), height: hth + (borderDisplacement * 2))
        }
        else{
            let ratio = (self.frame.size.height) / (self.image?.size.height)!
            let wth = (self.image?.size.width)! * ratio
            let x = (self.frame.size.width * 0.5) - (wth * 0.5)
            return CGRect(x: (x) - borderDisplacement, y: 0 - borderDisplacement, width: wth + (borderDisplacement * 2), height: self.frame.size.height + (borderDisplacement * 2))
        }
    }
}
extension UIImage
{
    func resizeImageForRender(newsize:CGSize) -> UIImage?
    {
        let scaledSize = CGSize(width: newsize.width, height: newsize.height)
        
        if(scaledSize.width < scaledSize.height){
            let img = self.resizeCG(size: CGSize(width: scaledSize.height, height: scaledSize.width))
            return img
        }
        else{
            let img = self.resizeCG(size: scaledSize)
            return img
        }
    }
    func resizeCG(size:CGSize) -> UIImage? {
        guard let colorSpace = self.cgImage?.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: (self.cgImage?.alphaInfo.rawValue)!) else { return nil }
        context.interpolationQuality = .high
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: Int(size.width), height: Int(size.height)))
        return UIImage(cgImage: (context.makeImage())!, scale: 0.0, orientation: self.imageOrientation)
    }
}

extension CGFloat
{
    func toRadians() -> CGFloat { return self * .pi / 180 }
}
extension UIView {
    /// Helper to get pre transform frame
    var originalFrame: CGRect {
        let currentTransform = transform
        transform = .identity
        let originalFrame = frame
        transform = currentTransform
        return originalFrame
    }

    /// Helper to get point offset from center
    func centerOffset(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - center.x, y: point.y - center.y)
    }

    /// Helper to get point back relative to center
    func pointRelativeToCenter(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + center.x, y: point.y + center.y)
    }

    /// Helper to get point relative to transformed coords
    func newPointInView(_ point: CGPoint) -> CGPoint {
        // get offset from center
        let offset = centerOffset(point)
        // get transformed point
        let transformedPoint = offset.applying(transform)
        // make relative to center
        return pointRelativeToCenter(transformedPoint)
    }

    var newTopLeft: CGPoint {
        return newPointInView(originalFrame.origin)
    }

    var newTopRight: CGPoint {
        var point = originalFrame.origin
        point.x += originalFrame.width
        return newPointInView(point)
    }

    var newBottomLeft: CGPoint {
        var point = originalFrame.origin
        point.y += originalFrame.height
        return newPointInView(point)
    }

    var newBottomRight: CGPoint {
        var point = originalFrame.origin
        point.x += originalFrame.width
        point.y += originalFrame.height
        return newPointInView(point)
    }
}
