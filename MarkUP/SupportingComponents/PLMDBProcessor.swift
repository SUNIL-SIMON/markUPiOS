
//
//  PLMDNProcessor.swift
//  TimeCard
//
//  Created by SIMON on 17/10/21.
//

import Foundation
let oneDayInterval : Double = 86400

class PLMDBProcessor
{
    public static var shared = PLMDBProcessor()

    public static var TCProjectsTypeTableName = "TCProjectsType_Table_sample"
    public static var SheetListingTypeTableName = "PLMSheetListingType_Table_sample"
    public static var MarkupsListingTypeTableName = "PLMMarkupsListingType_Table_sample1"

    init()
    {
       
    }
    func storeTCProjectsType()
    {
//        PLMDBHandler.shared.deleteTable(tableName: PLMDBProcessor.TCProjectsTypeTableName)
//        PLMDBHandler.shared.createTable(tableName: PLMDBProcessor.TCProjectsTypeTableName, query: "CREATE TABLE IF NOT EXISTS \(PLMDBProcessor.TCProjectsTypeTableName)(Id INTEGER PRIMARY KEY,projectName TEXT,pcmId INTEGER,projectID TEXT,projectLocation TEXT,accessLocation INTEGER,shiftDetailsStart TEXT, shiftDetailsEnd TEXT, shift_type TEXT);")
//
//        for project in allProjects{
//            var pl = ""
//            for a in project.projectLocation{
//                pl = "\(pl);\(a.latitude):\(a.longitude)"
//            }
//            var al = ""
//            if project.accessLocation != nil{
//                al = "\(project.accessLocation!.latitude):\(project.accessLocation!.longitude)"
//            }
//            let ShiftType = ""
//            let startTime = ""
//            let endTime = ""
//
//            PLMDBHandler.shared.insert(projectName: project.projectName, pcmId: project.pcmId, projectID: project.projectID, projectLocation: pl, accessLocation: al, shiftDetailsStart:startTime,shiftDetailsEnd: endTime, shift_type: ShiftType, tableName: PLMDBProcessor.TCProjectsTypeTableName)
//        }
    }
    func storeSheetListingType(projectId:String,sheet: sheetsListType){
        PLMDBHandler.shared.createTable(tableName: PLMDBProcessor.SheetListingTypeTableName, query: "CREATE TABLE IF NOT EXISTS \(PLMDBProcessor.SheetListingTypeTableName)(Id INTEGER PRIMARY KEY,projectId TEXT,sheetId TEXT,thumbnailImage TEXT, originalImage TEXT,title TEXT,versionnumber INTEGER,creater_userID TEXT,tag TEXT,lastupdated TEXT);")
        PLMDBHandler.shared.insert(projectId: projectId, sheetID: sheet.sheetId, thumbnailImage: sheet.thumbnailImage, OriginalImage : sheet.OriginalImage, title: sheet.title, versionnumber: sheet.versionnumber, creater_userID: sheet.creater_userID, tag: sheet.tag, lastupdated: sheet.lastupdated, tableName: PLMDBProcessor.SheetListingTypeTableName)
    }
    
