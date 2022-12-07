//
//  PLMPlansListingDataSource.swift
//  PlanMarkup
//
//  Created by SIMON on 17/01/22.
//

import Foundation
import SwiftUI
import PDFKit
import AppearanceFramework
protocol PLMPlansListingDataSourceDelegate : AnyObject {
}
public class PLMPlansListingDataSource: ObservableObject  {
    
    @Published public var shouldMarkedSheetBepresented = false
    @Published public var shouldSheetBepresented = false
    @Published var projectListPopover: Bool = false
   
    @Published var installAlert:Bool = false
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @Published var sheets = [sheetsListType]()
    {
        didSet
        {
            sheetsWithVersions.removeAll()
            for i in 0..<sheets.count
            {
                var found = false
                for j in 0..<sheetsWithVersions.count
                {
                    if sheetsWithVersions[j].title == sheets[i].title
                    {
                        found = true
                        let a = sheetsWithVersions[j].sheetsListVersionDetails
                        if a.count > 0
                        {
                            if a[0].versionnumber < sheets[i].versionnumber
                            {
                                let a = sheetsListVersionDetailsType(sheetId: sheets[i].sheetId, thumbnailImage: sheets[i].thumbnailImage, thumbnailCompressedImage: sheets[i].thumbnailCompressedImage, OriginalImage: sheets[i].OriginalImage, versionnumber: sheets[i].versionnumber, creater_userID: sheets[i].creater_userID, lastupdated: sheets[i].lastupdated)
                                sheetsWithVersions[j].sheetsListVersionDetails.insert(a, at: 0)
                            }
                            else{
                                let a = sheetsListVersionDetailsType(sheetId: sheets[i].sheetId, thumbnailImage: sheets[i].thumbnailImage, thumbnailCompressedImage: sheets[i].thumbnailCompressedImage, OriginalImage: sheets[i].OriginalImage, versionnumber: sheets[i].versionnumber, creater_userID: sheets[i].creater_userID, lastupdated: sheets[i].lastupdated)
                                sheetsWithVersions[j].sheetsListVersionDetails.append(a)
                            }
                        }
                        
                    }
                }
                if !found{
                    let a = sheetsListVersionDetailsType(sheetId: sheets[i].sheetId, thumbnailImage: sheets[i].thumbnailImage, thumbnailCompressedImage: sheets[i].thumbnailCompressedImage, OriginalImage: sheets[i].OriginalImage, versionnumber: sheets[i].versionnumber, creater_userID: sheets[i].creater_userID, lastupdated: sheets[i].lastupdated)
                    let b = sheetsListWithVersionType(sheetsListVersionDetails: [a], title: sheets[i].title, tag: sheets[i].tag, isAvailableOffline: sheets[i].isAvailableOffline)
                    sheetsWithVersions.append(b)
                }
            }
        }
    }

    @Published var sheetsWithVersions = [sheetsListWithVersionType]()
    {
        didSet
        {
            print("all version array",sheetsWithVersions)
        }
    }
    @Published public var selectedSheetForVersionListView : sheetsListWithVersionType? = nil
    @Published public var showSelectedSheetForVersionView = false
    @Published var sheetViewMode = PLMViewMode.thumbnail
    @Published var savedMarkups = [savedMarkupsType]()
    @Published var markupsViewMode = PLMViewMode.thumbnail
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public var sheetViewController : PLMSheetController?
    @Published var attachmenttoAddSheetPickerShown = false
    {
        didSet{
            
        }
    }
    @Published var imagePickerType = AttachmentPickerType.none
    
