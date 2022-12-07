//
//  PLMPresenter.swift
//  MarkUP
//
//  Created by SIMON on 06/12/22.
//

import Foundation
import UIKit
public class PLMPresenter : ObservableObject
{
    public static var shared = PLMPresenter()
    public var plansListingDataSource = PLMPlansListingDataSource()
    @Published public var showMasterProgress = false
    @Published public var showProgress = false
    @Published public var navBarHidden = false
    public var sheetDataSource = PLMSheetDataSource()
    init(){
    }
    
}
