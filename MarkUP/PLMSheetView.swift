//
//  PLMSheetView.swift
//  PlanMarkup
//
//  Created by SIMON on 17/01/22.
//

import Foundation
import SwiftUI
import AppearanceFramework
public struct PLMSheetView: View {
    @ObservedObject var presenter : PLMPresenter
    @ObservedObject var sheetDataSource : PLMSheetDataSource
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    public init(presenterParam : PLMPresenter, sheetDataSourceParam : PLMSheetDataSource) {
        presenter = presenterParam
        sheetDataSource = sheetDataSourceParam
        if sheetDataSource.sheetViewController == nil{
            let t = PLMSheetController(identifier: "", sheetDataSource: sheetDataSource)
            sheetDataSource.sheetViewController = t
            presenter.plansListingDataSource.sheetViewController = t
        }
    }
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            presenter.navBarHidden = false
//            sheetDataSource.sheetViewController?.sheetBaseView.markerLayer.rotator.alpha = 0
        }) {
            HStack {
                Image(systemName:"chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                Text("Back")
                    .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                    .frame(height: 20)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
        }  .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
           
    }
    
    
    var titleBtn : some View {
        
        Button(action: {
           
        }) {
            HStack {
                Text(sheetDataSource.selectedThumbnail.title == "" ? "NA" : sheetDataSource.selectedThumbnail.title).foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                    .frame(height: 20, alignment: .center)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    
    var refreshBtn : some View {
        HStack (alignment: .center){
            
            Button(action: {

            }) {
                HStack {
                    Image(systemName:"arrow.counterclockwise")
                        .aspectRatio(contentMode: .fit)
                    .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                }
            }

            Button(action: {
                
            }) {
                HStack {
                    Image(systemName:"arrow.clockwise")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                }
            }
        }
        .frame(height: 20)
        .background(TCAppearance.shared.theme.change.tableViewCellColor)
        .cornerRadius(10)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
     
    }
    
    var shareButton : some View {
        Button(action: {
            sheetDataSource.showShare = true
        }) {
            HStack {
                Text("Share").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                    .frame(width: 70 , height: 20)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(TCAppearance.shared.theme.change.actionButtonFillColor).cornerRadius(10)
                    .overlay(
                                  RoundedRectangle(cornerRadius: 10)
                                    .stroke(TCAppearance.shared.theme.change.textActionButtonTextColor, lineWidth: 1)
                                )
        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
//            .disabled(true)
//            .opacity(0.3)
//            .opacity(presenter.appInstallationType == .RFIINTIGRATED ? 0 : 1)
    }
    var attachButton : some View {
        Button(action: {
//            if presenter.presenterAppDelegate != nil{
//                presenter.presenterAppDelegate?.attachPlanMarkup(plm:  presenter.sheetDataSource.selectedThumbnail.OriginalImage)
//                self.presentationMode.wrappedValue.dismiss()
//                sheetDataSource.selectedThumbnail = sheetThumbNailsType(thumbnailImage: dummyImage, OriginalImage: dummyImage,title: "")
//                PLMTabContentsViewModel.shared.shouldHideTabContents = false
//                presenter.navBarHidden = false
//                sheetDataSource.sheetViewController?.sheetBaseView.markerLayer.rotator.alpha = 0
//                presenter.shouldShowPlanAttachmentPicker = false
//            }
            sheetDataSource.showPublishtextView = true
        }) {
            HStack {
                Text("Attach").foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                    .frame(width: 70 , height: 20)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(TCAppearance.shared.theme.change.tableViewCellColor).cornerRadius(10)
                    .overlay(
                                  RoundedRectangle(cornerRadius: 10)
                                    .stroke(TCAppearance.shared.theme.change.textLabelColor, lineWidth: 1)
                                )
        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    var publishButton : some View {

        Button(action: {
            sheetDataSource.showPublishtextView = true
        }) {
            HStack {
                Text("Publish").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                    .frame(width: 70 , height: 20)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(TCAppearance.shared.theme.change.actionButtonFillColor).cornerRadius(10)
                    .overlay(
                                  RoundedRectangle(cornerRadius: 10)
                                    .stroke(TCAppearance.shared.theme.change.textActionButtonTextColor, lineWidth: 1)
                                )
        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack{
                    sheetDataSource.sheetViewController.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if iPad{
                    VStack{
                        HStack{
                            Spacer().frame(width: 10)
                            btnBack
                            if sheetDataSource.selectedThumbnail.title != ""{
                                Spacer()
                                titleBtn
                            }
                            Spacer()

                                shareButton
//                                publishButton
                            Spacer().frame(width: 10)
                        }
                        .padding(EdgeInsets(top: geometry.safeAreaInsets.top + 5, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                    }
                }else{
                    VStack{
                        ZStack{
                            HStack{
                                Spacer().frame(width: 10)
                                btnBack
                                Spacer()
                            }
                            if sheetDataSource.selectedThumbnail.title != ""{
                                HStack{
                                    Spacer()
                                    titleBtn
                                    Spacer()
                                }
                            }
                        }
                        .padding(EdgeInsets(top:  geometry.safeAreaInsets.top + 5, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                    }
                }
            }
            .background(TCAppearance.shared.theme.change.tableViewBackgroundColor)
            .ignoresSafeArea(.all)
            .disabled(sheetDataSource.showEditMarkertextView || sheetDataSource.showsendtextView || sheetDataSource.scaleSettextView)
            .blur(radius: sheetDataSource.showEditMarkertextView ? 5 : sheetDataSource.showsendtextView ? 5 : sheetDataSource.scaleSettextView ? 5 : 0)
            let _ = print("sheetDataSource.attachmentPickerShown",sheetDataSource.attachmentInsideSheetPickerShown)
            ZStack{
            VStack{
                if iPad{
                    Spacer().frame(height: 50)
                }else{
                    Spacer()
                }
                HStack{
                    Spacer()
                    if sheetDataSource.showEditMarkertextView{
                        PLMTextAlertView(sheetDataSource: sheetDataSource).background(TCAppearance.shared.theme.change.tableViewBackgroundColor).cornerRadius(20).frame(width: iPad ? 500 : 350, height: iPad ? 210 : 170, alignment: .center).shadow( color: TCAppearance.shared.theme.change.tableViewBackgroundColor, radius: 1 )
                            .shadow(radius: 10)
                    }
                    if sheetDataSource.showsendtextView{
                        PLMSendAlertView(sheetDataSource: sheetDataSource).background(TCAppearance.shared.theme.change.tableViewBackgroundColor).cornerRadius(20).frame(width: iPad ? 500 : 350, height: iPad ? 210 : 170, alignment: .center).shadow( color: TCAppearance.shared.theme.change.tableViewBackgroundColor, radius: 1 )
                            .shadow(radius: 10)
                    }
                    if sheetDataSource.showPublishtextView{
                        PLMPublishAlertView(sheetDataSource: sheetDataSource).background(TCAppearance.shared.theme.change.tableViewBackgroundColor).cornerRadius(20).frame(width: iPad ? 500 : 350, height: iPad ? 210 : 170, alignment: .center).shadow( color: TCAppearance.shared.theme.change.tableViewBackgroundColor, radius: 1 )
                            .shadow(radius: 10)
                    }
                    if sheetDataSource.scaleSettextView{
                        PLMScaleAlertView(sheetDataSource: sheetDataSource).background(TCAppearance.shared.theme.change.tableViewBackgroundColor).cornerRadius(20).frame(width: iPad ? 500 : 350, height:  iPad ? sheetDataSource.selectedMeasurmentUnit == sheetDataSource.sizes[2] ? 180 : 260 : sheetDataSource.selectedMeasurmentUnit == sheetDataSource.sizes[2] ? 165 : 230, alignment: .center).shadow( color: TCAppearance.shared.theme.change.tableViewBackgroundColor, radius: 1 )
                            .shadow(radius: 10)
                    }
                    Spacer()
                }
                Spacer()
            }
            if (sheetDataSource.attachmentInsideSheetPickerShown) {
                VStack {
                    if sheetDataSource.imagePickerType == .camera{
//                TCAttachmentImagePickerView(isShown: $sheetDataSource.attachmentPickerShown, selectedImage: $sheetDataSource.selectedImage, sourceType: .camera)
                        TCAttachmentImagePickerView(isShown: $sheetDataSource.attachmentInsideSheetPickerShown, selectedImage: $sheetDataSource.selectedImageOverSheet, sourceType: .camera, slectedVideo: $sheetDataSource.selectedVideo, fileType: .photo)
                        
                        
                    }
                    else{
//                        TCAttachmentImagePickerView(isShown: $sheetDataSource.attachmentPickerShown, selectedImage: $sheetDataSource.selectedImage, sourceType: .library)
                        TCAttachmentImagePickerView(isShown: $sheetDataSource.attachmentInsideSheetPickerShown, selectedImage: $sheetDataSource.selectedImageOverSheet, sourceType: .library, slectedVideo: $sheetDataSource.selectedVideo, fileType: .photo)
                    }
                }
                .background(Color.blue)
                .edgesIgnoringSafeArea(.all)
            }
            }
            .sheet(isPresented: $sheetDataSource.showShare, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems: [sheetDataSource.getSheetAsImage()])
                    })
        }
        .navigationBarHidden(presenter.navBarHidden)
        
    }
}
struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.presentationMode.wrappedValue.dismiss()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
