//
//  PLMSheetBaseViewPanExtension.swift
//  PlanMarkup
//
//  Created by SIMON on 26/01/22.
//

import UIKit
extension PLMSheetBaseView
{
    public func touchBeganPanMarkerSource(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        let pt = (gestureRecognizer.location(in: gestureRecognizer.view))
        lastPointForPathType = .zero
        
        if markerLayer.selectedMarkerToBeAdded == .PATH
        {

            markerLayer.newShapeMarkerAdd(shapeType : .PATH, pt : pt)
            let ff = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
            let pathClassObj = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff] as! PLMPathMarker)
            pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.removeAll()
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].shouldEnableHolders(enable: false)
            pathClassObj.shapepath.removeAllPoints()
            pathClassObj.itemShapeLayer.path = pathClassObj.shapepath.cgPath
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].layoutSubviews()
            print("currentPoint is = 0 has began")
        }
        if markerLayer.selectedMarkerToBeAdded == .HIGHLIGHTER
        {

            markerLayer.newShapeMarkerAdd(shapeType : .HIGHLIGHTER, pt : pt)
            let ff = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
            let pathClassObj = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff] as! PLMHighLightMarker)
            pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.removeAll()
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].shouldEnableHolders(enable: false)
            pathClassObj.shapepath.removeAllPoints()
            pathClassObj.itemShapeLayer.path = pathClassObj.shapepath.cgPath
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].layoutSubviews()

        }
    }
    public func touchMovedPanMarkerSource(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        let pt = (gestureRecognizer.location(in: gestureRecognizer.view?.superview?.superview))
        let t = getImageViewFrame()
        let currentPoint = CGPoint(x: pt.x - t.origin.x, y: pt.y - t.origin.y)
        print("currentPoint is = ",currentPoint)
        if (pt.x - t.origin.x) > 0 && (pt.x - t.origin.x) < t.size.width && (pt.y - t.origin.y) > 0 && (pt.y - t.origin.y) < t.size.height// && currentPoint.x < t.size.width && currentPoint.y < t.size.height
        {
        if markerLayer.selectedMarkerToBeAdded == .PATH
        {
            let h = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1)
            let pathClassObj = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h] as! PLMPathMarker)
            if lastPointForPathType != CGPoint.zero{
                xPointForPathType = xPointForPathType < (pt.x - t.origin.x) ? xPointForPathType : (pt.x - t.origin.x)
                yPointForPathType = yPointForPathType < (pt.y - t.origin.y) ? yPointForPathType : (pt.y - t.origin.y)
                x_widthPointForPathType = x_widthPointForPathType > (pt.x - t.origin.x) ? x_widthPointForPathType : (pt.x - t.origin.x)
                y_heightlastPointForPathType = y_heightlastPointForPathType > (pt.y - t.origin.y) ? y_heightlastPointForPathType : (pt.y - t.origin.y)
                pathClassObj.shapepath.addLine(to: lastPointForPathType)

                pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.append(lastPointForPathType)
                lastPointForPathType = currentPoint
                pathClassObj.drawPath()
                print("currentPoint is = 1")
            }
            else{
                xPointForPathType = pt.x - t.origin.x
                yPointForPathType = pt.y - t.origin.y
                x_widthPointForPathType = pt.x - t.origin.x
                y_heightlastPointForPathType = pt.y - t.origin.y
                lastPointForPathType = currentPoint
                pathClassObj.markedInfos.drawableDetails.drawableStrokeWidth = selectedStrokeWidth
                pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.append(lastPointForPathType)
                pathClassObj.shapepath.removeAllPoints()
                pathClassObj.shapepath.move(to: lastPointForPathType)
                print("currentPoint is = 2", lastPointForPathType)
            }
        }
        if markerLayer.selectedMarkerToBeAdded == .HIGHLIGHTER
        {
            let h = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1)
            let pathClassObj = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h] as! PLMHighLightMarker)
            if lastPointForPathType != CGPoint.zero{
                xPointForPathType = xPointForPathType < (pt.x - t.origin.x) ? xPointForPathType : (pt.x - t.origin.x)
                yPointForPathType = yPointForPathType < (pt.y - t.origin.y) ? yPointForPathType : (pt.y - t.origin.y)
                x_widthPointForPathType = x_widthPointForPathType > (pt.x - t.origin.x) ? x_widthPointForPathType : (pt.x - t.origin.x)
                y_heightlastPointForPathType = y_heightlastPointForPathType > (pt.y - t.origin.y) ? y_heightlastPointForPathType : (pt.y - t.origin.y)
                pathClassObj.shapepath.addLine(to: lastPointForPathType)
                
                pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.append(lastPointForPathType)
                lastPointForPathType = currentPoint
                pathClassObj.drawPath()
                print("currentPoint is = 1")
            }
            else{
                xPointForPathType = pt.x - t.origin.x
                yPointForPathType = pt.y - t.origin.y
                x_widthPointForPathType = pt.x - t.origin.x
                y_heightlastPointForPathType = pt.y - t.origin.y
                lastPointForPathType = currentPoint
                pathClassObj.markedInfos.drawableDetails.drawableStrokeWidth = selectedStrokeWidthHighlihter
                pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.append(lastPointForPathType)
                pathClassObj.shapepath.removeAllPoints()
                pathClassObj.shapepath.move(to: lastPointForPathType)
                print("currentPoint is = 2", lastPointForPathType)
            }
          }
        }
    }
    public func touchStoppedPanMarkerSource(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        
        
        lastPointForPathType = CGPoint.zero
        if markerLayer.selectedMarkerToBeAdded == .PATH
        {
            let size : CGFloat = 20
            let halfSize : CGFloat = 10
            let ff = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
            let sw = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableStrokeWidth
            let fr = CGRect(x: xPointForPathType - (sw/2), y: yPointForPathType - (sw/2), width: x_widthPointForPathType - xPointForPathType + size + sw, height: y_heightlastPointForPathType - yPointForPathType + size + sw)
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].frame = fr
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableframeRect = fr //needs holder gap
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].shouldEnableHolders(enable: true)
            (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff] as! PLMPathMarker).shapepath.removeAllPoints()
            
            let pathClassObj = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff] as! PLMPathMarker)
            pathClassObj.itemShapeLayer.path = pathClassObj.shapepath.cgPath
            pathClassObj.drawPath()
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].layoutSubviews()
            let s = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].frame
            var points = [CGPoint]()
            for i in 0..<pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.count
            {
                let ptrX = (pathClassObj.markedInfos.drawableDetails.drawableLayerPoints[i].x - s.origin.x)//t.size.width) * s.size.width
                let ptrY = (pathClassObj.markedInfos.drawableDetails.drawableLayerPoints[i].y - s.origin.y)///t.size.height) * s.size.height
                if i == 0
                {
                    pathClassObj.shapepath.move(to: CGPoint(x: ptrX, y: ptrY))
                }
                else{
                    pathClassObj.shapepath.addLine(to: CGPoint(x: ptrX, y: ptrY))
                }
                let xrat = ptrX/(fr.size.width - size)
                let yrat = ptrY/(fr.size.height - size)
                points.append(CGPoint(x: xrat, y: yrat))
            }
            pathClassObj.markedInfos.drawableDetails.drawableLayerPoints = points
            
            pathClassObj.drawPath()
            let f = getImageViewFrame()
            let v = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff]
            let x = v.frame.origin.x+halfSize
            let y = v.frame.origin.y+halfSize
            let w = v.frame.size.width-size
            let h = v.frame.size.height-size

            let p = getImage().size
            let x1 = ((x / f.size.width) * p.width)
            let y1 = ((y / f.size.height) * p.height)
            let w1 = ((w / f.size.width) * p.width)
            let h1 = ((h / f.size.height) * p.height)
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)

            let size2 = (f.size.width < f.size.height) ? f.size.width : f.size.height
            let size3 = (p.width < p.height) ? p.width : p.height
            let strWidth = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableStrokeWidth/size2) * size3
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.originalDetails.originalStrokeWidth = strWidth
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableStrokeColor = selectedStrokeColor
//            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].reset(strokeWidth: markerLayer.drawableDefaultCollection.strokeWidth, strokeColor: markerLayer.getsetColorString(), angle: 0)

            xPointForPathType = 0
            yPointForPathType = 0
            x_widthPointForPathType = 0
            y_heightlastPointForPathType = 0
            markerLayer.selectedMarkerToBeAdded = .unknown
            restSelectedMarker()
            
            let marker = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff]
            let wd = marker.markedInfos.originalDetails.originalFrameRect.size.width
            let ht = marker.markedInfos.originalDetails.originalFrameRect.size.height
            if marker.markedInfos.originalDetails.originalLayerPath == ""{
                var str = ""
                for i in 0..<marker.markedInfos.drawableDetails.drawableLayerPoints.count
                {
                    let ptrX = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
                    let ptrY = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
                    if i == 0
                    {
                        str = "M \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                    }
                    else{
                        str = "\(str) L \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                    }
                }
                marker.markedInfos.originalDetails.originalLayerPath = str
            }
            
            if markerLayer.markedViews[markerLayer.markedViews.count - 1].state == .DRAFT
            {
                let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : selectedThumbnail.sheetId, sheetName: selectedThumbnail.title, markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos], lastUpdated: "", state: .DRAFT)
                PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
            }
            
        }
        if markerLayer.selectedMarkerToBeAdded == .HIGHLIGHTER
        {

            let size : CGFloat = 20
            let halfSize : CGFloat = 10
            let ff = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
            let sw = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableStrokeWidth
            let fr = CGRect(x: xPointForPathType - (sw/2), y: yPointForPathType - (sw/2), width: x_widthPointForPathType - xPointForPathType + size + sw, height: y_heightlastPointForPathType - yPointForPathType + size + sw)
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].frame = fr
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableframeRect = fr //needs holder gap
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].shouldEnableHolders(enable: true)
            (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff] as! PLMHighLightMarker).shapepath.removeAllPoints()
            
            let pathClassObj = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff] as! PLMHighLightMarker)
            pathClassObj.itemShapeLayer.path = pathClassObj.shapepath.cgPath
            pathClassObj.drawPath()
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].layoutSubviews()
            let s = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].frame
            var points = [CGPoint]()
            for i in 0..<pathClassObj.markedInfos.drawableDetails.drawableLayerPoints.count
            {
                let ptrX = (pathClassObj.markedInfos.drawableDetails.drawableLayerPoints[i].x - s.origin.x)//t.size.width) * s.size.width
                let ptrY = (pathClassObj.markedInfos.drawableDetails.drawableLayerPoints[i].y - s.origin.y)///t.size.height) * s.size.height
                if i == 0
                {
                    pathClassObj.shapepath.move(to: CGPoint(x: ptrX, y: ptrY))
                }
                else{
                    pathClassObj.shapepath.addLine(to: CGPoint(x: ptrX, y: ptrY))
                }
                let xrat = ptrX/(fr.size.width - size)
                let yrat = ptrY/(fr.size.height - size)
                points.append(CGPoint(x: xrat, y: yrat))
            }
            pathClassObj.markedInfos.drawableDetails.drawableLayerPoints = points
            
            pathClassObj.drawPath()
            let f = getImageViewFrame()
            let v = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff]
            let x = v.frame.origin.x+halfSize
            let y = v.frame.origin.y+halfSize
            let w = v.frame.size.width-size
            let h = v.frame.size.height-size

            let p = getImage().size
            let x1 = ((x / f.size.width) * p.width)
            let y1 = ((y / f.size.height) * p.height)
            let w1 = ((w / f.size.width) * p.width)
            let h1 = ((h / f.size.height) * p.height)
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.originalDetails.originalFrameRect = CGRect(x: y1, y: x1, width: w1, height: h1)

            let size2 = (f.size.width < f.size.height) ? f.size.width : f.size.height
            let size3 = (p.width < p.height) ? p.width : p.height
            let strWidth = (markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableStrokeWidth/size2) * size3
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.originalDetails.originalStrokeWidth = strWidth
            var clr = selectedStrokeColor
            clr.opacity = 0.3
            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos.drawableDetails.drawableStrokeColor = clr
