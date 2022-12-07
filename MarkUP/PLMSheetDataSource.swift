//
//  PLMSheetDataSource.swift
//  PlanMarkup
//
//  Created by SIMON on 17/01/22.
//

import Foundation
import SwiftUI
import AppearanceFramework
let dummyImage = Data()
let dummyImage2 = UIImage()
public class PLMSheetDataSource: ObservableObject  {
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    public var selectedThumbnail = sheetsListType(sheetId: "0", thumbnailImage: dummyImage, thumbnailCompressedImage: dummyImage2, OriginalImage: dummyImage, title: "", versionnumber: 0, creater_userID: "", tag: "",lastupdated: Date(), isAvailableOffline: false)
    {
        didSet{
//            if selectedThumbnail.sheetId != "0" && PLMPresenter.shared.plansListingDataSource.selectedProject != nil{
//                if PLMPresenter.shared.appInstallationType == .RFIINTIGRATED
//                {
//
//                }
//                else{
//                    PLMPresenter.shared.showMasterProgress = true
//                    PLMPresenter.shared.plansListingDataSource.savedMarkups.removeAll()
                    PLMPresenter.shared.plansListingDataSource.fetchMarkersOnSheet(projectID: "", sheetID: selectedThumbnail.sheetId, completion: { success in
                        DispatchQueue.main.async {
                            PLMPresenter.shared.showMasterProgress = false
                            self.sheetViewController?.sheetBaseView.addMarkedInfos(allMarkers : PLMPresenter.shared.plansListingDataSource.savedMarkups)
                        }
//
                    })
//
//                }
//            }
        }
    }
    public var sheetViewController : PLMSheetController?
    @Published var showEditMarkertextView = false
    @Published var scaleSettextView = false
    @Published var showsendtextView = false
    @Published var showPublishtextView = false
    @Published var scaletext = ""
    @Published var markertext = ""
    @Published var sendTitle = ""
    {
        didSet{
            if sendTitle != ""
            {
                plmListName = sendTitle
            }
        }
    }
    var plmListName = ""
//    @Published var profileImage: UIImage?
    @Published var profilePictureViewShown = false
    @Published var attachmentInsideSheetPickerShown = false
    {
        didSet{
            
        }
    }
    