    var selectedasSheet: UIImage?
    {
        didSet
        {
            if selectedasSheet != nil
            {
                addImage(img: selectedasSheet!)
            }
        }
    }
    public var selectedVideo: Data?
    weak var presenterDelegate : PLMPlansListingDataSourceDelegate?
    public init()
    {
        self.fetchSheetsComputedList(projectID: "")
    }
    func fetchSheetsComputedList(projectID: String)
    {
        self.sheets.removeAll()
        let t = sheetsListType(sheetId: "0", thumbnailImage:Data(), thumbnailCompressedImage: UIImage(),OriginalImage : Data() , title: "NA", versionnumber: 0, creater_userID: "", tag: "", lastupdated: Date(), isAvailableOffline: false)
        PLMDBHandler.shared.readSheetsListType(sheetsListEntry: t, neededProjectID: projectID, tableName: PLMDBProcessor.SheetListingTypeTableName, completion : { (sheetstempDB,newEntrySheetDB) in
            DispatchQueue.main.async {
                var sheetstemp = sheetstempDB
                for l in 0..<sheetstemp.count
                {
                    let img = UIImage(data: sheetstemp[l].thumbnailImage)!
                    let maxThumbNailSize : CGFloat = 200
                    if img.size.width > maxThumbNailSize || img.size.height > maxThumbNailSize
                    {
                        let scale1 = (img.size.width >  img.size.height ? maxThumbNailSize/img.size.width :  maxThumbNailSize/img.size.height)
                        let size = CGSize(width: img.size.width * scale1, height: img.size.height * scale1)//(img).size.applying(CGAffineTransform(scaleX: 0.1, y: 0.1))
                        let hasAlpha = false
                        let scale: CGFloat = 0.0
                        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                        (img).draw(in: CGRect(origin: .zero, size: size))

                        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                        sheetstemp[l].thumbnailCompressedImage = scaledImage ?? dummyImage2
                        UIGraphicsEndImageContext()
                    }
                    else{
                        sheetstemp[l].thumbnailCompressedImage = img
                    }
                }
                for l in 0..<sheetstemp.count
                {
                    for m in l..<sheetstemp.count
                    {
                        if sheetstemp[l].lastupdated < sheetstemp[m].lastupdated
                        {
                            let o = sheetstemp[l]
                            sheetstemp[l] = sheetstemp[m]
                            sheetstemp[m] = o
                        }
                    }
                }
                self.sheets = sheetstemp
            }
        })
    }
    
}
public extension PLMPlansListingDataSource{
    
    
 
}
extension PLMPlansListingDataSource{
    