//            markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].reset(strokeWidth: markerLayer.drawableDefaultCollection.strokeWidth, strokeColor: markerLayer.getsetColorString(), angle: 0)

            xPointForPathType = 0
            yPointForPathType = 0
            x_widthPointForPathType = 0
            y_heightlastPointForPathType = 0
            markerLayer.selectedMarkerToBeAdded = .unknown
            restSelectedMarker()
            
            let marker = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff]
            let wd = marker.markedInfos.originalDetails.originalFrameRect.size.width
            let ht = marker.markedInfos.originalDetails.originalFrameRect.size.height
            if marker.markedInfos.originalDetails.originalLayerPath == ""{
                var str = ""
                for i in 0..<marker.markedInfos.drawableDetails.drawableLayerPoints.count
                {
                    let ptrX = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].x * wd)
                    let ptrY = (marker.markedInfos.drawableDetails.drawableLayerPoints[i].y * ht)
                    if i == 0
                    {
                        str = "M \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                    }
                    else{
                        str = "\(str) L \(marker.markedInfos.originalDetails.originalFrameRect.origin.y + ptrX) \(marker.markedInfos.originalDetails.originalFrameRect.origin.x + ptrY)"
                    }
                }
                marker.markedInfos.originalDetails.originalLayerPath = str
            }
            
            if markerLayer.markedViews[markerLayer.markedViews.count - 1].state == .DRAFT
            {
                let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : selectedThumbnail.sheetId, sheetName: selectedThumbnail.title, markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[ff].markedInfos], lastUpdated: "", state: .DRAFT)
                PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
            }
        }
            markerLayer.attachRotatorToSelectedMarker()
        markerLayer.deSelectMarker()
    }
    
}
