//
//  PLMTextMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 20/01/22.
//

import Foundation
import UIKit
public class PLMTextMarker : PLMShapeTypeMarker{
    let textBox = UITextView()
    var interaction : UIContextMenuInteraction!
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(textBox)
        self.setUpHolders()
        markedInfos = markedInfosParam
        textBox.text = markedInfos.text
        textBox.isEditable = false
        updateTextFont(textView: textBox)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
            let t = self.transform
            self.transform = .identity
            textBox.frame = CGRect(x: halfSize, y: halfSize, width: self.frame.width-size, height: self.frame.height-size)
            updateTextFont(textView: textBox)
            self.transform = t
        }
    }
    override public func setStrokeWidth(val:CGFloat)
    {
//        textBox.layer.borderWidth = val
    }
    override public func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
        self.markedInfos.originalDetails.originalStrokeColor = val
        textBox.textColor = getColor(val: val)
        
    }
    override public func setFillColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableFillColor = val
        self.markedInfos.originalDetails.originalFillColor = val
        textBox.backgroundColor = getColor(val:val)
        
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
            self.setStrokeWidth(val: self.markedInfos.drawableDetails.drawableStrokeWidth)
            self.setStrokeColor(val: self.markedInfos.drawableDetails.drawableStrokeColor)
            self.setFillColor(val: self.markedInfos.drawableDetails.drawableFillColor)
            self.setAngle(val: self.markedInfos.drawableDetails.drawableAngle)
            self.setLock(val: self.markedInfos.isLocked)
//        })
    }

    public func updateTextFont(textView:UITextView) {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
            return;
        }

        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));

        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            var count = 0
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
                count = count + 1
                if count > 300{
                    expectFont = textView.font!.withSize(2)
                    textView.font = expectFont
                    break
                }
            }
        }
        else {
            var count = 0
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
                count = count + 1
                if count > 300{
//                    expectFont = textView.font!.withSize(count)
                    textView.font = expectFont
                    break
                }
            }
            textView.font = expectFont;
        }
        expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            var count = 0
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
                count = count + 1
                if count > 300{
                    expectFont = textView.font!.withSize(2)
                    textView.font = expectFont
                    break
                }
            }
        }
        else {
            var count = 0
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
                count = count + 1
                if count > 300{
//                    expectFont = textView.font!.withSize(count)
                    textView.font = expectFont
                    break
                }
            }
            textView.font = expectFont;
        }
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
        let Menuitem = UIMenuItem(title: "Edit Text", action: #selector(self.editText))
        menuitems.append(Menuitem)
        
        return menuitems
    }
    @objc func editText(){
        PLMPresenter.shared.sheetDataSource.showEditMarkertextView = true
        PLMPresenter.shared.sheetDataSource.markertext = self.markedInfos.text
    }

//    @objc override func moveMarkerGesture(_ gestureRecognizer: UILongPressGestureRecognizer){
//        super.handleGesture(gestureRecognizer)
//        if gestureRecognizer.state == .began{
////            showMenu()
//        }
//    }
//    override public func showMenu()
//    {
//        super.showMenu()
//        interaction = UIContextMenuInteraction(delegate: self)
//        self.addInteraction(interaction)
//    }
}
//extension PLMTextMarker: UIContextMenuInteractionDelegate {
//
//    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//
//            let edit = UIAction(title: "Edit Text", image: UIImage(systemName: "square.and.pencil")) { action in
//                PLMPresenter.shared.sheetDataSource.showEditMarkertextView = true
//                PLMPresenter.shared.sheetDataSource.markertext = self.textBox.text
//            }
//
//            let move = UIAction(title: "Select", image: UIImage(systemName: "arrow.right.arrow.left")) { action in
//
//                self.delegate?.hideColorBar()
//                self.delegate?.shapeMarkerDisableAllHolder()
//                self.shouldEnableHolders(enable: true)
//                self.removeInteraction(interaction)
//            }
//            // Create and return a UIMenu with all of the actions as children
//            return UIMenu(title: "", children: [edit,move])
//        }
//    }
//}
