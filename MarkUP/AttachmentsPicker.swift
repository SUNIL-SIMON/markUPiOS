//
//  AttachmentsPicker.swift
//  MarkUP
//
//  Created by SIMON on 06/12/22.
//

import Foundation

import SwiftUI
import PhotosUI
import MobileCoreServices

import AppearanceFramework

import AVFoundation

public enum AttachmentPickerType {
        case none
        case library
        case camera
        case pdf
}

public enum DataType {
    case photo
    case video
}

public struct TCAttachmentImagePickerView {

    @Binding public var isShown: Bool
    public var selectedImage: Binding<UIImage?>?
    public var editedImage: Binding<UIImage?>?
    public var slectedVideo: Binding<Data?>?
    public var fileType: DataType
    
    public var sourceType = AttachmentPickerType.library
    public var allowsEditing: Bool = false
    
    public init(isShown: Binding<Bool>, selectedImage: Binding<UIImage?>? = nil, editedImage: Binding<UIImage?>? = nil, sourceType: AttachmentPickerType, allowsEditing: Bool = false, slectedVideo: Binding<Data?>?, fileType: DataType) {
        
        self._isShown = isShown
        self.selectedImage = selectedImage
        self.editedImage = editedImage
        self.sourceType = sourceType
        self.allowsEditing = allowsEditing
        self.slectedVideo = slectedVideo
        self.fileType = fileType
    }
    
    public func makeCoordinator() -> TCAttachmentImagePickerCoordinator {
        TCAttachmentImagePickerCoordinator(isShown: $isShown, selectedImage: selectedImage, editedImage: editedImage, slectedVideo : slectedVideo)
    }
}

extension TCAttachmentImagePickerView: UIViewControllerRepresentable {
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<TCAttachmentImagePickerView>) -> UIImagePickerController {
            let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.videoMaximumDuration = 10.00
            picker.sourceType = sourceType == .camera ? .camera : .photoLibrary
        picker.mediaTypes = fileType == .photo ? [kUTTypeImage as String]: sourceType == .camera ? [kUTTypeMovie as String, kUTTypeImage as String] : [kUTTypeMovie as String,kUTTypeImage as String]
        if sourceType == .library && fileType == .video{
            picker.allowsEditing = true
            picker.isEditing = true
        }else{
            picker.allowsEditing = allowsEditing
        }
           // picker.view.backgroundColor = TCAppearance.shared.theme.color.cameraBackgroundColorUI
            return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<TCAttachmentImagePickerView>) {
        
    }
}

public class TCAttachmentImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding public var coordinatorShown: Bool
    public var selectedImage: Binding<UIImage?>?
    public var editedImage: Binding<UIImage?>?
    public var slectedVideo: Binding<Data?>?

    public init(isShown: Binding<Bool>, selectedImage: Binding<UIImage?>? = nil, editedImage: Binding<UIImage?>? = nil, allowsEditing: Bool = false, slectedVideo: Binding<Data?>?) {
        _coordinatorShown = isShown
        self.selectedImage = selectedImage
        self.editedImage = editedImage
        self.slectedVideo = slectedVideo
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
           mediaType == (kUTTypeMovie as String),
           let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            do{
               
                let videoData = try Data(contentsOf: url)
                print(videoData)
                slectedVideo?.wrappedValue = videoData
            } catch{
                print(error.localizedDescription)
            }
//            UISaveVideoAtPathToSavedPhotosAlbum(
//                    url.path,
//                    self,
//                    #selector(video(_:didFinishSavingWithError:contextInfo:)),
//                    nil)
//            let videoPath = info[UIImagePickerController.InfoKey.mediaURL] as! NSString
            coordinatorShown.toggle()
        }else{
            if let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
                selectedImage?.wrappedValue = unwrapImage
            }
            if let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

                editedImage?.wrappedValue = chosenImage
            }
            
            coordinatorShown.toggle()
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        coordinatorShown.toggle()
    }
}

//func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
//    let title = (error == nil) ? "Success" : "Error"
//    let message = (error == nil) ? "Video was saved" : "Video failed to save"
//
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//    present(alert, animated: true, completion: nil)
//}

public struct TCAttachmentDocPickerView {

    @Binding public var isShown: Bool
    public var selectedDoc : Binding<String?>?
    public var editedDoc: Binding<String?>?
    
    public var sourceType = AttachmentPickerType.library
    public var allowsEditing: Bool = false
    
    public init(isShown: Binding<Bool>, selectedDoc: Binding<String?>? = nil, editedDoc: Binding<String?>? = nil, sourceType: AttachmentPickerType, allowsEditing: Bool = false) {
        
        self._isShown = isShown
        self.selectedDoc = selectedDoc
        self.editedDoc = editedDoc
        self.sourceType = sourceType
        self.allowsEditing = allowsEditing
    }
    
    public func makeCoordinator() -> TCAttachmentDocPickerCoordinator {
        TCAttachmentDocPickerCoordinator(isShown: $isShown, selectedDoc: selectedDoc, editedDoc: editedDoc)
    }
}

extension TCAttachmentDocPickerView: UIViewControllerRepresentable {
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<TCAttachmentDocPickerView>) -> UIDocumentPickerViewController {
        let types: [String] = [kUTTypePDF as String]
        let picker = UIDocumentPickerViewController(documentTypes: types, in: .import)
            picker.allowsMultipleSelection = false
            picker.delegate = context.coordinator
        
            return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController,
                                context: UIViewControllerRepresentableContext<TCAttachmentDocPickerView>) {
        
    }
}

public class TCAttachmentDocPickerCoordinator: NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @Binding public var coordinatorShown: Bool
    public var selectedDoc: Binding<String?>?
    public var editedDoc: Binding<String?>?

    public init(isShown: Binding<Bool>, selectedDoc: Binding<String?>? = nil, editedDoc: Binding<String?>? = nil, allowsEditing: Bool = false) {
        _coordinatorShown = isShown
        self.selectedDoc = selectedDoc
        self.editedDoc = editedDoc
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        selectedDoc?.wrappedValue = url.absoluteString
    }
}