    func sinOf(degrees: Double) -> CGFloat {
        return CGFloat(sin(degrees.degrees))
    }
    func cosOf(degrees: Double) -> CGFloat {
        return CGFloat(cos(degrees.degrees))
    }
    func rotatedPoint(centre: coordinates, point: coordinates, degree: Double)->coordinates{
        let revisedPoints = self.pointsWRTOrigin(centre: centre, points: point)
        let sin = sinOf(degrees: -degree)
        let cos = cosOf(degrees: -degree)
        let x = (revisedPoints.x * cos) - (revisedPoints.y * sin)
        let y = (revisedPoints.x * sin) + (revisedPoints.y * cos)
        let finalX = x + centre.x
        let finalY = y + centre.y
        return coordinates(x: finalX, y: finalY)
    }
    func pointsWRTOrigin(centre: coordinates, points: coordinates)-> coordinates{
        let x = points.x - centre.x
        let y = points.y - centre.y
        return coordinates(x: x, y: y)
    }
    func findTopLeft(width: CGFloat,Height: CGFloat,point: coordinates,degree: CGFloat)-> coordinates{
        let centreX = (width/2)
        let centreY = (Height/2)
        let a = rotatedPoint(centre: coordinates(x: centreX, y: centreY ), point: coordinates(x: 0, y: 0), degree: degree)
        print(a)
        let actualX = point.x - a.x
        let actualY = point.y - a.y
        return coordinates(x: actualX , y: actualY)
    }
    func fetchMarkersOnSheet(projectID: String, sheetID: String, completion: @escaping (Bool) -> ())
    {
//        if PLMPresenter.shared.isConnectedToNetwork{
//        self.plansListRequestHandler.fetchMarkersOnSheet(projectID: "\(projectID)", sheetID: sheetID ,completion : { (datauncoded,data, Resp, success, thisProjectId) in
//            DispatchQueue.main.async {
//                guard let details = Resp else { return }
//                var savedMarkupsTemp = [savedMarkupsType]()
//                for markedSheet in details
//                {
//                    guard let detail = markedSheet as? Dictionary<String, Any> else { return }
//                    
//                    guard let sheet_code = detail["sheet_code"] as? String else { return }
//                    guard let plm_name = detail["plm_name"] as? String else { return }
//                    guard let app_model_name = detail["app_model_name"] as? String else { return }
//                    guard let plm_createdon = detail["plm_createdon"] as? String else { return }
//                    guard let plm_createdby = detail["plm_createdby"] as? Dictionary<String, Any> else { return }
//                    guard let user_id = plm_createdby["user_id"] as? String else { return }
//                    guard let emp_last_name = plm_createdby["emp_last_name"] as? String else { return }
//                    guard let emp_first_name = plm_createdby["emp_first_name"] as? String else { return }
//                    if detail["plm_markup"] as? Dictionary<String, Any> != nil{
//                    guard let plm_markup = detail["plm_markup"] as? Dictionary<String, Any> else { return }
//                    guard let plm_markupNrml = plm_markup["normal"] as? NSMutableArray else { return }
//                    var markedInfo = [markedInfoType]()
//                    for item in plm_markupNrml
//                    {
//                        
//                        guard let itemdetails = item as? Dictionary<String, Any> else { return }
//                        print("type of marker = ",itemdetails)
//                        if itemdetails.count > 0{
//                            guard let x = itemdetails["top"] as? CGFloat else { return }
//                            guard let y = itemdetails["left"] as? CGFloat else { return }
//                            guard let wdt = itemdetails["width"] as? CGFloat else { return }
//                            guard let ht = itemdetails["height"] as? CGFloat else { return }
//                            var scaleX : CGFloat = 1
//                            if itemdetails["scaleX"] != nil
//                            {
//                                scaleX = itemdetails["scaleX"] as! CGFloat
//                            }
//                            var scaleY : CGFloat = 1
//                            if itemdetails["scaleY"] != nil
//                            {
//                                scaleY = itemdetails["scaleY"] as! CGFloat
//                            }
//                            var strokeWidth : CGFloat = 0
//                            if itemdetails["strokeWidth"] != nil
//                            {
//                                strokeWidth = itemdetails["strokeWidth"] as! CGFloat
//                            }
//                            var strokeClr = ""//This is wrong in web "hex or RGB"
//                            if itemdetails["stroke"] != nil
//                            {
//                                if itemdetails["stroke"] as? String != nil{
//                                    strokeClr = itemdetails["stroke"] as! String
//                                }
//                            }
//                            var fillClr = ""//This is wrong in web "hex or RGB" //gettinf 255 for opacity/alpha
//                            if itemdetails["fill"] != nil
//                            {
//                                if itemdetails["fill"] as? String != nil{
//                                    fillClr = itemdetails["fill"] as! String
//                                }
//                            }
//
//                                print("color for fill : ",fillClr,plm_name)
//                                print("color for stroke : ",strokeClr,plm_name)
//                            
//                            var angle : CGFloat = 0
//                            if itemdetails["angle"] != nil
//                            {
//                                if itemdetails["angle"] as? CGFloat != nil{
//                                    angle = itemdetails["angle"] as! CGFloat
//                                }
//                            }
//                            
//                            var layerName = ""
//                            if itemdetails["layerName"] != nil
//                            {
//                                if itemdetails["layerName"] as? String != nil{
//                                    layerName = itemdetails["layerName"] as! String
//                                }
//                            }
//                            let r =  CGRect(x: x, y: y, width: (wdt * scaleX) + (strokeWidth * 1), height:(ht * scaleY + (strokeWidth * 1)))
//                            var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//                            if angle != 0{
//                                let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: x, y: y), degree: angle)
//                                s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//                            }else{
//                                s = r
//                            }
//                            guard let type = itemdetails["type"] as? String else { return }
//                            if type == "rect" || type == "circle"
//                            {
//
//                                let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:strokeClr), drawableFillColor: self.getColor(clrstr: fillClr), drawableAngle: angle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                let b = originalMarkerInfoType(originalFrameRect: s, originalStrokeWidth: strokeWidth, originalStrokeColor: self.getColor(clrstr:strokeClr), originalFillColor: self.getColor(clrstr: fillClr), originalAngle: angle, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                                let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: type == "rect" ? .RECT : .ROUND, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//
//                                markedInfo.append(marker)
//                            }
//                            else if type == "i-text"
//                            {
////                                if itemdetails["stroke"] != nil//This is wrong in web
////                                {
////                                    if itemdetails["fill"] as? String != nil{
////                                        strokeClr = itemdetails["fill"] as! String
////                                        fillClr = ""
////                                    }
////                                }
//                                var text = ""
//                                if itemdetails["text"] != nil
//                                {
//                                    text = itemdetails["text"] as! String
//                                }
//                                let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:strokeClr), drawableFillColor: self.getColor(clrstr: fillClr), drawableAngle: angle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                let b = originalMarkerInfoType(originalFrameRect: s, originalStrokeWidth: strokeWidth, originalStrokeColor: self.getColor(clrstr:strokeClr), originalFillColor: self.getColor(clrstr: fillClr), originalAngle: angle, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                                let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .TEXT, drawableDetails: a, originalDetails: b, text: text, image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//
//                                markedInfo.append(marker)
//                            }
//                            else if type == "cloud"
//                            {
//                                let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr: strokeClr), drawableFillColor: self.getColor(clrstr: fillClr), drawableAngle: angle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                let b = originalMarkerInfoType(originalFrameRect: s, originalStrokeWidth: strokeWidth, originalStrokeColor: self.getColor(clrstr: strokeClr), originalFillColor: self.getColor(clrstr: fillClr), originalAngle: angle, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                                let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .ARCS, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//
//                                markedInfo.append(marker)
//                            }
//                            else if type == "path" || type == "arrow"
//                            {
//
//                                var path = ""
//                                if itemdetails["svgSrc"] != nil
//                                {
//                                    path = itemdetails["svgSrc"] as! String
//                                }
//                                if !path.contains("-") && type != "arrow"{
//                                    
//                                    if layerName.lowercased().contains("highlighter")
//                                    {
//    //                                        let a = markedInfoType(type: "highlighter", frameRect: CGRect(x: x - (strokeWidth * 0.5), y: y - (strokeWidth * 0.5), width: (wdt * scaleX) + (strokeWidth * 1), height:(ht * scaleY) + (strokeWidth * 1)), strokeWidth: strokeWidth, text: "", path: path, strokeColor: strokeClr,angle : angle, image: UIImage(systemName: "camera")!, linePoint: [])
//    //                                        markedInfo.append(a)
//                                        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:strokeClr), drawableFillColor: self.getColor(clrstr: fillClr), drawableAngle: angle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                        let b = originalMarkerInfoType(originalFrameRect: s, originalStrokeWidth: strokeWidth, originalStrokeColor: self.getColor(clrstr:strokeClr), originalFillColor: self.getColor(clrstr: fillClr), originalAngle: angle, originalLayerPoints: [], originalLayerPath: path,originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                        let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                                        let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .HIGHLIGHTER, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//                                        
//                                            markedInfo.append(marker)
//                                    }
//                                    else{
//                                        
//                                        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:strokeClr), drawableFillColor: self.getColor(clrstr: fillClr), drawableAngle: angle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                        let b = originalMarkerInfoType(originalFrameRect: s, originalStrokeWidth: strokeWidth, originalStrokeColor: self.getColor(clrstr:strokeClr), originalFillColor: self.getColor(clrstr: fillClr), originalAngle: angle, originalLayerPoints: [], originalLayerPath: path,originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                        let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                                        let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .PATH, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//                                        
//                                            markedInfo.append(marker)
//                                    }
//                                }
//                                else{
////                                    if itemdetails["stroke"] != nil//This is wrong in web
////                                    {
////                                        if itemdetails["fill"] as? String != nil{
////                                            strokeClr = itemdetails["fill"] as! String
////                                            fillClr = ""
////                                        }
////                                    }
//                                    
//                                    let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:strokeClr), drawableFillColor: self.getColor(clrstr: strokeClr), drawableAngle: angle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                    let b = originalMarkerInfoType(originalFrameRect: s, originalStrokeWidth: strokeWidth, originalStrokeColor: self.getColor(clrstr:strokeClr), originalFillColor: self.getColor(clrstr:strokeClr), originalAngle: angle, originalLayerPoints: [], originalLayerPath: path,originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                                    let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                                    let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .ARROW, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//                                    
//                                        markedInfo.append(marker)
//                                }
//                            }
//                        }
//                    }
//                    guard let plm_compound_elements = plm_markup["compound_elements"] as? Dictionary<String, Any> else { return }
//                    var plm_camera_elements = Dictionary<String, Any>()
//                    if plm_compound_elements["camera"] as? Dictionary<String, Any> != nil{
//                        plm_camera_elements = plm_compound_elements["camera"] as! Dictionary<String, Any>
//                    }
//                    for key in plm_camera_elements.keys
//                    {
//                        guard let element = plm_camera_elements[key] as? Dictionary<String, Any> else { return }
//                        guard let cam_object = element["obj"] as? Dictionary<String, Any> else { return }
//                        guard let cam_data = element["data"] as? Dictionary<String, Any> else { return }
//                        guard let urlId = cam_data["urlId"] as? String else { return }
//                        
//                        guard let x = cam_object["top"] as? CGFloat else { return }
//                        guard let y = cam_object["left"] as? CGFloat else { return }
//                        guard let wdt = cam_object["width"] as? CGFloat else { return }
//                        guard let ht = cam_object["height"] as? CGFloat else { return }
//                        var scaleX : CGFloat = 1
//                        if cam_object["scaleX"] != nil
//                        {
//                            scaleX = cam_object["scaleX"] as! CGFloat
//                        }
//                        var scaleY : CGFloat = 1
//                        if cam_object["scaleY"] != nil
//                        {
//                            scaleY = cam_object["scaleY"] as! CGFloat
//                        }
//                        var strokeWidth : CGFloat = 0
//                        if cam_object["strokeWidth"] != nil
//                        {
//                            strokeWidth = cam_object["strokeWidth"] as! CGFloat
//                        }
//                        
//                        let r =  CGRect(x: x - (strokeWidth * 0.5), y: y - (strokeWidth * 0.5), width: (wdt * scaleX) + (strokeWidth * 1), height:(ht * scaleY) + (strokeWidth * 1))
//                        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: clearColor, drawableFillColor: clearColor, drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                        let b = originalMarkerInfoType(originalFrameRect: r, originalStrokeWidth: strokeWidth, originalStrokeColor: clearColor, originalFillColor: clearColor, originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                        let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: urlId)
//                        let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .IMAGE, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//
//                        markedInfo.append(marker)
//                        
//                        self.getAttachedImagePlan(markupID: sheetID, objectID: urlId, completion: {(success,image,respurlid) in
//                            DispatchQueue.main.async {
//                                for j in 0..<self.savedMarkups.count
//                                {
//                                    for k in 0..<self.savedMarkups[j].markedInfos.count
//                                    {
//                                        if self.savedMarkups[j].markedInfos[k].image.urlID == respurlid
//                                        {
//                                            self.savedMarkups[j].markedInfos[k].image.image = image
//                                        }
//                                    }
//                                }
//                                if self.sheetViewController != nil{
//                                    for p in 0..<self.sheetViewController!.sheetBaseView.markerLayer.markedViews.count
//                                    {
//                                        for q in 0..<self.sheetViewController!.sheetBaseView.markerLayer.markedViews[p].markers.count
//                                        {
//                                            if self.sheetViewController!.sheetBaseView.markerLayer.markedViews[p].markers[q].markedInfos.image.urlID == respurlid
//                                            {
//                                                self.sheetViewController!.sheetBaseView.markerLayer.markedViews[p].markers[q].markedInfos.image.image = image
//                                                if self.sheetViewController!.sheetBaseView.markerLayer.markedViews[p].markers[q].markedInfos.type == .IMAGE
//                                                {
//                                                    (self.sheetViewController!.sheetBaseView.markerLayer.markedViews[p].markers[q] as! PLMImageMarker).rect.image = image
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        })
//
//                    }
//                    var plm_line_elements = Dictionary<String, Any>()
//                    if plm_compound_elements["lines"] as? Dictionary<String, Any> != nil{
//                        plm_line_elements = plm_compound_elements["lines"] as! Dictionary<String, Any>
//                    }
//                    for key in plm_line_elements.keys
//                    {
//                        guard let element = plm_line_elements[key] as? Dictionary<String, Any> else { return }
//                        guard let x1 = element["x1"] as? CGFloat else { return }
//                        guard let y1 = element["y1"] as? CGFloat else { return }
//                        guard let x2 = element["x2"] as? CGFloat else { return }
//                        guard let y2 = element["y2"] as? CGFloat else { return }
//                        
//                        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor:redColor, drawableFillColor: clearColor, drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
//                        let b = originalMarkerInfoType(originalFrameRect: .zero, originalStrokeWidth: 1, originalStrokeColor: redColor, originalFillColor: clearColor, originalAngle: 0, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: CGPoint(x: x1, y: y1), point2: CGPoint(x: x2, y: y2)))
//                        let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
//                        let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type: .RULLER, drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)
//                        
//                            markedInfo.append(marker)
//                    }
//                    var plm_id = ""
//                    if detail["plm_id"] != nil
//                    {
//                        if detail["plm_id"] as? String != nil
//                        {
//                            plm_id = detail["plm_id"] as! String
//                        }
//                        else{
//                            plm_id = String(detail["plm_id"] as! Int)
//                        }
//                    }
//                    
//
//                        let t = savedMarkupsType(typeStr: app_model_name, plmID: plm_id, sheetID: sheetID, sheetName: sheet_code, markupName: plm_name, date: plm_createdon, createdByUserID: user_id, createdByUserName : "\(emp_first_name) \(emp_last_name)", access: "some access", markedInfos: markedInfo, lastUpdated: "", state: .PUBLISHED)
//                    savedMarkupsTemp.append(t)
//                    }
//                }
//                for savedMarkerGroup in savedMarkupsTemp {
//                    PLMDBHandler.shared.readMarkersListReturnPLM_ID_Present(neededProjectID: projectID,neededplmID: savedMarkerGroup.plmID, tableName: PLMDBProcessor.MarkupsListingTypeTableName, completion : { (present) in
//                        if !present{
//                            for savedMarker in savedMarkerGroup.markedInfos {
//                                let t = savedMarkupsType(typeStr: savedMarkerGroup.typeStr, plmID: savedMarkerGroup.plmID,sheetID : sheetID, sheetName: savedMarkerGroup.sheetName, markupName: savedMarkerGroup.markupName, date: savedMarkerGroup.date, createdByUserID: savedMarkerGroup.createdByUserID, createdByUserName : savedMarkerGroup.createdByUserName, access: savedMarkerGroup.access, markedInfos: [savedMarker], lastUpdated: savedMarkerGroup.lastUpdated, state: .PUBLISHED)
//                                PLMDBProcessor.shared.storeMarkupsListingType(projectId: thisProjectId, marker: t)
//                            }
//                        }
//                    })
//                }
//                self.savedMarkups.removeAll()
//                PLMDBHandler.shared.readMarkersListType(neededProjectID: projectID, neededsheetID: sheetID, tableName: PLMDBProcessor.MarkupsListingTypeTableName, completion : { (savedMarkupsTemp) in
//                    DispatchQueue.main.async {
//                        self.savedMarkups = savedMarkupsTemp
//                        completion(true)
//                    }
//                })
//            }
//           
//        })
//        }
//        else{
            self.savedMarkups.removeAll()
            PLMDBHandler.shared.readMarkersListType(neededProjectID: projectID, neededsheetID: sheetID, tableName: PLMDBProcessor.MarkupsListingTypeTableName, completion : { (savedMarkupsTemp) in
                DispatchQueue.main.async {
                    self.savedMarkups = savedMarkupsTemp
                    completion(true)
                }
            })
