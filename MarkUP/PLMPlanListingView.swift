//
// PLMPlanListingView.swift
// PlanMarkup
//
// Created by SIMON on 17/01/22.
//
import SwiftUI


import AppearanceFramework
public struct PLMPlanListingView: View {
    
    @ObservedObject var presenter : PLMPresenter
    @ObservedObject var plansListingDataSource : PLMPlansListingDataSource
    var sheetView : PLMSheetView?
    var planListingCollectionView : PLMPlanListingCollectionView?
      var planListingBulletView : PLMPlanListingBulletView?
    @State public var toAvoidNavBug = false
      
    public init(presenterParam : PLMPresenter, plansListingDataSourceParam : PLMPlansListingDataSource, sheetViewParam : PLMSheetView) {
        presenter = presenterParam
        plansListingDataSource = plansListingDataSourceParam
        sheetView = sheetViewParam
        if planListingCollectionView == nil{
          let t = PLMPlanListingCollectionView(presenterParam: presenter, plansListingDataSourceParam: plansListingDataSource, sheetViewParam: sheetViewParam)
          planListingCollectionView = t
        }
        if planListingBulletView == nil{
          let t = PLMPlanListingBulletView(presenterParam: presenter, plansListingDataSourceParam: plansListingDataSource, sheetViewParam: sheetView!)
          planListingBulletView = t
        }
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewBackgroundColor)
        UITableView.appearance().backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewBackgroundColor)
    }
    var addButton : some View {
        HStack{
                Button(action: {
                    plansListingDataSource.attachmenttoAddSheetPickerShown = true
                }) {
                    HStack {
                        Image(systemName:"plus")
                         .aspectRatio(contentMode: .fit)
                         .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                    }
                }.padding(10)
        }
    }
    public var body: some View {
        ZStack{
      VStack(spacing: 0){
          if plansListingDataSource.sheetViewMode == .list{
            planListingBulletView
          }
          else{
            planListingCollectionView
          }
      }
        if (plansListingDataSource.attachmenttoAddSheetPickerShown) {
            VStack {
                if plansListingDataSource.imagePickerType == .camera{

                    TCAttachmentImagePickerView(isShown: $plansListingDataSource.attachmenttoAddSheetPickerShown, selectedImage: $plansListingDataSource.selectedasSheet, sourceType: .camera, slectedVideo: $plansListingDataSource.selectedVideo, fileType: .photo)
                    
                    
                }
                else{

                    TCAttachmentImagePickerView(isShown: $plansListingDataSource.attachmenttoAddSheetPickerShown, selectedImage: $plansListingDataSource.selectedasSheet, sourceType: .library, slectedVideo: $plansListingDataSource.selectedVideo, fileType: .photo)
                }
            }
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
        }
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
          ToolbarItemGroup(placement: .navigationBarTrailing) {
              if !plansListingDataSource.attachmenttoAddSheetPickerShown{
//            Button {
//              plansListingDataSource.sheetViewMode = .thumbnail
//                 } label: {
//                  Image(systemName:"rectangle.grid.2x2")
//                   .aspectRatio(contentMode: .fit)
//                   .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
//                }
//            Button {
//              plansListingDataSource.sheetViewMode = .list
//                } label: {
//                 Image(systemName:"list.bullet")
//                  .aspectRatio(contentMode: .fit)
//                  .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
//                 }
              
              addButton
              }
          }
        }
        .actionSheet(isPresented: $toAvoidNavBug) {ActionSheet(title: Text(""),message: Text(""),buttons: [.cancel {  },.default(Text("")){},.default(Text("")){}])}//THIS STOPS FROM NAVIGATION TO STAY AT LARGE SIZE FOR BEFORE TRANSITIONING TO INLINE TYPE
    }
}



