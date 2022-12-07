//
//  PLMPlanListingBulletView.swift
//  PlanMarkup
//
//  Created by SIMON on 25/01/22.
//

import Foundation
import SwiftUI


import AppearanceFramework
public struct PLMPlanListingBulletView: View {
    @ObservedObject var presenter : PLMPresenter
    @ObservedObject var plansListingDataSource : PLMPlansListingDataSource
    var sheetView : PLMSheetView?
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    public init(presenterParam : PLMPresenter, plansListingDataSourceParam : PLMPlansListingDataSource, sheetViewParam : PLMSheetView) {
        presenter = presenterParam
        plansListingDataSource = plansListingDataSourceParam
        sheetView = sheetViewParam
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0){
                VStack{
                    HStack{
                        Spacer()
                        NavigationLink("", destination: sheetView, isActive: $plansListingDataSource.shouldSheetBepresented)
                            .background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
                        Spacer()
                    }
                }.frame(height: 0)
                
                HStack{
                    HStack {
                        Spacer()
                        Text("").foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                        Spacer()
//                        Divider()
                    }
                    .frame(width: (geometry.size.width/10))
                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                    HStack {
                        Spacer()
                        Text("thumbnail")
                        Spacer()
//                        Divider()
                    }.frame(width: iPad ? geometry.size.width/5 : geometry.size.width/4)
                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                    HStack {
                        Spacer()
                        Text("Sheet Name")
                        Spacer()
//                        Divider()
                    }.frame(width: (geometry.size.width - (geometry.size.width/10 + geometry.size.width/5)) * 0.6)
                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                    HStack {
                        Spacer()
                        Text("Version")
                        Spacer()
//                        Divider()
                    }.frame(width: (geometry.size.width - (geometry.size.width/10 + geometry.size.width/5)) * 0.4)
                    Spacer()
                        
                    }.frame(height : 50)
                    .border(TCAppearance.shared.theme.change.seperatorLineColor, width: 0.5)
                Divider()
                ScrollView {
                    ForEach(plansListingDataSource.sheets, id: \.id) { thumbnail in
                        VStack(alignment: .leading, spacing: 0){
                            Button {
                                presenter.sheetDataSource.sheetViewController?.sheetBaseView.clearAll()
                                presenter.sheetDataSource.selectedThumbnail = thumbnail
                                presenter.sheetDataSource.sheetViewController?.sheetBaseView.selectedThumbnail = thumbnail
                                presenter.sheetDataSource.sheetViewController?.sheetBaseView.updateData()
                                plansListingDataSource.shouldSheetBepresented = true
                                presenter.navBarHidden = true
                            } label: {
                                HStack{
                                    HStack {
                                        Spacer()
                                        Text("\((plansListingDataSource.sheets.firstIndex(of: thumbnail) ?? 0) + 1)").foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width/10)
                                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                                    HStack {
                                        if let profileImageUnwrapped = thumbnail.thumbnailCompressedImage {
                                            Image(uiImage: profileImageUnwrapped)
                                                  .resizable()
                                                  .aspectRatio(contentMode: .fit)
                                        } else {
                                        
                                        }
                                    }.frame(width: geometry.size.width/5)
                                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                                    HStack {
                                        Spacer()
                                        Text("\(thumbnail.title)").foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                                        Spacer()
                                    }
                                    .frame(width: (geometry.size.width - (geometry.size.width/10 + geometry.size.width/5)) * 0.6)
                                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                                    HStack {
//                                        Spacer()
                                        Text("V\(thumbnail.versionnumber)").foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
//                                        Spacer()
                                    }
                                    .frame(width: (geometry.size.width - (geometry.size.width/10 + geometry.size.width/5)) * 0.4)
                                   
                                }
                               
                            }.frame(height: 40)
                            Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                        }
                    }
                }
            }
        }.background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
    }
}
public struct PLMPlanListingBulletViewForVersions: View {
    @ObservedObject var presenter : PLMPresenter
    @ObservedObject var plansListingDataSource : PLMPlansListingDataSource
    var sheetView : PLMSheetView?
//    var selectedSheetForVersionViewList : sheetsListWithVersionType?
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    public init(presenterParam : PLMPresenter, plansListingDataSourceParam : PLMPlansListingDataSource, sheetViewParam : PLMSheetView) {
        presenter = presenterParam
        plansListingDataSource = plansListingDataSourceParam
        sheetView = sheetViewParam
//        selectedSheetForVersionViewList = selectedSheetForVersionViewListParam
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0){
                VStack{
                    HStack{
                        Spacer()
                        NavigationLink("", destination: sheetView, isActive: $plansListingDataSource.shouldSheetBepresented)
                            .background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
                        Spacer()
                    }
                }.frame(height: 0)
                
                HStack{
                    HStack {
                        Spacer()
                        Text("").foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                        Spacer()
//                        Divider()
                    }
                    .frame(width: (geometry.size.width/10))
                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                    HStack {
                        Spacer()
                        Text("thumbnail")
                        Spacer()
//                        Divider()
                    }.frame(width: iPad ? geometry.size.width/5 : geometry.size.width/4)
                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                    HStack {
                        Spacer()
                        Text("Sheet Name")
                        Spacer()
//                        Divider()
                    }.frame(width: (geometry.size.width - (geometry.size.width/10 + geometry.size.width/5)) * 0.6)
                    Divider().background(TCAppearance.shared.theme.change.seperatorLineColor)
                    HStack {
                        Spacer()
                        Text("Version")
                        Spacer()
//                        Divider()
                    }.frame(width: (geometry.size.width - (geometry.size.width/10 + geometry.size.width/5)) * 0.4)
                    Spacer()
                        
                    }.frame(height : 50)
                    .border(TCAppearance.shared.theme.change.seperatorLineColor, width: 0.5)
                Divider()
            }
        }.background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
    }
}