//        }
    }
    func addnewMarupGroupData(parameters : [String : Any], markupID : String)
    {
//        if selectedProject?.projectID != nil {
//            plansListRequestHandler.sendNewPlanMarkupServer(parameters: parameters, markupID: "\(markupID)",completion : { (datauncoded,data, Resp, success) in
//                DispatchQueue.main.async {
//                    if PLMPresenter.shared.appInstallationType != .SELF{
//                        let t1 = self.sheetViewController?.sheetBaseView.markerLayer.asImage()
//                        let t2 = self.sheetViewController?.sheetBaseView.planSheetImageMasterView.imageCntrlr.imgPhotoHolder.asImage()
//                        if t1 != nil && t2 != nil {
//                            let bottomImage = self.sheetViewController?.sheetBaseView.planSheetImageMasterView.imageCntrlr.imgPhotoHolder.image
//                            let topImage = t1!
//
//                            let size = t2!.size
//                            UIGraphicsBeginImageContext(size)
//
//                            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//                            bottomImage!.draw(in: areaSize)
//
//                            topImage.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
//
//                            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//                            UIGraphicsEndImageContext()
//                            PLMPresenter.shared.presenterAppDelegate?.planSheetServerActionComplete(image: newImage)
//                            PLMPresenter.shared.plansListingDataSource.shouldSheetBepresented = false
//                            PLMPresenter.shared.shouldShowPlanAttachmentPicker = false
//                        }
//                    }
//                    PLMPresenter.shared.showMasterProgress = false
//                    for i in 0..<self.sheetViewController!.sheetBaseView.markerLayer.markedViews.count{
//                        let m = self.sheetViewController!.sheetBaseView.markerLayer.markedViews[i]
//                        for j in 0..<m.markers.count{
//                            let m2 = m.markers[j]
//                            PLMDBHandler.shared.deleteMarker(neededProjectID: PLMPresenter.shared.selectedProject!.projectID, thisMarkerID: m2.markedInfos.thisMarkerID, tableName: PLMDBProcessor.MarkupsListingTypeTableName, completion : {(success) in
//
//                            })
//                        }
//                    }
//                    PLMPresenter.shared.sheetDataSource.sheetViewController?.sheetBaseView.clearAll()
//                    PLMPresenter.shared.sheetDataSource.selectedThumbnail = PLMPresenter.shared.sheetDataSource.selectedThumbnail
//                    PLMPresenter.shared.sheetDataSource.sheetViewController?.sheetBaseView.selectedThumbnail = PLMPresenter.shared.sheetDataSource.selectedThumbnail
//                    PLMPresenter.shared.sheetDataSource.sheetViewController?.sheetBaseView.updateData()
//                }
//            })
//        }
    }
    func attachImageToPlan(imageData : Data?, markupID : String, completion: @escaping (Bool,String,String) -> ())
    {
//        plansListRequestHandler.attachImageToPlan(imageData: imageData, markupID: markupID, completion : { (success,id,url) in
//            completion(success,id,url)
//        })
    }
