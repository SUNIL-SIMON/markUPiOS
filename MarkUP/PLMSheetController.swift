//
//  PLMSheetController.swift
//  PlanMarkup
//
//  Created by SIMON on 17/01/22.
//

import Foundation
import SwiftUI
import UIKit
public struct PLMSheetController: UIViewControllerRepresentable {
    
    public func makeUIViewController(context: Context) -> PLMSheetBaseView {
            return sheetBaseView
    }
    public func updateUIViewController(_ uiViewController: PLMSheetBaseView, context: Context){
            
    }
    public var identifier = ""
    public let sheetBaseView = PLMSheetBaseView()
    public var sheetDataSource : PLMSheetDataSource
    
    public init(identifier : String,sheetDataSource: PLMSheetDataSource){
        self.identifier = identifier
        self.sheetDataSource = sheetDataSource
    }

}
