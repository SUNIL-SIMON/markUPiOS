//
//  PLMPlansListingCellView.swift
//  PlanMarkup
//
//  Created by SIMON on 17/01/22.
//

import Foundation
import SwiftUI


import AppearanceFramework
public struct PLMPlansListingCellView: View {
    @ObservedObject var presenter : PLMPresenter
    var plansListingDataSource : PLMPlansListingDataSource
    var thumbnail : sheetsListType
    var thumbnailwithrespVersions : sheetsListWithVersionType
    public var body: some View {
        Button(action: {
            presenter.sheetDataSource.sheetViewController?.sheetBaseView.clearAll()
            presenter.sheetDataSource.selectedThumbnail = thumbnail
            presenter.sheetDataSource.sheetViewController?.sheetBaseView.selectedThumbnail = thumbnail
            presenter.sheetDataSource.sheetViewController?.sheetBaseView.updateData()
            plansListingDataSource.shouldSheetBepresented = true
            presenter.navBarHidden = true
        }) {
            VStack{
                Spacer().frame(height: 10)
                HStack{
                    Spacer().frame(width: 10)
                    if let profileImageUnwrapped = thumbnail.thumbnailCompressedImage {
                        Image(uiImage: profileImageUnwrapped)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                    } else {
                    
                    }
                    Spacer().frame(width: 10)
                }
                Divider()
                Spacer()
                VStack{
                    Spacer().frame(height: 10)
                    HStack{
                        Button(action: {
                            plansListingDataSource.deleteSheet(sheetID: thumbnail.sheetId)
                        }) {
                            HStack{
                                Image(systemName: "bin.xmark")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                                Spacer().frame(width: 5)
                                Text("Delete").multilineTextAlignment(.leading).font(.system(size: 12)).foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        }
                        Spacer()
                    }
                    Spacer().frame(height: 10)
                }
            }
        }
    }
}