//    func getColor(clrstr : UIColor)->RGB_O_ColorType
//    {
//        return RGB_O_ColorType(redValue: CGFloat(clrstr.rgb()?.red ?? 255), greenValue:  CGFloat(clrstr.rgb()?.green ?? 255), blueValue:  CGFloat(clrstr.rgb()?.blue ?? 255), opacity: CGFloat(clrstr.rgb()?.alpha ?? 1))
//    }
    func getColor(clrstr : String)->RGB_O_ColorType
    {
        let str = clrstr.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
        let clrar = str.components(separatedBy: ",")
        if clrar.count == 4
        {
            return RGB_O_ColorType(redValue: CGFloat(Double(clrar[0]) ?? 0), greenValue: CGFloat(Double(clrar[1]) ?? 0), blueValue:  CGFloat(Double(clrar[2]) ?? 0), opacity: CGFloat(Float(clrar[3]) ?? 0))
        }
        else{
            return RGB_O_ColorType(redValue: 255, greenValue: 255, blueValue:  255, opacity: 1)
        }
    }
    func getAttachedImagePlan(markupID: String, objectID: String, completion: @escaping (Bool,UIImage,String) -> ())
    {
//        plansListRequestHandler.downloadplanAttachedImageUrlDetails(markupID: markupID, objectID: objectID, completion: { [self](data,json, array, success) in
//            if success{
//            DispatchQueue.main.async {
//                guard let details = json else { return }
//                guard let profilimg = details["file_urls"] as? NSMutableArray else { return }
//                if profilimg.count > 0
//                {
//                    guard let profilimgarray = profilimg[profilimg.count - 1] as? Dictionary<String, Any> else { return }
//                    guard let profilimgLink = profilimgarray["url"] as? String else { return }
//
//                    self.plansListRequestHandler.downloadImage(url: profilimgLink,completion: {(data,json, array, success) in
//                        DispatchQueue.main.async {
//                            if data != nil{
//                                let img = UIImage(data: data!)
//                                if img == nil{
//                                    print("Image fetch Not success")
//                                }
//                                else{
//                                    print("Image fetch success")
//                                    completion(true,img!,objectID)
//                                }
//                            }
//                        }
//                    })
//
//                }
//
//            }
//            }
//        })
    }
}
extension PLMPlansListingDataSource
{
    func dummy1()
    {
        var savedMarkupsTemp = [savedMarkupsType]()
        var markedInfo = [markedInfoType]()
        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: RGB_O_ColorType(redValue: 255, greenValue: 0, blueValue: 0, opacity: 1), drawableFillColor: clearColor, drawableAngle: 0, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
        let b = originalMarkerInfoType(originalFrameRect: CGRect(x: 1000 - (40 * 0.5), y: 1000 - (40 * 0.5), width: 740, height:740 + (40 * 1)), originalStrokeWidth: 40, originalStrokeColor: redColor, originalFillColor: clearColor, originalAngle: 40, originalLayerPoints: [], originalLayerPath: "",originalRullerPosition : _2PointsType(point1: .zero, point2: .zero))
        let im = imageMarkerType(image: UIImage(systemName: "camera")!, urlID: "")
        let marker  = markedInfoType(thisMarkerID: UUID().uuidString, type:  .RECT , drawableDetails: a, originalDetails: b, text: "", image: im,measurmnetsVisible : MeasurmentsVisibleType(areaShown: false, lengthShown: false, breadthShown: false), isLocked: false)

        markedInfo.append(marker)
        
        let t = savedMarkupsType(typeStr: "", plmID: "", sheetID: "", sheetName: "NA", markupName: "NA", date: "NA", createdByUserID: "NA", createdByUserName : "NA", access: "some access", markedInfos: markedInfo, lastUpdated: "NA", state: .PUBLISHED)
        savedMarkupsTemp.append(t)
        self.savedMarkups = savedMarkupsTemp
    }
    func dummy2()
    {
        let img2 = UIImage(named: "dummyPlan")!//UIImage(named: "dummyPlan")!//!.resizeImageForRender(newsize: pdfPageBounds2)
        let img = img2.pngData()!
        let t = sheetsListType(sheetId: "0", thumbnailImage:img, thumbnailCompressedImage: img2,OriginalImage : img , title: "NA", versionnumber: 0, creater_userID: "", tag: "", lastupdated: Date(), isAvailableOffline: false)
        
        self.sheets.append(t)
    }
    func deleteSheet(sheetID: String)
    {
        PLMDBHandler.shared.deleteSheets(neededProjectID: "", sheetID: sheetID, tableName: PLMDBProcessor.SheetListingTypeTableName, completion: {_ in 
            
        })
        fetchSheetsComputedList(projectID: "")
    }
    func addImage(img : UIImage)
    {
        let img2 = img//UIImage(named: "dummyPlan")!//!.resizeImageForRender(newsize: pdfPageBounds2)
        let img = img2.pngData()!
        let sheetID = UUID().uuidString
        let t = sheetsListType(sheetId: sheetID, thumbnailImage:img, thumbnailCompressedImage: img2,OriginalImage : img , title: sheetID, versionnumber: 0, creater_userID: "", tag: "", lastupdated: Date(), isAvailableOffline: true)
        PLMDBProcessor.shared.storeSheetListingType(projectId: "", sheet: t)
        self.sheets.append(t)
    }
    func getSheetsWithVersions(index : Int)->sheetsListType
    {
        let a = sheetsWithVersions[index]
        let b = sheetsListType(sheetId: a.sheetsListVersionDetails[0].sheetId, thumbnailImage: a.sheetsListVersionDetails[0].thumbnailImage, thumbnailCompressedImage: a.sheetsListVersionDetails[0].thumbnailCompressedImage, OriginalImage: a.sheetsListVersionDetails[0].OriginalImage, title: a.title, versionnumber: a.sheetsListVersionDetails[0].versionnumber, creater_userID: a.sheetsListVersionDetails[0].creater_userID, tag: a.tag, lastupdated: a.sheetsListVersionDetails[0].lastupdated, isAvailableOffline: a.isAvailableOffline)
        
        return b
    }
}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
public extension String
{
    func getAsDateFull()->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        return (date ?? Date())
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
public extension Double {
  public var degrees: Double { return self * M_PI / 180 }
  public var ㎭: Double { return self * 180 / M_PI }
}
