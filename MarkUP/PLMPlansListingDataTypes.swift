//
//  PLMPlansListingDataTypes.swift
//  PlanMarkup
//
//  Created by SIMON on 25/01/22.
//

import UIKit
public struct sheetsListType : Equatable{
    let id = UUID()
    public var sheetId : String
    public var thumbnailImage : Data
    public var thumbnailCompressedImage : UIImage
    public var OriginalImage : Data
    public let title : String
    public let versionnumber : Int
    public let creater_userID : String
    public let tag : String
    public let lastupdated : Date
    public var isAvailableOffline : Bool
    
    public init(sheetId : String, thumbnailImage : Data, thumbnailCompressedImage : UIImage,OriginalImage : Data,title : String, versionnumber : Int,creater_userID : String,tag : String,lastupdated:Date, isAvailableOffline : Bool)
    {
        self.sheetId = sheetId
        self.thumbnailImage = thumbnailImage
        self.thumbnailCompressedImage = thumbnailCompressedImage
        self.OriginalImage = OriginalImage
        self.title = title
        self.versionnumber = versionnumber
        self.creater_userID = creater_userID
        self.tag = tag
        self.lastupdated = lastupdated
        self.isAvailableOffline = isAvailableOffline
    }
}
public struct sheetsListVersionDetailsType : Equatable{
    let id = UUID()
    public var sheetId : String
    public var thumbnailImage : Data
    public var thumbnailCompressedImage : UIImage
    public var OriginalImage : Data
    public let versionnumber : Int
    public let creater_userID : String
    public let lastupdated : Date
    
    public init(sheetId : String,thumbnailImage : Data, thumbnailCompressedImage : UIImage,OriginalImage : Data,versionnumber : Int,creater_userID : String,lastupdated:Date)
    {
        self.sheetId = sheetId
        self.thumbnailImage = thumbnailImage
        self.thumbnailCompressedImage = thumbnailCompressedImage
        self.OriginalImage = OriginalImage
        self.versionnumber = versionnumber
        self.creater_userID = creater_userID
        self.lastupdated = lastupdated
    }
}
public struct sheetsListWithVersionType : Equatable{
    let id = UUID()
    public var sheetsListVersionDetails : [sheetsListVersionDetailsType]
    public let title : String
    public let tag : String
    public var isAvailableOffline : Bool
    
    public init(sheetsListVersionDetails : [sheetsListVersionDetailsType], title : String,tag : String, isAvailableOffline : Bool)
    {
        self.sheetsListVersionDetails = sheetsListVersionDetails
        self.title = title
        self.tag = tag
        self.isAvailableOffline = isAvailableOffline
    }
}
public enum PLMViewMode
{
    case thumbnail
    case list
}
public enum MeasurmentsType
{
    case area
    case length
    case breadth
}
public struct savedMarkupsType {
    let id = UUID()
    var typeStr : String
    var plmID : String
    var sheetID : String
    var sheetName : String
    var markupName : String
    var date : String
    var createdByUserID : String
    var createdByUserName : String
    var access : String
    var markedInfos : [markedInfoType]
    var lastUpdated : String
    var state : markerStateType
}
public struct markedInfoType {
    var thisMarkerID : String
    var type : PLMShapeType
    var drawableDetails : drawableMarkerInfoType
    var originalDetails : originalMarkerInfoType
    var text : String
    var image : imageMarkerType
    var measurmnetsVisible : MeasurmentsVisibleType
    var isLocked : Bool
}
public enum markerStateType
{
    case DRAFT
    case PUBLISHED
}
public enum markerPermissionType
{
    case EDITABLE
    case VIEWABLE
}
public struct imageMarkerType
{
    var image : UIImage
    var urlID : String
}
public struct MeasurmentsVisibleType
{
    var areaShown : Bool
    var lengthShown : Bool
    var breadthShown : Bool
}
public struct drawableMarkerInfoType {
    var drawableframeRect : CGRect
    var drawableStrokeWidth : CGFloat
    var drawableStrokeColor : RGB_O_ColorType
    var drawableFillColor : RGB_O_ColorType
    var drawableAngle : CGFloat
    var drawableLayerPoints : [CGPoint]
    var drawableRullerPosition : _2PointsType
    
}
let clearColor = RGB_O_ColorType(redValue: -1, greenValue: -1, blueValue: -1, opacity: 0)
let redColor = RGB_O_ColorType(redValue: 255, greenValue: 0, blueValue: 0, opacity: 1)
public struct RGB_O_ColorType
{
    var redValue : CGFloat
    var greenValue : CGFloat
    var blueValue : CGFloat
    var opacity : CGFloat
}
public struct originalMarkerInfoType {
    var originalFrameRect : CGRect
    var originalStrokeWidth : CGFloat
    var originalStrokeColor : RGB_O_ColorType
    var originalFillColor : RGB_O_ColorType
    var originalAngle : CGFloat
    var originalLayerPoints : [CGPoint]
    var originalLayerPath : String
    var originalRullerPosition : _2PointsType
}
public struct _2PointsType
{
    var point1 : CGPoint
    var point2 : CGPoint
}
public struct drawableDefaultCollectionType
{
    var strokeWidth : CGFloat
    var fillColor : RGB_O_ColorType
    var strokeColor : RGB_O_ColorType
    var angle : CGFloat
}
public enum PLMShapeType
{
    case unknown
    case RECT
    case ROUND
    case ARCS
    case ARROW
    case IMAGE
    case TEXT
    case PATH
    case HIGHLIGHTER
    case RULLER
}
public enum PLMMeasurmentUnitTypes
{
    case IMAGESIZE
    case FEET
    case METER
}
public enum PLMHolderType
{
    case TL
//    case CL
    case BL
    case TR
//    case CR
    case BR
//    case CT
//    case CB
    
    case RULLERPOINT1
    case RULLERPOINT2
}
public enum PLMAccessType
{
    case VIEWONLY
    case EDIT_IN_EXISTING_COPY
    case CREATE_NEW_ONLY
}
public struct markedGroupCellType {
    var expanded = Bool()
    var typeStr = String()
    var allHidden = Bool()
    var allLocked = Bool()
    var title = String()
    var permissionType = markerPermissionType.VIEWABLE
    var state = markerStateType.PUBLISHED
    var markers = [PLMShapeTypeMarker]()
}
public struct coordinates: Identifiable{
    public var id = UUID()
    var x: CGFloat
    var y: CGFloat
}
public struct planKeysType{
    public var key: String
    public var date: Date
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
