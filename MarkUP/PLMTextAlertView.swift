////
////  PLMTextAlertView.swift
////  Task
////
////  Created by DEEPAKKANNA on 17/11/21.
////
//
import SwiftUI

import AppearanceFramework
public struct PLMSendAlertView: View {
    @ObservedObject var sheetDataSource : PLMSheetDataSource
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    public var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                Text("Plans Markup title").foregroundColor(TCAppearance.shared.theme.change.headingColor)
                    .font(.system(size: 18)).fontWeight(.semibold).padding(.top)
                Spacer().frame(height: 20)
                TextField("Title", text: $sheetDataSource.sendTitle)
                    .frame(width: geometry.size.width*0.8, height: sheetDataSource.iPad ? 60 : 40).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)).background(TCAppearance.shared.theme.change.tableViewCellColor.cornerRadius(8))
                Spacer().frame(height: 20)
                Divider()
                HStack{
                    Button {
                        sheetDataSource.showsendtextView = false
                    } label: {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("Cancel").frame(width:60)
                                .foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    Divider().frame(width: 2)
                    Button {
                        sheetDataSource.sheetViewController?.sheetBaseView.addNewMarkerGroup()
                        sheetDataSource.sendTitle = ""
                        sheetDataSource.showsendtextView = false
                        //                    sheetDataSource.selectedThumbnail = sheetThumbNailsType(thumbnailImage: dummyImage, OriginalImage: dummyImage,title: "")
                        //                    self.presentationMode.wrappedValue.dismiss()
                        //                    PLMTabContentsViewModel.shared.shouldHideTabContents = false
                    } label: {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("OK").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                                .fontWeight(.bold).disabled(sheetDataSource.sendTitle == "")
                                .opacity(sheetDataSource.sendTitle == "" ? 0.5 : 1)
                            
                                .frame(width:60)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

public struct PLMPublishAlertView: View {
    @ObservedObject var sheetDataSource : PLMSheetDataSource
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    public var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                Text("Publish your drafted markups").foregroundColor(TCAppearance.shared.theme.change.headingColor)
                    .font(.system(size: 18)).fontWeight(.semibold).padding(.top)
                Spacer().frame(height: 20)
                TextField("Title", text: $sheetDataSource.sendTitle)
                    .frame(width: geometry.size.width*0.8, height: sheetDataSource.iPad ? 60 : 40).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)).background(TCAppearance.shared.theme.change.tableViewCellColor.cornerRadius(8))
                Spacer().frame(height: 20)
                Divider()
                HStack{
                    Button {
                        sheetDataSource.showPublishtextView = false
                    } label: {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("Cancel").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                                .frame(width:60)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    Divider().frame(width: 2)
                    Button {
                        sheetDataSource.createSendRequest()
                        sheetDataSource.sendTitle = ""
                        sheetDataSource.showPublishtextView = false
                        //                    sheetDataSource.selectedThumbnail = sheetThumbNailsType(thumbnailImage: dummyImage, OriginalImage: dummyImage,title: "")
                        //                    self.presentationMode.wrappedValue.dismiss()
                        //                    PLMTabContentsViewModel.shared.shouldHideTabContents = false
                    } label: {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("OK").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                                .fontWeight(.bold).disabled(sheetDataSource.sendTitle == "")
                                .opacity(sheetDataSource.sendTitle == "" ? 0.5 : 1)
                            
                                .frame(width:60)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

public struct PLMTextAlertView: View {
    @ObservedObject var sheetDataSource : PLMSheetDataSource

    public var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                Text("Create text mark").foregroundColor(TCAppearance.shared.theme.change.headingColor)
                    .font(.system(size: 18)).fontWeight(.semibold).padding(.top)
                Spacer().frame(height: 20)
                TextField("Type", text: $sheetDataSource.markertext)
                    .frame(width: geometry.size.width*0.8, height: sheetDataSource.iPad ? 60 : 40).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)).background(TCAppearance.shared.theme.change.tableViewCellColor.cornerRadius(8))
                Spacer().frame(height: 20)
                Divider()
                HStack{
                    Button {
                        sheetDataSource.sheetViewController?.sheetBaseView.markerLayer.addTextToLastAddedMarker(text: "")
                        sheetDataSource.showEditMarkertextView = false
                    } label: {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("Cancel")
                                .foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    Divider().frame(width: 2)
                    Button {
                        sheetDataSource.sheetViewController?.sheetBaseView.markerLayer.addTextToLastAddedMarker(text: sheetDataSource.markertext)
                        sheetDataSource.showEditMarkertextView = false
                    } label: {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("OK").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                                .fontWeight(.bold).disabled(sheetDataSource.markertext == "")
                            Spacer()
                        }
                        Spacer()
                    }
                    .opacity(sheetDataSource.markertext == "" ? 0.5 : 1)
                    .disabled(sheetDataSource.markertext == "")
                }
                
            }
        }
    }
}
public struct PLMScaleAlertView: View {
    @ObservedObject var sheetDataSource : PLMSheetDataSource
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false

    public var body: some View {
        GeometryReader{ geometry in
        VStack{
            Spacer()
            Text("Edit Caliberation Scale").foregroundColor(TCAppearance.shared.theme.change.headingColor)
                .font(.system(size: 18)).fontWeight(.semibold).padding(.top)
            if sheetDataSource.selectedMeasurmentUnit != sheetDataSource.sizes[2]{
                Spacer().frame(height: 20)
                TextField("Type", text: $sheetDataSource.scaletext)
                    .frame(width: geometry.size.width*0.8, height: sheetDataSource.iPad ? 60 : 40)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .background(TCAppearance.shared.theme.change.tableViewCellColor.cornerRadius(8))
                    .disabled(sheetDataSource.selectedMeasurmentUnit == sheetDataSource.sizes[2])
                    .opacity(sheetDataSource.selectedMeasurmentUnit == sheetDataSource.sizes[2] ? 0.3 : 1)
            }
            Spacer().frame(height: 20)
            
         
//            HStack {
                        Picker("", selection: $sheetDataSource.selectedMeasurmentUnit) {
                            ForEach(sheetDataSource.sizes, id: \.self) { item in
                                Text(item)
                                    .foregroundColor(TCAppearance.shared.theme.change.textLabelColor)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(EdgeInsets(top: 5, leading: iPad ? 40 : 5, bottom: 15, trailing: iPad ? 40 : 5))
//            }
            Divider()
            HStack{
                Button {
                    
                    sheetDataSource.scaleSettextView = false
                } label: {
                    Spacer()
                    VStack{
                        Spacer()
                            Text("Cancel")
                            .foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                        Spacer()
                    }
                    Spacer()
                }
                Divider().frame(width: 2)
                Button {
                    sheetDataSource.sheetViewController?.sheetBaseView.setScale(text: sheetDataSource.scaletext)
                    sheetDataSource.scaleSettextView = false
                } label: {
                    Spacer()
                    VStack{
                        Spacer()
                            Text("OK").foregroundColor(TCAppearance.shared.theme.change.textActionButtonTextColor)
                            .fontWeight(.bold).disabled(sheetDataSource.scaletext == "" && sheetDataSource.selectedMeasurmentUnit != sheetDataSource.sizes[2])
                        Spacer()
                    }
                    Spacer()
                }
                .opacity(sheetDataSource.scaletext == "" && sheetDataSource.selectedMeasurmentUnit != sheetDataSource.sizes[2] ? 0.5 : 1)
                .disabled(sheetDataSource.scaletext == "" && sheetDataSource.selectedMeasurmentUnit != sheetDataSource.sizes[2])
            }
                
            
        }
    }
    }
}