    func storeMarkupsListingType(projectId:String,marker: savedMarkupsType){
        PLMDBHandler.shared.createTable(tableName: PLMDBProcessor.MarkupsListingTypeTableName, query: "CREATE TABLE IF NOT EXISTS \(PLMDBProcessor.MarkupsListingTypeTableName)(Id INTEGER PRIMARY KEY, projectId TEXT, plmID TEXT, sheetID TEXT, sheetName TEXT, markupName TEXT, date TEXT, createdByUserID TEXT, createdByUserName TEXT, access TEXT, lastupdated TEXT, type TEXT, originalFrameRectX TEXT, originalFrameRectY TEXT, originalFrameRectWidth TEXT, originalFrameRectHeight TEXT, originalStrokeWidth TEXT, originalStrokeColor TEXT, originalFillColor TEXT, originalAngle TEXT, originalLayerPath TEXT, originalRullerPosition1X TEXT, originalRullerPosition1Y TEXT, originalRullerPosition2X TEXT, originalRullerPosition2Y TEXT, text TEXT, imageURLID TEXT, markerimage TEXT, areaShown TEXT, breadthShown TEXT, lengthShown TEXT, isLocked TEXT, thisMarkerID TEXT, state TEXT, typeStr TEXT);")
        var type = "RECT"
        if marker.markedInfos[0].type == .unknown{type = "unknown"}
        if marker.markedInfos[0].type == .RECT{type = "RECT"}
        if marker.markedInfos[0].type == .ROUND{type = "ROUND"}
        if marker.markedInfos[0].type == .ARCS{type = "ARCS"}
        if marker.markedInfos[0].type == .ARROW{type = "ARROW"}
        if marker.markedInfos[0].type == .IMAGE{type = "IMAGE"}
        if marker.markedInfos[0].type == .TEXT{type = "TEXT"}
        if marker.markedInfos[0].type == .PATH{type = "PATH"}
        if marker.markedInfos[0].type == .HIGHLIGHTER{type = "HIGHLIGHTER"}
        if marker.markedInfos[0].type == .RULLER{type = "RULLER"}

        let fillclr = marker.markedInfos[0].originalDetails.originalFillColor
        let strkclr = marker.markedInfos[0].originalDetails.originalStrokeColor
        
        let fillStr = fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))"
        let strkStr = strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))"
        
        PLMDBHandler.shared.insert(projectId: projectId, plmID: marker.plmID, sheetID: marker.sheetID, sheetName: marker.sheetName, markupName: marker.markupName, date: marker.date, createdByUserID: marker.createdByUserID, createdByUserName: marker.createdByUserName, access: marker.access, lastupdated: marker.lastUpdated, type: type, originalFrameRectX: marker.markedInfos[0].originalDetails.originalFrameRect.origin.x, originalFrameRectY: marker.markedInfos[0].originalDetails.originalFrameRect.origin.y, originalFrameRectWidth: marker.markedInfos[0].originalDetails.originalFrameRect.size.width, originalFrameRectHeight: marker.markedInfos[0].originalDetails.originalFrameRect.size.height, originalStrokeWidth: marker.markedInfos[0].originalDetails.originalStrokeWidth, originalStrokeColor: strkStr, originalFillColor: fillStr, originalAngle: marker.markedInfos[0].originalDetails.originalAngle, originalLayerPath: marker.markedInfos[0].originalDetails.originalLayerPath, originalRullerPosition1X: marker.markedInfos[0].originalDetails.originalRullerPosition.point1.x, originalRullerPosition1Y: marker.markedInfos[0].originalDetails.originalRullerPosition.point1.y, originalRullerPosition2X: marker.markedInfos[0].originalDetails.originalRullerPosition.point2.x, originalRullerPosition2Y: marker.markedInfos[0].originalDetails.originalRullerPosition.point2.y,text: marker.markedInfos[0].text, imageURLID: marker.markedInfos[0].image.urlID, markerimage: marker.markedInfos[0].image.image, areaShown: marker.markedInfos[0].measurmnetsVisible.areaShown, breadthShown: marker.markedInfos[0].measurmnetsVisible.breadthShown, lengthShown: marker.markedInfos[0].measurmnetsVisible.lengthShown, isLocked: marker.markedInfos[0].isLocked, thisMarkerID: marker.markedInfos[0].thisMarkerID, state: marker.state == .PUBLISHED ? 1 : 0, typeStr: marker.typeStr, tableName: PLMDBProcessor.MarkupsListingTypeTableName)
    }
    func storeMarkupsListingTypeForDraft(projectId:String,marker: savedMarkupsType){
        PLMDBHandler.shared.createTable(tableName: PLMDBProcessor.MarkupsListingTypeTableName, query: "CREATE TABLE IF NOT EXISTS \(PLMDBProcessor.MarkupsListingTypeTableName)(Id INTEGER PRIMARY KEY, projectId TEXT, plmID TEXT, sheetID TEXT, sheetName TEXT, markupName TEXT, date TEXT, createdByUserID TEXT, createdByUserName TEXT, access TEXT, lastupdated TEXT, type TEXT, originalFrameRectX TEXT, originalFrameRectY TEXT, originalFrameRectWidth TEXT, originalFrameRectHeight TEXT, originalStrokeWidth TEXT, originalStrokeColor TEXT, originalFillColor TEXT, originalAngle TEXT, originalLayerPath TEXT, originalRullerPosition1X TEXT, originalRullerPosition1Y TEXT, originalRullerPosition2X TEXT, originalRullerPosition2Y TEXT, text TEXT, imageURLID TEXT, markerimage TEXT, areaShown TEXT, breadthShown TEXT, lengthShown TEXT, isLocked TEXT, thisMarkerID TEXT, state TEXT, typeStr TEXT);")
        var type = "RECT"
        if marker.markedInfos[0].type == .unknown{type = "unknown"}
        if marker.markedInfos[0].type == .RECT{type = "RECT"}
        if marker.markedInfos[0].type == .ROUND{type = "ROUND"}
        if marker.markedInfos[0].type == .ARCS{type = "ARCS"}
        if marker.markedInfos[0].type == .ARROW{type = "ARROW"}
        if marker.markedInfos[0].type == .IMAGE{type = "IMAGE"}
        if marker.markedInfos[0].type == .TEXT{type = "TEXT"}
        if marker.markedInfos[0].type == .PATH{type = "PATH"}
        if marker.markedInfos[0].type == .HIGHLIGHTER{type = "HIGHLIGHTER"}
        if marker.markedInfos[0].type == .RULLER{type = "RULLER"}

        let fillclr = marker.markedInfos[0].originalDetails.originalFillColor
        let strkclr = marker.markedInfos[0].originalDetails.originalStrokeColor
        
        let fillStr = fillclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(fillclr.redValue), \(fillclr.greenValue), \(fillclr.blueValue), \(fillclr.opacity))"
        let strkStr = strkclr.redValue == -1 ? "rgba(0,0,0, 0))" : "rgba(\(strkclr.redValue), \(strkclr.greenValue), \(strkclr.blueValue), \(strkclr.opacity))"
        
        PLMDBHandler.shared.insertDraft(projectId: projectId, plmID: marker.plmID, sheetID: marker.sheetID, sheetName: marker.sheetName, markupName: marker.markupName, date: marker.date, createdByUserID: marker.createdByUserID, createdByUserName: marker.createdByUserName, access: marker.access, lastupdated: marker.lastUpdated, type: type, originalFrameRectX: marker.markedInfos[0].originalDetails.originalFrameRect.origin.x, originalFrameRectY: marker.markedInfos[0].originalDetails.originalFrameRect.origin.y, originalFrameRectWidth: marker.markedInfos[0].originalDetails.originalFrameRect.size.width, originalFrameRectHeight: marker.markedInfos[0].originalDetails.originalFrameRect.size.height, originalStrokeWidth: marker.markedInfos[0].originalDetails.originalStrokeWidth, originalStrokeColor: strkStr, originalFillColor: fillStr, originalAngle: marker.markedInfos[0].originalDetails.originalAngle, originalLayerPath: marker.markedInfos[0].originalDetails.originalLayerPath, originalRullerPosition1X: marker.markedInfos[0].originalDetails.originalRullerPosition.point1.x, originalRullerPosition1Y: marker.markedInfos[0].originalDetails.originalRullerPosition.point1.y, originalRullerPosition2X: marker.markedInfos[0].originalDetails.originalRullerPosition.point2.x, originalRullerPosition2Y: marker.markedInfos[0].originalDetails.originalRullerPosition.point2.y,text: marker.markedInfos[0].text, imageURLID: marker.markedInfos[0].image.urlID, markerimage: marker.markedInfos[0].image.image, areaShown: marker.markedInfos[0].measurmnetsVisible.areaShown, breadthShown: marker.markedInfos[0].measurmnetsVisible.breadthShown, lengthShown: marker.markedInfos[0].measurmnetsVisible.lengthShown, isLocked: marker.markedInfos[0].isLocked, thisMarkerID: marker.markedInfos[0].thisMarkerID, state: marker.state == .PUBLISHED ? 1 : 0, tableName: PLMDBProcessor.MarkupsListingTypeTableName)
    }

    deinit {
        
    }
}
