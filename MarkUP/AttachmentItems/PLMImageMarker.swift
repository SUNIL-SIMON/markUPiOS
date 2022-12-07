//
//  PLMImageMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 23/01/22.
//

import Foundation
import UIKit
public class PLMImageMarker : PLMShapeTypeMarker{
    let rect = UIImageView()
    var interaction : UIContextMenuInteraction!
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(rect)
        self.setUpHolders()
        markedInfos = markedInfosParam
        rect.image = markedInfosParam.image.image
        rect.contentMode = UIView.ContentMode.scaleAspectFit
//        self.rotate(angle: 90)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
            let t = self.transform
            self.transform = .identity
            rect.frame = CGRect(x: halfSize, y: halfSize, width: self.frame.width-size, height: self.frame.height-size)
            self.transform = t
        }
    }
    override public func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
        self.markedInfos.originalDetails.originalAngle = val
        let rotateTransform  = CGAffineTransform(rotationAngle: val * CGFloat.pi / 180)
        self.transform = rotateTransform
        
    }
    public override func setLock(val:Bool)
    {
        self.markedInfos.isLocked = val
        lockImage.alpha = self.markedInfos.isLocked ? 1 : 0
    }
    override public func resetAllProperties()
    {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            self.setLock(val: self.markedInfos.isLocked)
//        })
    }
    override func showActiveSheetMenu()
    {
        let menucontroller = UIMenuController.shared
        if menucontroller.isMenuVisible {
            menucontroller.setMenuVisible(false, animated: true)
        }
        else{
            shouldEnableHolders(enable: true)
            self.becomeFirstResponder()
//            menucontroller.setTargetRect(rect ?? CGRect.zero, in: self)
            menucontroller.menuItems = getMenuList() as? [UIMenuItem]
            menucontroller.showMenu(from: self.superview ?? self, rect: self.frame)
//            menucontroller.setMenuVisible(true, animated: true)
            menucontroller.menuItems = nil
        }
    }
    func getMenuList() -> [AnyHashable]
    {
        var menuitems = [AnyHashable]()
        let Menuitem = UIMenuItem(title: "Camera", action: #selector(self.openCamera))
        menuitems.append(Menuitem)
        
        let Menuitem2 = UIMenuItem(title: "Library", action: #selector(self.openLibrary))
        menuitems.append(Menuitem2)
        
        return menuitems
    }
    @objc func openCamera(){
        PLMPresenter.shared.sheetDataSource.imagePickerType = .camera
        PLMPresenter.shared.sheetDataSource.attachmentInsideSheetPickerShown = true
    }
    @objc func openLibrary(){
        PLMPresenter.shared.sheetDataSource.imagePickerType = .library
        PLMPresenter.shared.sheetDataSource.attachmentInsideSheetPickerShown = true
    }
//    override public func showMenu()
//    {
//        super.showMenu()
//        interaction = UIContextMenuInteraction(delegate: self)
//        self.addInteraction(interaction)
//    }
}
//extension PLMImageMarker: UIContextMenuInteractionDelegate {
//               
//    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//            
//            self.delegate?.setSelectedMarker(rowIndex: self.rowIndex, sectionIndex: self.groupIndex)
//            self.delegate?.attachRotatorToSelectedMarker()
//            
//            let photo = UIAction(title: "Library", image: UIImage(systemName: "photo.on.rectangle")) { action in
//                
//                PLMPresenter.shared.sheetDataSource.imagePickerType = .library
//                PLMPresenter.shared.sheetDataSource.attachmentPickerShown = true
//            }
//            let camera = UIAction(title: "camera", image: UIImage(systemName: "camera")) { action in
//                
//                PLMPresenter.shared.sheetDataSource.imagePickerType = .camera
//                PLMPresenter.shared.sheetDataSource.attachmentPickerShown = true
//            }
//            let move = UIAction(title: "move", image: UIImage(systemName: "arrow.right.arrow.left")) { action in
//                
//                self.delegate?.hideColorBar()
//                self.delegate?.shapeMarkerDisableAllHolder()
//                self.shouldEnableHolders(enable: true)
//                self.removeInteraction(interaction)
//            }
//    
//            // Create and return a UIMenu with all of the actions as children
//            return UIMenu(title: "", children: [photo,camera,move])
//        }
//    }
//}
