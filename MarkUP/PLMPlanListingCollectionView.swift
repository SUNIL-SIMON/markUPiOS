//
//  PLMPlanListingCollectionView.swift
//  PlanMarkup
//
//  Created by SIMON on 17/01/22.
//

import Foundation
import SwiftUI


import AppearanceFramework
public struct PLMPlanListingCollectionView: View {

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
        let list = plansListingDataSource.sheetsWithVersions
        let v = (plansListingDataSource.sheetsWithVersions.count)/3
        let v1 = CGFloat(plansListingDataSource.sheetsWithVersions.count)/3
        let lines = CGFloat(v) < v1 ? (v + 1) : v
        let lastLineCount = plansListingDataSource.sheetsWithVersions.count - (v * 3)
        if plansListingDataSource.sheetsWithVersions.count > 0{
            VStack{
                HStack{
                    Spacer()
                    NavigationLink("", destination: sheetView, isActive: $plansListingDataSource.shouldSheetBepresented)
                        .background(TCAppearance.shared.theme.change.tableViewBackgroundColor)

                    Spacer()
                }
            }.frame(height: 0)
            GeometryReader { geometry in
                ZStack{
                VStack(alignment: .leading, spacing : 0){
                    Divider()
                     ScrollView{
                         if iPad{
                             LazyVStack{
                                 ForEach(0..<lines,id: \.self) { index in
                                     if (index<v){
                                         VStack(alignment: .leading){
                                             Spacer().frame(width: geometry.size.width,height: geometry.size.width*0.0625)
                                             HStack(alignment: .top, spacing: 0){
                                                 Spacer().frame(width: geometry.size.width*0.0625)//.background(Color.green)

                                                 VStack{

                                                     let b = plansListingDataSource.getSheetsWithVersions(index: index*3)
                                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource:plansListingDataSource, thumbnail :  b, thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[index*3]).frame(width: geometry.size.width*0.25,height: geometry.size.width*0.25).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                                 }

                                                 Spacer().frame(width: geometry.size.width*0.0625)//.background(Color.green)

                                                 VStack{
                                                     let b = plansListingDataSource.getSheetsWithVersions(index:(index*3)+1)
                                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource: plansListingDataSource, thumbnail :  b,thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[(index*3)+1]).frame(width: geometry.size.width*0.25,height: geometry.size.width*0.25).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                                 }

                                                 Spacer().frame(width: geometry.size.width*0.0625)//.background(Color.green)

                                                 VStack{
                                                     let b = plansListingDataSource.getSheetsWithVersions(index:(index*3)+2)
                                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource: plansListingDataSource, thumbnail :  b,thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[(index*3)+2]).frame(width: geometry.size.width*0.25,height: geometry.size.width*0.25).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                                 }

                                                 Spacer().frame(width: geometry.size.width*0.0625)

                                             }
                                         }
                                     }
                                     else if lastLineCount == 1{
                                         VStack(alignment: .leading){
                                             Spacer().frame(width: geometry.size.width,height: geometry.size.width*0.0625)
                                             HStack(alignment: .top, spacing: 0){
                                                 Spacer().frame(width: geometry.size.width*0.0625)//.background(Color.green)

                                                 VStack{
                                                     let b = plansListingDataSource.getSheetsWithVersions(index:(index*3))
                                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource: plansListingDataSource, thumbnail :  b,thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[(index*3)]).frame(width: geometry.size.width*0.25,height: geometry.size.width*0.25).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                                 }

                                                 Spacer().frame(width: geometry.size.width*0.05)
                                                 Spacer().frame(width: geometry.size.width*0.05)
                                             }
                                         }
                                     }
                                     else {
                                         VStack(alignment: .leading){
                                             Spacer().frame(width: geometry.size.width,height: geometry.size.width*0.0625)
                                             HStack(alignment: .top, spacing: 0){
                                                 Spacer().frame(width: geometry.size.width*0.0625)//.background(Color.green)

                                                 VStack{
                                                     let b = plansListingDataSource.getSheetsWithVersions(index:(index*3))
                                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource: plansListingDataSource, thumbnail :  b,thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[(index*3)]).frame(width: geometry.size.width*0.25,height: geometry.size.width*0.25).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                                 }

                                                 Spacer().frame(width: geometry.size.width*0.0625)//.background(Color.green)

                                                 VStack{

                                                     let b = plansListingDataSource.getSheetsWithVersions(index:(index*3)+1)
                                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource: plansListingDataSource, thumbnail :  b,thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[(index*3)+1]).frame(width: geometry.size.width*0.25,height: geometry.size.width*0.25).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                                 }

                                                 Spacer().frame(width: geometry.size.width*0.05)
                                             }
                                         }
                                     }
                                 }
                             }
                         }
                         else{
                             let column = Array(repeating: GridItem(.flexible(), spacing: geometry.size.width*0.06), count: 2)
                             LazyVGrid(columns: column, spacing: geometry.size.width*0.06){
                                 ForEach(0..<plansListingDataSource.sheetsWithVersions.count,id:\.self){
                                     index in
                                     let b = plansListingDataSource.getSheetsWithVersions(index:index)
                                     PLMPlansListingCellView(presenter: presenter, plansListingDataSource: plansListingDataSource, thumbnail : b,thumbnailwithrespVersions : plansListingDataSource.sheetsWithVersions[index]).frame(width: geometry.size.width*0.41,height: geometry.size.width*0.5).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                                 }
                             }.padding(geometry.size.width * 0.06)
                         }
                     }
                     .background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
             }
                }.background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
            }
        }
        else{
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Text("No Sheets's To Show, please Add")
                        .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                    Spacer()
                }
                Spacer()
            }
            .background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
        }
    }
}
public struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    public var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}
