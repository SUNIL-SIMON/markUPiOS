//
//  PLMTabContentsView.swift
//  Task
//
//  Created by SIMON on 10/11/21.
//

import SwiftUI
import AppearanceFramework
public struct PLMTabContentsView: View {
    @ObservedObject var presenter : PLMPresenter
    var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var plansListingView: PLMPlanListingView?
    var sheetView : PLMSheetView?
   public init(_presenter : PLMPresenter) {
       presenter = _presenter
        if sheetView == nil{
            sheetView = PLMSheetView(presenterParam: presenter, sheetDataSourceParam: presenter.sheetDataSource)
        }
        if plansListingView == nil {
            plansListingView = PLMPlanListingView(presenterParam: presenter, plansListingDataSourceParam: presenter.plansListingDataSource, sheetViewParam: sheetView!)
        }
    }

    public var body: some View {
        let _ = print("TABCONTENTS PAGE RELOADED")
        GeometryReader { geometry in
            ZStack(alignment: .top){
                VStack(spacing: 0) {
                    ZStack{
                        NavigationView {
                            plansListingView
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationBarTitleDisplayMode(.inline)
                        
                    }
                }
                VStack{

                    TCBlurView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
                .disabled(presenter.showMasterProgress ? true : false)
                .opacity(presenter.showMasterProgress ? 1 : 0)
                

                VStack{

                    ProgressIndicator()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
                .disabled((presenter.showProgress || presenter.showMasterProgress) ? true : false)
                .opacity((presenter.showProgress || presenter.showMasterProgress) ? 1 : 0)
                
            }
        }
        .accentColor(TCAppearance.shared.theme.change.selectedColor)
        .background(TCAppearance.shared.theme.change.backgroundColor)
        .disabled((presenter.showProgress || presenter.showMasterProgress) ? true : false)
        .edgesIgnoringSafeArea(.all)
    }
}