    @Published var selectedMeasurmentUnit = "Document Size"
    var sizes = ["Feet", "Meters", "Document Size"]
    @Published var imagePickerType = AttachmentPickerType.none
    public var selectedVideo: Data?
    var selectedImageOverSheet: UIImage?
    {
        didSet
        {
            if selectedImageOverSheet != nil
            {
                sheetViewController?.sheetBaseView.markerLayer.addImageToLastAddedMarker(image: selectedImageOverSheet!)
            }
        }
    }
    @Published var showShare = false
    public init()
    {
        
    }
    func getSheetAsImage()->UIImage
    {
        let t1 = self.sheetViewController?.sheetBaseView.markerLayer.asImage()
        let t2 = self.sheetViewController?.sheetBaseView.planSheetImageMasterView.imageCntrlr.imgPhotoHolder.asImage()
        var newImage = UIImage()
        if t1 != nil && t2 != nil {
            let bottomImage = self.sheetViewController?.sheetBaseView.planSheetImageMasterView.imageCntrlr.imgPhotoHolder.image
            let topImage = t1!

            let size = t2!.size
            UIGraphicsBeginImageContext(size)

            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            bottomImage!.draw(in: areaSize)

            topImage.draw(in: areaSize, blendMode: .normal, alpha: 0.8)

            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    public func createSendRequest()
    {
//        let details = TCCredentialsHandler.shared.getUserLoginCredentials()
//        if details.userID == "" || details.accessToken == "" || details.refreshToken == ""
//        {
//          return
//        }
//        if sendTitle != "" && sheetViewController != nil && sheetViewController!.sheetBaseView.markerLayer.markedViews.count > 0{
//            PLMPresenter.shared.showMasterProgress = true
//            let markers = sheetViewController?.sheetBaseView.markerLayer.markedViews[sheetViewController!.sheetBaseView.markerLayer.markedViews.count - 1].markers ?? [PLMShapeTypeMarker()]
//            var parameterMarkerArray = [[String : Any]]()
//            var parameterMarkerImageArray = [String : Any]()
//            let imageMarkers = markers.filter{$0.markedInfos.type == .IMAGE}
//            let nonImageMarkers = markers.filter{$0.markedInfos.type != .IMAGE}
//            for marker in nonImageMarkers
//            {
//                var parameterMarker = [String : Any]()
//                if marker.markedInfos.type == .RECT
//                {
//                    parameterMarker = getForRect(marker: marker)
//                }
//                else if marker.markedInfos.type == .ROUND
//                {
//                    parameterMarker = getForCircle(marker: marker)
//                }
//                else if marker.markedInfos.type == .TEXT
//                {
//                    parameterMarker = getForText(marker: marker)
//                }
//                else if marker.markedInfos.type == .PATH
//                {
//                    parameterMarker = getForPath(marker: marker)
//                }
//                else if marker.markedInfos.type == .HIGHLIGHTER
//                {
//                    parameterMarker = getForHighlighter(marker: marker)
//                }
//                else if marker.markedInfos.type == .ARCS
//                {
//                    parameterMarker = getForCloud(marker: marker)
//                }
//                else if marker.markedInfos.type == .ARROW
//                {
//                    parameterMarker = getForArrow(marker: marker)
//                }
//                parameterMarkerArray.append(parameterMarker)
//
//            }
//            if imageMarkers.count != 0{
//                for marker in imageMarkers
//                {
//                    let imagData = marker.markedInfos.image.image.jpegData(compressionQuality: 0.4)
//                    PLMPresenter.shared.plansListingDataSource.attachImageToPlan(imageData: imagData, markupID: selectedThumbnail.sheetId, completion: {(sucess,id,url) in
//                        var parameterMarker = [String : Any]()
//                        let uid = UUID().uuidString
//                        parameterMarker = self.getForImage(marker: marker, id: id, uniqueID: uid, url : url)
//                        parameterMarkerImageArray[uid] = parameterMarker
//                        if parameterMarkerImageArray.count == imageMarkers.count
//                        {
//                            let parameteremptyArray = [[String : Any]]()
//                            let parametercompound_elementsData = [
//                                "lines":parameteremptyArray,
//                                "ruler_area":parameteremptyArray,
//                                "distanceFactor":NSNull(),
//                                "camera":parameterMarkerImageArray
//                            ] as [String : Any]
//                            let parameterData = [
//                                "normal": parameterMarkerArray,
//                                "compound_elements" : parametercompound_elementsData
//                            ] as [String : Any]
//                            let parameterData2 = [
//                                "plm_markup" : parameterData,
//                                "plm_sheet_version": "v1",
//                                "plm_createdby": details.userID,
//                                "obj_id": PLMPresenter.shared.appInstallationType == .SELF ? self.selectedThumbnail.sheetId : PLMPresenter.shared.objectIDForOtherAppInstallationType,
//                                "obj_type": PLMPresenter.shared.appInstallationType == .SELF ? "plansfile" : PLMPresenter.shared.appInstallationType == .PUNCHLISTINTEGRATED ? "punchlistitem" : PLMPresenter.shared.appInstallationType == .TASKINTIGRATED ? "scheduleitem" : PLMPresenter.shared.appInstallationType == .RFIINTIGRATED ? "rfi" : "plansfile",
//                                "plm_name": "\(self.plmListName)",
//                                "app_model_name": PLMPresenter.shared.appInstallationType == .SELF ? "plansfile" : PLMPresenter.shared.appInstallationType == .PUNCHLISTINTEGRATED ? "punchlistitem" : PLMPresenter.shared.appInstallationType == .TASKINTIGRATED ? "scheduleitem" : PLMPresenter.shared.appInstallationType == .RFIINTIGRATED ? "rfi" : "plansfile"
//                            ] as [String : Any]
//                            PLMPresenter.shared.plansListingDataSource.addnewMarupGroupData(parameters: parameterData2, markupID: self.selectedThumbnail.sheetId)
//                        }
//                    })
//                }
//            }
//            else{
//                let parameteremptyArray = [[String : Any]]()
//                let parametercompound_elementsData = [
//                    "lines":parameteremptyArray,
//                    "ruler_area":parameteremptyArray,
//                    "distanceFactor":NSNull(),
//                    "camera":parameteremptyArray
//                ] as [String : Any]
//                let parameterData = [
//                    "normal": parameterMarkerArray,
//                    "compound_elements" : parametercompound_elementsData
//                ] as [String : Any]
//                let parameterData2 = [
//                    "plm_markup" : parameterData,
//                    "plm_sheet_version": "v1",
//                    "plm_createdby":  details.userID,
//                    "obj_id": PLMPresenter.shared.appInstallationType == .SELF ? self.selectedThumbnail.sheetId : PLMPresenter.shared.objectIDForOtherAppInstallationType,
//                    "obj_type": PLMPresenter.shared.appInstallationType == .SELF ? "plansfile" : PLMPresenter.shared.appInstallationType == .PUNCHLISTINTEGRATED ? "punchlistitem" : PLMPresenter.shared.appInstallationType == .TASKINTIGRATED ? "scheduleitem" : PLMPresenter.shared.appInstallationType == .RFIINTIGRATED ? "rfi" : "plansfile",
//                    "plm_name": "\(self.plmListName)",
//                    "app_model_name": PLMPresenter.shared.appInstallationType == .SELF ? "plansfile" : PLMPresenter.shared.appInstallationType == .PUNCHLISTINTEGRATED ? "punchlistitem" : PLMPresenter.shared.appInstallationType == .TASKINTIGRATED ? "scheduleitem" : PLMPresenter.shared.appInstallationType == .RFIINTIGRATED ? "rfi" : "plansfile"
//                ] as [String : Any]
//                PLMPresenter.shared.plansListingDataSource.addnewMarupGroupData(parameters: parameterData2, markupID: selectedThumbnail.sheetId)
//            }
//        }
    }
//    func getForRect(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//            "type":"rect",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left": s.origin.y,//marker.markedInfos.originalDetails.originalFrameRect.origin.y,
//            "top": s.origin.x,//marker.markedInfos.originalDetails.originalFrameRect.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "fill": fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull(),
//            "strokeLineCap":"butt",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"miter",
//            "strokeMiterLimit":4,
//            "scaleX":1,
//            "scaleY":1,
//            "angle": marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull(),
//            "visible":true,
//            "clipTo":NSNull(),
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull(),
//            "skewX":0,
//            "skewY":0
//        ] as [String : Any]
//
//        return parameterMarker
//    }
//    func getForCloud(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//            "type":"cloud",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":s.origin.y,
//            "top":s.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "fill": fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull(),
//            "strokeLineCap":"butt",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"miter",
//            "strokeMiterLimit":4,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull(),
//            "visible":true,
//            "clipTo":NSNull(),
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull(),
//            "skewX":0,
//            "skewY":0
//        ] as [String : Any]
//
//        return parameterMarker
//    }
//    func getForCircle(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//        let radius = ( marker.markedInfos.originalDetails.originalFrameRect.size.width < marker.markedInfos.originalDetails.originalFrameRect.size.height ? (marker.markedInfos.originalDetails.originalFrameRect.size.width - marker.markedInfos.originalDetails.originalStrokeWidth) : (marker.markedInfos.originalDetails.originalFrameRect.size.height - marker.markedInfos.originalDetails.originalStrokeWidth))/2
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//            "type":"circle",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":s.origin.y,
//            "top":s.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "fill": fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull(),
//            "strokeLineCap":"butt",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"miter",
//            "strokeMiterLimit":4,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull(),
//            "visible":true,
//            "clipTo":NSNull(),
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over","transformMatrix":NSNull(),
//            "skewX":0,
//            "radius":radius,
//            "skewY":0
//        ] as [String : Any]
//
//        return parameterMarker
//    }
//    func getForText(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//            "type":"i-text",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":s.origin.y,
//            "top":s.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height-marker.markedInfos.originalDetails.originalStrokeWidth,
//            "fill": fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull() ,
//            "strokeLineCap":"butt",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"miter",
//            "strokeMiterLimit":4,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull() ,
//            "visible":true,
//            "clipTo":NSNull() ,
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull() ,
//            "skewX":0,
//            "text":"\(marker.markedInfos.text)",
//            "skewY":0
//        ] as [String : Any]
//
//        return parameterMarker
//    }
//    func getForPath(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//        let wd = marker.markedInfos.originalDetails.originalFrameRect.size.width
//        let ht = marker.markedInfos.originalDetails.originalFrameRect.size.height
//        if marker.markedInfos.originalDetails.originalLayerPath == ""{
//            var str = ""
//            for i in 0..<marker.markedInfos.drawableDetails.drawableLayerPoints.count
//            {
//                let ptrX = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
//                let ptrY = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
//                if i == 0
//                {
//                    str = "M \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
//                }
//                else{
//                    str = "\(str) L \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
//                }
//            }
//            marker.markedInfos.originalDetails.originalLayerPath = str
//        }
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//
//            "type":"path",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":s.origin.y,
//            "top":s.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height,
//            "fill": "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), 0)",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull(),
//            "strokeLineCap":"round",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"round",
//            "strokeMiterLimit":10,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull(),
//            "visible":true,
//            "clipTo":NSNull(),
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull(),
//            "skewX":0,
//            "skewY":0,
//            "svgSrc":marker.markedInfos.originalDetails.originalLayerPath
//        ] as [String : Any]
//        marker.markedInfos.originalDetails.originalLayerPath = ""
//        return parameterMarker
//    }
//    func getForHighlighter(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//        let wd = marker.markedInfos.originalDetails.originalFrameRect.size.width
//        let ht = marker.markedInfos.originalDetails.originalFrameRect.size.height
//        if marker.markedInfos.originalDetails.originalLayerPath == ""{
//            var str = ""
//            for i in 0..<marker.markedInfos.drawableDetails.drawableLayerPoints.count
//            {
//                let ptrX = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
//                let ptrY = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
//                if i == 0
//                {
//                    str = "M \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
//                }
//                else{
//                    str = "\(str) L \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
//                }
//            }
//            marker.markedInfos.originalDetails.originalLayerPath = str
//        }
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//
//            "type":"path",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":s.origin.y,
//            "top":s.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height,
//            "fill": "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), 0)",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull(),
//            "strokeLineCap":"round",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"round",
//            "strokeMiterLimit":10,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull(),
//            "visible":true,
//            "clipTo":NSNull(),
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull(),
//            "layerName" :"HighLighter",
//            "skewX":0,
//            "skewY":0,
//            "svgSrc":marker.markedInfos.originalDetails.originalLayerPath
//        ] as [String : Any]
//        marker.markedInfos.originalDetails.originalLayerPath = ""
//        return parameterMarker
//    }
//    func getForArrow(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//        let wd = marker.markedInfos.originalDetails.originalFrameRect.size.width
//        let ht = marker.markedInfos.originalDetails.originalFrameRect.size.height
//        if marker.markedInfos.originalDetails.originalLayerPath == ""{
//            var str = ""
//            for i in 0..<marker.markedInfos.drawableDetails.drawableLayerPoints.count
//            {
//                let ptrX = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
//                let ptrY = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
//                if i == 0
//                {
//                    str = "M \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
//                }
//                else{
//                    str = "\(str) L \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
//                }
//            }
//            marker.markedInfos.originalDetails.originalLayerPath = str
//        }
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let r = marker.markedInfos.originalDetails.originalFrameRect
//        let angle =  marker.markedInfos.drawableDetails.drawableAngle
//        var s = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if angle != 0{
//            let a = self.findTopLeft(width: r.width, Height: r.height, point: coordinates(x: r.origin.x, y: r.origin.y), degree: angle)
//            s = CGRect(x: a.x, y: a.y, width: r.width, height: r.height)
//        }else{
//            s = r
//        }
//        let parameterMarker = [
//
//            "type":"arrow",
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":s.origin.y,
//            "top":s.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height,
//            "fill": "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), 0)",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeWidth":marker.markedInfos.originalDetails.originalStrokeWidth,
//            "strokeDashArray":NSNull(),
//            "strokeLineCap":"round",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"round",
//            "strokeMiterLimit":10,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull(),
//            "visible":true,
//            "clipTo":NSNull(),
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull(),
//            "skewX":0,
//            "skewY":0,
//            "svgSrc":marker.markedInfos.originalDetails.originalLayerPath
//        ] as [String : Any]
//        marker.markedInfos.originalDetails.originalLayerPath = ""
//        return parameterMarker
//    }
//    func getForRuller(marker : PLMShapeTypeMarker)->[String : Any]
//    {
//        let fillclr = marker.markedInfos.drawableDetails.drawableFillColor
//        let strkclr = marker.markedInfos.drawableDetails.drawableStrokeColor
//        let parameterMarker = [
//            "type":marker.markedInfos.type,
//            "version":"3.6.0",
//            "originX":"left",
//            "originY":"top",
//            "left":marker.markedInfos.originalDetails.originalFrameRect.origin.y,
//            "top":marker.markedInfos.originalDetails.originalFrameRect.origin.x,
//            "width":marker.markedInfos.originalDetails.originalFrameRect.size.width,
//            "height":marker.markedInfos.originalDetails.originalFrameRect.size.height,
//            "fill": fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))",
//            "stroke":strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))",
//            "strokeDashArray":NSNull() ,
//            "strokeLineCap":"butt",
//            "strokeDashOffset":0,
//            "strokeLineJoin":"miter",
//            "strokeMiterLimit":4,
//            "scaleX":1,
//            "scaleY":1,
//            "angle":marker.markedInfos.drawableDetails.drawableAngle,
//            "flipX":false,
//            "flipY":false,
//            "opacity":1,
//            "shadow":NSNull() ,
//            "visible":true,
//            "clipTo":NSNull() ,
//            "backgroundColor":"",
//            "fillRule":"nonzero",
//            "paintFirst":"fill",
//            "globalCompositeOperation":"source-over",
//            "transformMatrix":NSNull() ,
//            "skewX":0,
//            "text":"\(marker.markedInfos.text)",
//            "skewY":0,
//        ] as [String : Any]
//
//        return parameterMarker
//    }
//    func getForImage(marker : PLMShapeTypeMarker, id : String, uniqueID : String, url : String)->[String : Any]
//    {
//
//          let parameterMarkerdata = [
//          "url": url,
//          "id": uniqueID,
//          "type": "camera",
//          "urlId": id
//          ] as [String : Any]
//
//          let parameterMarkerobj = [
//          "type": "path",
//          "version": "3.6.0",
//          "originX": "left",
//          "originY": "top",
//          "left":marker.markedInfos.originalDetails.originalFrameRect.origin.y,
//          "top":marker.markedInfos.originalDetails.originalFrameRect.origin.x,
//          "width":marker.markedInfos.originalDetails.originalFrameRect.size.width-marker.markedInfos.originalDetails.originalStrokeWidth,
//          "height":marker.markedInfos.originalDetails.originalFrameRect.size.height-marker.markedInfos.originalDetails.originalStrokeWidth,
//          "fill": "rgb(0,0,0)",
//          "stroke": NSNull(),
//          "strokeWidth": 1,
//          "strokeDashArray": NSNull(),
//          "strokeLineCap": "butt",
//          "strokeDashOffset": 0,
//          "strokeLineJoin": "miter",
//          "strokeMiterLimit": 4,
//          "scaleX": 1,
//          "scaleY": 1,
//          "angle": marker.markedInfos.drawableDetails.drawableAngle,
//          "flipX": false,
//          "flipY": false,
//          "opacity": 1,
//          "shadow": NSNull(),
//          "visible": true,
//          "clipTo": NSNull(),
//          "backgroundColor": "",
//          "fillRule": "nonzero",
//          "paintFirst": "fill",
//          "globalCompositeOperation": "source-over",
//          "transformMatrix": NSNull(),
//          "skewX": 0,
//          "skewY": 0
//        ]  as [String : Any]
//
//        let parameterData = [
//            "data": parameterMarkerdata,
//            "obj" : parameterMarkerobj
//        ] as [String : Any]
//
//        return parameterData
//    }
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
        let actualX = point.x + a.x
        let actualY = point.y + a.y
        return coordinates(x: actualX , y: actualY)
    }
}
extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }

}
