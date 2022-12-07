//
//  PLMDBHandler.swift
//  Plans
//
//  Created by SIMON on 17/10/21.
//

import Foundation
import UIKit
import SQLite3
class PLMDBHandler
{
    public static var shared = PLMDBHandler()
    init()
    {
        db = openDatabase()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    func createTable(tableName : String, query : String) {
        let createTableString = query
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("SQL \(tableName) table created.")
            } else {
                print("SQL \(tableName) table could not be created.")
            }
        } else {
            print("SQL CREATE TABLE \(tableName) statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func deleteTable(tableName : String)
    {
        let createTableString = "DROP TABLE \(tableName);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("SQL \(tableName) table deleted.")
            } else {
                print("SQL \(tableName) table could not be deleted.")
            }
        } else {
            print("SQL DELETE TABLE \(tableName) statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////// TCProjectsType
    func insert(projectName : String, pcmId: String, projectID: String, projectLocation: String, accessLocation: String, shiftDetailsStart : String,shiftDetailsEnd : String, shift_type : String, tableName : String){
        let insertStatementString = "INSERT INTO \(tableName) (Id, projectName, pcmId, projectID, projectLocation, accessLocation, shiftDetailsStart, shiftDetailsEnd, shift_type) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (projectName as NSString).utf8String, -1, nil)

            sqlite3_bind_text(insertStatement, 2, (pcmId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (projectID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (projectLocation as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (accessLocation as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (shiftDetailsStart as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (shiftDetailsEnd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (shift_type as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("SQL \(tableName) Successfully inserted row.")
            } else {
                print("SQL \(tableName) Could not insert row.")
            }
        } else {
            print("SQL INSERT \(tableName) statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
//    func readTCProjectsType(tableName : String) -> [CLProjectsType] {
//        let queryStatementString = "SELECT * FROM \(tableName);"
//        var queryStatement: OpaquePointer? = nil
//        var psns : [CLProjectsType] = []
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            while sqlite3_step(queryStatement) == SQLITE_ROW {
//                guard let _ = sqlite3_column_text(queryStatement, 1) else {return []}
//                let projectName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                guard let _ = sqlite3_column_text(queryStatement, 2) else {return []}
//                let pcmId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
//                guard let _ = sqlite3_column_text(queryStatement, 3) else {return []}
//                let projectID = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
//                guard let _ = sqlite3_column_text(queryStatement, 4) else {return []}
//                let projectLocation = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
//                guard let _ = sqlite3_column_text(queryStatement, 5) else {return []}
//                let accessLocation = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
//                guard let _ = sqlite3_column_text(queryStatement, 6) else {return []}
//                let shiftDetailsStart = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
//                guard let _ = sqlite3_column_text(queryStatement, 7) else {return []}
//                let shiftDetailsEnd = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
//                guard let _ = sqlite3_column_text(queryStatement, 8) else {return []}
//                let shift_type = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
//                var locations = [CLProjectsLocationType]()
//                let locs = projectLocation.components(separatedBy: ";")
//                for loc in locs
//                {
//                    if loc.contains(":")
//                    {
//                        let l = loc.components(separatedBy: ":")
//                        locations.append(CLProjectsLocationType(latitude: Double(l[0]) ?? 0, longitude: Double(l[1]) ?? 0))
//                    }
//                }
//                var al : CLProjectsLocationType? = nil
//                if accessLocation != ""{
//                    let als = accessLocation.components(separatedBy: ":")
//                    al = CLProjectsLocationType(latitude: Double(als[0]) ?? 0, longitude: Double(als[1]) ?? 0)
//                }
//                //DATE NOT SURE
//                psns.append(CLProjectsType(projectName: projectName, pcmId: pcmId, projectID: projectID, projectAddress: nil, projectLocation: locations, accessLocation: al, shiftDetails: [projectShiftDetailsType(shift_type: shift_type, shiftStart_time: shiftDetailsStart, shiftEnd_time: shiftDetailsEnd)], isUserInsideSite: false))
//            }
//        } else {
//            print("SQL SELECT \(tableName) statement could not be prepared")
//        }
//        sqlite3_finalize(queryStatement)
//        return psns
//    }
    /////////////////////////////////////////////////Sheetslisting
    func insert(projectId : String, sheetID: String, thumbnailImage: Data, OriginalImage : Data, title: String, versionnumber: Int, creater_userID: String, tag: String, lastupdated: Date, tableName: String){
        
        let  thumbnailencodedImageString = thumbnailImage.base64EncodedString()
        let  OriginalImageencodedImageString = thumbnailImage.base64EncodedString()
        
        let dateString = ""//lastupdated.getCommentSentDate()
        let insertStatementString = "INSERT INTO \(tableName) (Id, projectId, sheetID, thumbnailImage, OriginalImage, title, versionnumber, creater_userID, tag, lastupdated) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (projectId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (sheetID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (thumbnailencodedImageString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (OriginalImageencodedImageString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32(versionnumber))
            sqlite3_bind_text(insertStatement, 7, (creater_userID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (tag as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (dateString as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("SQL \(tableName) Successfully inserted row.")
            } else {
                print("SQL \(tableName) Could not insert row.")
            }
        } else {
            print("SQL INSERT \(tableName) statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    func deleteSheets(neededProjectID : String, sheetID : String, tableName: String, completion: @escaping ((Bool) -> ())) {
        let queryStatementString = "DELETE FROM \(tableName) WHERE projectId = '\(neededProjectID)' AND sheetID = '\(sheetID)';"
        var updateStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, queryStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("SQL \(tableName) Successfully replace row.")
                } else {
                    print("SQL \(tableName) Could not replace row.")
                }
              } else {
                  print("SQL Replace \(tableName) statement could not be prepared.")
              }
              sqlite3_finalize(updateStatement)
        completion(true)
    }
    func readSheetsListType(sheetsListEntry : sheetsListType, neededProjectID : String, tableName: String, completion: @escaping (([sheetsListType],sheetsListType) -> ())) {
        let queryStatementString = "SELECT * FROM \(tableName) WHERE projectId = '\(neededProjectID)';"
//        let queryStatementString = "SELECT * FROM \(tableName);"
        var queryStatement: OpaquePointer? = nil
        var array : [sheetsListType] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let _ = sqlite3_column_text(queryStatement, 1) else {return}
                let projectId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                if neededProjectID == projectId{
                    guard let _ = sqlite3_column_text(queryStatement, 2) else {return}
                    let sheetId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    guard let _ = sqlite3_column_text(queryStatement, 3) else {return}
                    let thumbnailImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                    guard let _ = sqlite3_column_text(queryStatement, 4) else {return}
                    let originalImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                    guard let _ = sqlite3_column_text(queryStatement, 5) else {return}
                    let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                    guard let _ = sqlite3_column_text(queryStatement, 6) else {return}
                    let versionnumber = sqlite3_column_int(queryStatement, 6)
                    guard let _ = sqlite3_column_text(queryStatement, 7) else {return}
                    let creater_userID = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                    guard let _ = sqlite3_column_text(queryStatement, 8) else {return}
                    let tag = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                    guard let _ = sqlite3_column_text(queryStatement, 9) else {return}
                    let lastupdated = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                    
                    let image = UIImage(systemName: "camera")
                        if let thumbnailImageData = Data(base64Encoded: thumbnailImage) {

                            if let originalImageData = Data(base64Encoded: originalImage) {

                                let date = lastupdated.getAsDateFull()
                                array.append(sheetsListType(sheetId: sheetId, thumbnailImage: thumbnailImageData, thumbnailCompressedImage: image!,OriginalImage: originalImageData, title: title, versionnumber: Int(versionnumber), creater_userID: creater_userID, tag: tag, lastupdated: date, isAvailableOffline: true))
                            }
                        }
                    }
            }
        } else {
            print("SQL SELECT \(tableName) statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        completion(array,sheetsListEntry)
    }
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Markers
    func insert(projectId : String, plmID: String, sheetID : String, sheetName: String, markupName : String, date: String, createdByUserID: String, createdByUserName: String, access: String, lastupdated: String, type : String, originalFrameRectX: CGFloat, originalFrameRectY: CGFloat, originalFrameRectWidth: CGFloat, originalFrameRectHeight: CGFloat, originalStrokeWidth: CGFloat, originalStrokeColor : String, originalFillColor: String, originalAngle: CGFloat, originalLayerPath: String, originalRullerPosition1X: CGFloat, originalRullerPosition1Y: CGFloat, originalRullerPosition2X: CGFloat, originalRullerPosition2Y: CGFloat, text : String, imageURLID: String, markerimage: UIImage, areaShown : Bool, breadthShown : Bool, lengthShown : Bool, isLocked : Bool, thisMarkerID : String, state : Int, typeStr : String, tableName: String){
    
        let imageData = markerimage.jpegData(compressionQuality: 1)
        let encodedImageString = imageData?.base64EncodedString()
        
        let insertStatementString = "INSERT INTO \(tableName) (Id, projectId, plmID, sheetID, sheetName, markupName, date, createdByUserID, createdByUserName, access, lastupdated, type, originalFrameRectX, originalFrameRectY, originalFrameRectWidth, originalFrameRectHeight, originalStrokeWidth, originalStrokeColor, originalFillColor, originalAngle, originalLayerPath, originalRullerPosition1X, originalRullerPosition1Y, originalRullerPosition2X, originalRullerPosition2Y, text, imageURLID, markerimage, areaShown, breadthShown, lengthShown, isLocked, thisMarkerID, state, typeStr) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (projectId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (plmID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (sheetID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (sheetName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (markupName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (createdByUserID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (createdByUserName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (access as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (lastupdated as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, (type as NSString).utf8String, -1, nil)
            
            sqlite3_bind_double(insertStatement, 12, Double(originalFrameRectX))
            sqlite3_bind_double(insertStatement, 13, Double(originalFrameRectY))
            sqlite3_bind_double(insertStatement, 14, Double(originalFrameRectWidth))
            sqlite3_bind_double(insertStatement, 15, Double(originalFrameRectHeight))
            sqlite3_bind_double(insertStatement, 16, Double(originalStrokeWidth))
            
            sqlite3_bind_text(insertStatement, 17, (originalStrokeColor as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 18, (originalFillColor as NSString).utf8String, -1, nil)
            
            sqlite3_bind_double(insertStatement, 19, Double(originalAngle))
            
            sqlite3_bind_text(insertStatement, 20, (originalLayerPath as NSString).utf8String, -1, nil)
            
            sqlite3_bind_double(insertStatement, 21, Double(originalRullerPosition1X))
            sqlite3_bind_double(insertStatement, 22, Double(originalRullerPosition1Y))
            sqlite3_bind_double(insertStatement, 23, Double(originalRullerPosition2X))
            sqlite3_bind_double(insertStatement, 24, Double(originalRullerPosition2Y))
            
            sqlite3_bind_text(insertStatement, 25, (text as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 26, (imageURLID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 27, (encodedImageString! as NSString).utf8String, -1, nil)
            
            sqlite3_bind_int(insertStatement, 28, Int32(areaShown == true ? 1 : 0))
            sqlite3_bind_int(insertStatement, 29, Int32(breadthShown == true ? 1 : 0))
            sqlite3_bind_int(insertStatement, 30, Int32(lengthShown == true ? 1 : 0))
            sqlite3_bind_int(insertStatement, 31, Int32(isLocked == true ? 1 : 0))
            
            sqlite3_bind_text(insertStatement, 32, (thisMarkerID as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 33, Int32(state))
            sqlite3_bind_text(insertStatement, 34, (typeStr as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("SQL \(tableName) Successfully inserted row.")
            } else {
                print("SQL \(tableName) Could not insert row.")
            }
        } else {
            print("SQL INSERT \(tableName) statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    func insertDraft(projectId : String, plmID: String, sheetID : String, sheetName: String, markupName : String, date: String, createdByUserID: String, createdByUserName: String, access: String, lastupdated: String, type : String, originalFrameRectX: CGFloat, originalFrameRectY: CGFloat, originalFrameRectWidth: CGFloat, originalFrameRectHeight: CGFloat, originalStrokeWidth: CGFloat, originalStrokeColor : String, originalFillColor: String, originalAngle: CGFloat, originalLayerPath: String, originalRullerPosition1X: CGFloat, originalRullerPosition1Y: CGFloat, originalRullerPosition2X: CGFloat, originalRullerPosition2Y: CGFloat, text : String, imageURLID: String, markerimage: UIImage, areaShown : Bool, breadthShown : Bool, lengthShown : Bool, isLocked : Bool, thisMarkerID : String, state : Int, tableName: String){
    
        let queryStatementString = "SELECT * FROM \(tableName) WHERE projectId = '\(projectId)' AND sheetID = '\(sheetID)' AND thisMarkerID = '\(thisMarkerID)';"
        var queryStatement: OpaquePointer? = nil
        var found = false
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                found = true
                break
            }
        }
        if found
        {
            let imageData = markerimage.jpegData(compressionQuality: 1)
            let encodedImageString = imageData?.base64EncodedString()
            let insertStatementString = "UPDATE \(tableName) SET projectId = '\(projectId)', plmID = '\(plmID)', sheetID = '\(sheetID)', sheetName = '\(sheetName)', markupName = '\(markupName)', date = '\(date)', createdByUserID = '\(createdByUserID)', createdByUserName = '\(createdByUserName)', access = '\(access)', lastupdated = '\(lastupdated)', type = '\(type)', originalFrameRectX = '\(originalFrameRectX)', originalFrameRectY = '\(originalFrameRectY)', originalFrameRectWidth = '\(originalFrameRectWidth)', originalFrameRectHeight = '\(originalFrameRectHeight)', originalStrokeWidth = '\(originalStrokeWidth)', originalStrokeColor = '\(originalStrokeColor)', originalFillColor = '\(originalFillColor)', originalAngle = '\(originalAngle)', originalLayerPath = '\(originalLayerPath)', originalRullerPosition1X = '\(originalRullerPosition1X)', originalRullerPosition1Y = '\(originalRullerPosition1Y)', originalRullerPosition2X = '\(originalRullerPosition2X)', originalRullerPosition2Y = '\(originalRullerPosition2Y)', text = '\(text)', imageURLID = '\(imageURLID)', markerimage = '\(encodedImageString!)', areaShown = '\(areaShown)', breadthShown = '\(breadthShown)', lengthShown = '\(lengthShown)', isLocked = '\(isLocked)', thisMarkerID = '\(thisMarkerID)', state = '\(state)' WHERE projectId = '\(projectId)' AND sheetID = '\(sheetID)' AND thisMarkerID = '\(thisMarkerID)';"
            var updateStatement: OpaquePointer? = nil
             if sqlite3_prepare_v2(db, insertStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                        print("SQL \(tableName) Successfully replace row.")
                    } else {
                        print("SQL \(tableName) Could not replace row.")
                    }
                  } else {
                      print("SQL Replace \(tableName) statement could not be prepared.")
                  }
                  sqlite3_finalize(updateStatement)
        }
        else if !found
        {
            let imageData = markerimage.jpegData(compressionQuality: 1)
            let encodedImageString = imageData?.base64EncodedString()
            
            let insertStatementString = "INSERT INTO \(tableName) (Id, projectId, plmID, sheetID, sheetName, markupName, date, createdByUserID, createdByUserName, access, lastupdated, type, originalFrameRectX, originalFrameRectY, originalFrameRectWidth, originalFrameRectHeight, originalStrokeWidth, originalStrokeColor, originalFillColor, originalAngle, originalLayerPath, originalRullerPosition1X, originalRullerPosition1Y, originalRullerPosition2X, originalRullerPosition2Y, text, imageURLID, markerimage, areaShown, breadthShown, lengthShown, isLocked, thisMarkerID, state) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (projectId as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (plmID as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (sheetID as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (sheetName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (markupName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, (date as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, (createdByUserID as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, (createdByUserName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 9, (access as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 10, (lastupdated as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 11, (type as NSString).utf8String, -1, nil)
                
                sqlite3_bind_double(insertStatement, 12, Double(originalFrameRectX))
                sqlite3_bind_double(insertStatement, 13, Double(originalFrameRectY))
                sqlite3_bind_double(insertStatement, 14, Double(originalFrameRectWidth))
                sqlite3_bind_double(insertStatement, 15, Double(originalFrameRectHeight))
                sqlite3_bind_double(insertStatement, 16, Double(originalStrokeWidth))
                
                sqlite3_bind_text(insertStatement, 17, (originalStrokeColor as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 18, (originalFillColor as NSString).utf8String, -1, nil)
                
                sqlite3_bind_double(insertStatement, 19, Double(originalAngle))
                
                sqlite3_bind_text(insertStatement, 20, (originalLayerPath as NSString).utf8String, -1, nil)
                
                sqlite3_bind_double(insertStatement, 21, Double(originalRullerPosition1X))
                sqlite3_bind_double(insertStatement, 22, Double(originalRullerPosition1Y))
                sqlite3_bind_double(insertStatement, 23, Double(originalRullerPosition2X))
                sqlite3_bind_double(insertStatement, 24, Double(originalRullerPosition2Y))
                
                sqlite3_bind_text(insertStatement, 25, (text as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 26, (imageURLID as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 27, (encodedImageString! as NSString).utf8String, -1, nil)
                
                sqlite3_bind_int(insertStatement, 28, Int32(areaShown == true ? 1 : 0))
                sqlite3_bind_int(insertStatement, 29, Int32(breadthShown == true ? 1 : 0))
                sqlite3_bind_int(insertStatement, 30, Int32(lengthShown == true ? 1 : 0))
                sqlite3_bind_int(insertStatement, 31, Int32(isLocked == true ? 1 : 0))
                
                sqlite3_bind_text(insertStatement, 32, (thisMarkerID as NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 33, Int32(state))
                
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("SQL \(tableName) Successfully inserted row.")
                } else {
                    print("SQL \(tableName) Could not insert row.")
                }
            } else {
                print("SQL INSERT \(tableName) statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    }
    func readMarkersListType(neededProjectID : String, neededsheetID : String, tableName: String, completion: @escaping (([savedMarkupsType]) -> ())) {
        let queryStatementString = "SELECT * FROM \(tableName) WHERE projectId = '\(neededProjectID)' AND sheetID = '\(neededsheetID)';"
        var queryStatement: OpaquePointer? = nil
        var array : [savedMarkupsType] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let _ = sqlite3_column_text(queryStatement, 1) else {return}
                let projectId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                if neededProjectID == projectId{
                    guard let _ = sqlite3_column_text(queryStatement, 2) else {return}
                    let plmID = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    guard let _ = sqlite3_column_text(queryStatement, 3) else {return}
                    let sheetID = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                    guard let _ = sqlite3_column_text(queryStatement, 4) else {return}
                    let sheetName = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                    guard let _ = sqlite3_column_text(queryStatement, 5) else {return}
                    let markupName = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                    guard let _ = sqlite3_column_text(queryStatement, 6) else {return}
                    let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                    guard let _ = sqlite3_column_text(queryStatement, 7) else {return}
                    let createdByUserID = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                    guard let _ = sqlite3_column_text(queryStatement, 8) else {return}
                    let createdByUserName = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                    guard let _ = sqlite3_column_text(queryStatement, 9) else {return}
                    let access = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                    guard let _ = sqlite3_column_text(queryStatement, 10) else {return}
                    let lastupdated = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                    guard let _ = sqlite3_column_text(queryStatement, 11) else {return}
                    let type = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
                    
                    let originalFrameRectX = sqlite3_column_double(queryStatement, 12)
                    let originalFrameRectY = sqlite3_column_double(queryStatement, 13)
                    let originalFrameRectWidth = sqlite3_column_double(queryStatement, 14)
                    let originalFrameRectHeight = sqlite3_column_double(queryStatement, 15)
                    let originalStrokeWidth = sqlite3_column_double(queryStatement, 16)
                    
                    guard let _ = sqlite3_column_text(queryStatement, 17) else {return}
                    let originalStrokeColor = String(describing: String(cString: sqlite3_column_text(queryStatement, 17)))
                    guard let _ = sqlite3_column_text(queryStatement, 18) else {return}
                    let originalFillColor = String(describing: String(cString: sqlite3_column_text(queryStatement, 18)))
                    let originalAngle = sqlite3_column_double(queryStatement, 19)
                    
                    guard let _ = sqlite3_column_text(queryStatement, 20) else {return}
                    let originalLayerPath = String(describing: String(cString: sqlite3_column_text(queryStatement, 20)))
                    let originalRullerPosition1X = sqlite3_column_double(queryStatement, 21)
                    let originalRullerPosition1Y = sqlite3_column_double(queryStatement, 22)
                    let originalRullerPosition2X = sqlite3_column_double(queryStatement, 23)
                    let originalRullerPosition2Y = sqlite3_column_double(queryStatement, 24)
                    
                    guard let _ = sqlite3_column_text(queryStatement, 25) else {return}
                    let text = String(describing: String(cString: sqlite3_column_text(queryStatement, 25)))
                    guard let _ = sqlite3_column_text(queryStatement, 26) else {return}
                    let imageURLID = String(describing: String(cString: sqlite3_column_text(queryStatement, 26)))
                    guard let _ = sqlite3_column_text(queryStatement, 27) else {return}
                    let encodedImageString = String(describing: String(cString: sqlite3_column_text(queryStatement, 27)))
                    
                    let areaShown = sqlite3_column_int(queryStatement, 28) == 1 ? true : false
                    let breadthShown = sqlite3_column_int(queryStatement, 29) == 1 ? true : false
                    let lengthShown = sqlite3_column_int(queryStatement, 30) == 1 ? true : false
                    let isLocked = sqlite3_column_int(queryStatement, 31) == 1 ? true : false
                    
                    guard let _ = sqlite3_column_text(queryStatement, 32) else {return}
                    let thisMarkerID = String(describing: String(cString: sqlite3_column_text(queryStatement, 32)))
                    
                    let state = sqlite3_column_int(queryStatement, 33) == 1 ? markerStateType.PUBLISHED : markerStateType.DRAFT
                    
                    var typeStr = "plansfile"
                    if sqlite3_column_text(queryStatement, 34) != nil{
                         typeStr = String(describing: String(cString: sqlite3_column_text(queryStatement, 34)))
                    }
                    
                    var found = -1
                    for i in 0..<array.count
                    {
                        if array[i].plmID == plmID
                        {
                            found = i
                            break
                        }
                    }
                    var typeObj = PLMShapeType.RECT
                    if type == "unknown"{typeObj = .unknown}
                    if type == "RECT"{typeObj = .RECT}
                    if type == "ROUND"{typeObj = .ROUND}
                    if type == "ARCS"{typeObj = .ARCS}
                    if type == "ARROW"{typeObj = .ARROW}
                    if type == "IMAGE"{typeObj = .IMAGE}
                    if type == "TEXT"{typeObj = .TEXT}
                    if type == "PATH"{typeObj = .PATH}
                    if type == "HIGHLIGHTER"{typeObj = .HIGHLIGHTER}
                    if type == "RULLER"{typeObj = .RULLER}
                    
                    var image = UIImage(systemName: "camera")!
                    if let ImageData = Data(base64Encoded: encodedImageString) {
                        image = UIImage(data: ImageData) ?? UIImage(systemName: "camera")!
                    }
                    if found == -1
                    {
                        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:originalStrokeColor), drawableFillColor: self.getColor(clrstr: originalFillColor), drawableAngle: originalAngle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
                        let b = originalMarkerInfoType(originalFrameRect: CGRect(x: CGFloat(originalFrameRectX), y: CGFloat(originalFrameRectY), width: CGFloat(originalFrameRectWidth), height: CGFloat(originalFrameRectHeight)), originalStrokeWidth: CGFloat(originalStrokeWidth), originalStrokeColor: self.getColor(clrstr:originalStrokeColor), originalFillColor: self.getColor(clrstr:originalFillColor), originalAngle: originalAngle, originalLayerPoints: [], originalLayerPath: originalLayerPath, originalRullerPosition: _2PointsType(point1: CGPoint(x:  CGFloat(originalRullerPosition1X), y:  CGFloat(originalRullerPosition1Y)), point2: CGPoint(x:  CGFloat(originalRullerPosition2X), y:  CGFloat(originalRullerPosition2Y))))
                        let c = markedInfoType(thisMarkerID: thisMarkerID, type: typeObj, drawableDetails: a, originalDetails: b, text: text, image: imageMarkerType(image: image, urlID: imageURLID), measurmnetsVisible: MeasurmentsVisibleType(areaShown: areaShown, lengthShown: lengthShown, breadthShown: breadthShown), isLocked: isLocked)
                        let d = savedMarkupsType(typeStr: typeStr, plmID: plmID, sheetID: sheetID, sheetName: sheetName, markupName: markupName, date: date, createdByUserID: createdByUserID, createdByUserName: createdByUserName, access: access, markedInfos: [c], lastUpdated: lastupdated, state: state)
                        array.append(d)
                    }
                    else{
                        let a = drawableMarkerInfoType(drawableframeRect: .zero, drawableStrokeWidth: 0, drawableStrokeColor: self.getColor(clrstr:originalStrokeColor), drawableFillColor: self.getColor(clrstr: originalFillColor), drawableAngle: originalAngle, drawableLayerPoints: [],drawableRullerPosition : _2PointsType(point1: .zero, point2: .zero))
                        let b = originalMarkerInfoType(originalFrameRect: CGRect(x: CGFloat(originalFrameRectX), y: CGFloat(originalFrameRectY), width: CGFloat(originalFrameRectWidth), height: CGFloat(originalFrameRectHeight)), originalStrokeWidth: CGFloat(originalStrokeWidth), originalStrokeColor: self.getColor(clrstr:originalStrokeColor), originalFillColor: self.getColor(clrstr:originalFillColor), originalAngle: originalAngle, originalLayerPoints: [], originalLayerPath: originalLayerPath, originalRullerPosition: _2PointsType(point1: CGPoint(x:  CGFloat(originalRullerPosition1X), y:  CGFloat(originalRullerPosition1Y)), point2: CGPoint(x:  CGFloat(originalRullerPosition2X), y:  CGFloat(originalRullerPosition2Y))))
                        let c = markedInfoType(thisMarkerID: thisMarkerID, type: typeObj, drawableDetails: a, originalDetails: b, text: text, image: imageMarkerType(image: image, urlID: imageURLID), measurmnetsVisible: MeasurmentsVisibleType(areaShown: areaShown, lengthShown: lengthShown, breadthShown: breadthShown), isLocked: isLocked)
                        array[found].markedInfos.append(c)
                    }
                    }
            }
        } else {
            print("SQL SELECT \(tableName) statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        completion(array)
    }
    func readMarkersListReturnPLM_ID_Present(neededProjectID : String, neededplmID : String, tableName: String, completion: @escaping ((Bool) -> ())) {
        let queryStatementString = "SELECT * FROM \(tableName) WHERE projectId = '\(neededProjectID)' AND plmID = '\(neededplmID)';"
        var queryStatement: OpaquePointer? = nil
        var flag : Bool = false
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let _ = sqlite3_column_text(queryStatement, 1) else {return}
                let projectId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                if neededProjectID == projectId{
                    guard let _ = sqlite3_column_text(queryStatement, 2) else {return}
                    let plmID = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    if plmID == neededplmID{
                        flag = true
                    }
                }
            }
        } else {
            print("SQL SELECT \(tableName) statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        completion(flag)
    }
    func deleteMarker(neededProjectID : String, thisMarkerID : String, tableName: String, completion: @escaping ((Bool) -> ())) {
        let queryStatementString = "DELETE FROM \(tableName) WHERE projectId = '\(neededProjectID)' AND thisMarkerID = '\(thisMarkerID)';"
        var updateStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, queryStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("SQL \(tableName) Successfully replace row.")
                } else {
                    print("SQL \(tableName) Could not replace row.")
                }
              } else {
                  print("SQL Replace \(tableName) statement could not be prepared.")
              }
              sqlite3_finalize(updateStatement)
        completion(true)
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}


// add text 2nd time not reflecting
// draw not recorded
// rotation not recorded
// after publishing it should be deleted all draft markers of this sheet before refresh and new local save






