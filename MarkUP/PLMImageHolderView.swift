//
//  PLMImageHolderView.swift
//  PlanMarkup
//
//  Created by SIMON on 18/01/22.
//

import Foundation
import UIKit

import AppearanceFramework
public protocol PLMImageMasterViewDelegate : AnyObject {
    func imageLayoutUpdated()
    func shapeMarkerDisableAllHolder()
    func deSelectMarker()
}
public class PLMImageMasterView: UIView,PLMImageMasterViewDelegate,PLMImageDetailCntrlrDelegate {
    
    
    public let imageCntrlr = PLMImageDetailCntrlr()

    weak var delegate : PLMImageMasterViewDelegate?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(TCAppearance.shared.theme.change.sheetBackground)
        self.addSubview(imageCntrlr.view)
        imageCntrlr.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
//        UIView.performWithoutAnimation {
               
        super.layoutSubviews()
        let screenSize = CGRect(x: 0, y: 0, width: 1194, height: 834)//UIScreen.main.bounds
        imageCntrlr.screenWidth = screenSize.width
        imageCntrlr.view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        if(imageCntrlr.imgPhotoHolder.frame.size.width == 0){
            let smallSide = self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height
            imageCntrlr.scrollView.frame = CGRect(x: 0, y: 0, width: smallSide, height: smallSide)
            imageCntrlr.imgPhoto.frame = CGRect(x: 0, y: 0, width: smallSide, height: smallSide)
            imageCntrlr.imgPhotoHolder.frame = CGRect(x: 0, y: 0, width: smallSide, height: smallSide)
            imageCntrlr.imgPhoto.frame = CGRect(x:  (smallSide/2) - (imageCntrlr.imgPhoto.frame.size.width/2), y: (smallSide/2) - (imageCntrlr.imgPhoto.frame.size.height/2), width: imageCntrlr.imgPhoto.frame.size.width, height: imageCntrlr.imgPhoto.frame.size.height)
            imageCntrlr.imgPhotoHolder.frame = CGRect(x:  (smallSide/2) - (imageCntrlr.imgPhotoHolder.frame.size.width/2), y: (smallSide/2) - (imageCntrlr.imgPhotoHolder.frame.size.height/2), width: imageCntrlr.imgPhotoHolder.frame.size.width, height: imageCntrlr.imgPhotoHolder.frame.size.height)
            imageCntrlr.setImageSize()
            imageCntrlr.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            imageCntrlr.imgPhoto.frame = CGRect(x:  (self.frame.size.width/2) - (imageCntrlr.imgPhoto.frame.size.width/2), y: (self.frame.size.height/2) - (imageCntrlr.imgPhoto.frame.size.height/2), width: imageCntrlr.imgPhoto.frame.size.width, height: imageCntrlr.imgPhoto.frame.size.height)
            imageCntrlr.imgPhotoHolder.frame = CGRect(x:  (self.frame.size.width/2) - (imageCntrlr.imgPhotoHolder.frame.size.width/2), y: (self.frame.size.height/2) - (imageCntrlr.imgPhotoHolder.frame.size.height/2), width: imageCntrlr.imgPhotoHolder.frame.size.width, height: imageCntrlr.imgPhotoHolder.frame.size.height)
//            imageCntrlr.scrollView.zoomScale = 1
        }
        else{
            imageCntrlr.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            
        }
            imageCntrlr.setImageSize()
        
    }
    public func imageLayoutUpdated()
    {
        UIView.performWithoutAnimation {
            delegate?.imageLayoutUpdated()
        }
    }
    public func shapeMarkerDisableAllHolder() {
        delegate?.shapeMarkerDisableAllHolder()
    }
    public func deSelectMarker()
    {
        delegate?.deSelectMarker()
    }
}
public protocol PLMImageDetailCntrlrDelegate : AnyObject {
    func imageLayoutUpdated()
    func shapeMarkerDisableAllHolder()
    func deSelectMarker()
}
public class PLMImageDetailCntrlr: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var imgPhoto = UIImageView()
    var imgPhotoHolder = UIImageView()
    var overlayImage = UIView()
    var screenWidth:CGFloat = 0
    var imageViewZoomGesture = UIPinchGestureRecognizer()
    weak var delegate : PLMImageDetailCntrlrDelegate?
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        
       
        imgPhoto.contentMode = UIView.ContentMode.scaleAspectFit
        scrollView.addSubview(imgPhotoHolder)
        imgPhotoHolder.contentMode = UIView.ContentMode.scaleAspectFit
        imgPhotoHolder.isUserInteractionEnabled = true
        
        scrollView.addSubview(imgPhoto)
        imgPhoto.isUserInteractionEnabled = false
        
        scrollView.bouncesZoom = false
        imgPhotoHolder.alpha = 0
        
        scrollView.minimumZoomScale = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            scrollView.maximumZoomScale = 2
        }
        else{
            scrollView.maximumZoomScale = 3
        }
        
        
        imgPhotoHolder.layer.masksToBounds = true

    }
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgPhotoHolder
    }
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        UIView.performWithoutAnimation {
        delegate?.deSelectMarker()
        resetFrame()
//        }
    }
    public func setImageSize()
    {
        resetFrame()
    }
    public func resetFrame()
    {
        if imgPhoto.image != nil {
            let contentRect = self.imgPhotoHolder.PLMgetImageAspectCropFrame(for:imgPhotoHolder.image!, borderDisplacement: 0)
            let rect1 = contentRect.size
            
            let rect2 = scrollView.contentSize

            imgPhotoHolder.frame.size = CGSize(width: rect1.width, height: rect1.height)
            imgPhoto.frame.size = CGSize(width: rect1.width * 0.85, height: rect1.height * 0.85)
            let x = rect2.width <= scrollView.frame.size.width ? scrollView.frame.size.width/2 : scrollView.contentSize.width/2
            let y = rect2.height <= scrollView.frame.size.height ? scrollView.frame.size.height/2 : scrollView.contentSize.height/2
            imgPhotoHolder.center = CGPoint(x: x, y: y)
            imgPhoto.center = CGPoint(x: x, y: y)

            UIView.performWithoutAnimation {
                delegate?.shapeMarkerDisableAllHolder()
                delegate?.imageLayoutUpdated()
            }
        }
    }

}
