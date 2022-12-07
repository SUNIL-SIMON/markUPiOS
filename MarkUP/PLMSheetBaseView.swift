//
//  PLMSheetBaseView.swift
//  MarkUP
//
//  Created by SIMON on 06/12/22.
//

import Foundation
import UIKit
import AppearanceFramework
import PlanSheetComputing
public class PLMSheetBaseView : UIViewController , PLMSideLayerBarDelegate, PLMControlBarDelegate,PLMControlBariPhoneDelegate,PLMShapesBariPhoneDelegate,PLMImageMasterViewDelegate,PLMMarkedLayersDelegate,PLMColorBarDelegate,PLMColorBariPhoneDelegate, UIGestureRecognizerDelegate, PLMPopOverBaseViewCntrlrDelegate {
    
    
   
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    public var selectedThumbnail = sheetsListType(sheetId: "0", thumbnailImage: dummyImage, thumbnailCompressedImage: dummyImage2, OriginalImage: dummyImage, title: "", versionnumber: 0, creater_userID: "", tag: "", lastupdated: Date(), isAvailableOffline: false)
    
    var planSheetImageMasterView = PLMImageMasterView()
    var controlBar = PLMControlBar()
    var controlBarForiPhone = PLMControlBarForiPhone()
    var controlBarAddButton = UIButton()
    var shapeBarForiPhone = PLMShapesBarForiPhone()
    var sideLayerBar = PLMSideLayerBar()
    var sheetLayerButton = UIButton()
    var markerLayer = PLMMarkedLayers()
    var colorBar = UINavigationController()
    var colorBarForiPhone = PLMColorBarForiPhone()
    var colorButtonsView = PLMColorBar()
    let colorBarFirstVC = UIViewController()
    var colorBarSecondVC = PLMColorPickerView()
    var selectedColorMode = colorModeType.stroke
    var sideBarMode = SideBarModeType.minimized
    var selectedStrokeColor = redColor
    var selectedFillColor = clearColor
    var selectedStrokeWidth : CGFloat = 3
    var selectedStrokeWidthHighlihter : CGFloat = 15
    var markersCopy = [PLMShapeTypeMarker]()
    var cntrlr : PLMPopOverBaseViewCntrlr?
    let frameComputing = PLMComputing.shared
    var lastPointForPathType = CGPoint.zero
    var xPointForPathType : CGFloat = 0
    var yPointForPathType : CGFloat = 0
    var x_widthPointForPathType : CGFloat = 0
    var y_heightlastPointForPathType : CGFloat = 0
    
    var sheetScaleWidth : CGFloat = 0
    var sheetScaleHeight : CGFloat = 0
    var rullerSourceLength : CGFloat = 0
    
    var showColors: Bool = true
    
    var sideLayerBarDragged: Bool = false
    let screenHeight = UIScreen.main.bounds.height
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    //    public override init(frame: CGRect)
//    {
//        super.init(frame: frame)
//    setupViews()
//    }
    public func setupViews()
    {
        self.view.layer.masksToBounds = true
        self.view.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewBackgroundColor)
        
        self.view.addSubview(planSheetImageMasterView)
        planSheetImageMasterView.delegate = self
//        planSheetImage.contentMode = .scaleAspectFit
        
        planSheetImageMasterView.imageCntrlr.scrollView.addSubview(markerLayer)
        markerLayer.delegate = self
        
//        markerLayer.backgroundColor = .systemPink
//        markerLayer.alpha = 0.5
        
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(PLMSheetBaseView.handlePanGesture(_:)))
        gestureRecognizer1.delegate = self
//        gestureRecognizer1.cancelsTouchesInView = true
        planSheetImageMasterView.addGestureRecognizer(gestureRecognizer1)
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(PLMSheetBaseView.handleTapGesture(_:)))
        gestureRecognizer2.delegate = self
//        gestureRecognizer2.cancelsTouchesInView = true
        planSheetImageMasterView.addGestureRecognizer(gestureRecognizer2)
        
        if iPad{
            self.view.addSubview(controlBar)
            controlBar.delegate = self
            controlBar.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            controlBar.layer.cornerRadius = 10
            controlBar.layer.shadowColor = UIColor.black.cgColor
            controlBar.layer.shadowOpacity = 0.1
            controlBar.layer.shadowRadius = 10
            controlBar.layer.shadowOffset = .zero
            
            self.view.addSubview(sideLayerBar)
            sideLayerBar.delegate = self
            sideLayerBar.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            sideLayerBar.layer.cornerRadius = 10
            sideLayerBar.layer.shadowColor = UIColor.black.cgColor
            sideLayerBar.layer.shadowOpacity = 0.1
            sideLayerBar.layer.shadowRadius = 10
            sideLayerBar.layer.shadowOffset = .zero
            sideLayerBar.frame = CGRect(x: 20 , y: self.view.frame.size.height/2, width: 50, height: 50)
            
            sideLayerBar.changeMode()
            
            sideLayerBar.sideButton.alpha = 1
            sideLayerBar.tableView.alpha = 0
        }else{
            self.view.addSubview(controlBarAddButton)
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 200, weight: .bold, scale: .large)
            let btnImage = UIImage(systemName: "plus.circle.fill",withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate)
            controlBarAddButton.setImage(btnImage, for: .normal)
            controlBarAddButton.imageView?.contentMode = .scaleAspectFill
//            controlBarAddButton.imageView?.clipsToBounds = true
            controlBarAddButton.tintColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            controlBarAddButton.backgroundColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            controlBarAddButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
            controlBarAddButton.layer.cornerRadius = 25
            controlBarAddButton.layer.borderWidth = 5
            controlBarAddButton.layer.borderColor = UIColor.lightGray.cgColor
            
            self.view.addSubview(controlBarForiPhone)
            controlBarForiPhone.alpha = 0
            controlBarForiPhone.delegate = self
            controlBarForiPhone.iPhoneDelegate = self
            controlBarForiPhone.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            controlBarForiPhone.layer.shadowColor = UIColor.black.cgColor
            controlBarForiPhone.layer.shadowOpacity = 0.1
            controlBarForiPhone.layer.shadowRadius = 10
            controlBarForiPhone.layer.shadowOffset = .zero

            
            self.view.addSubview(shapeBarForiPhone)
            shapeBarForiPhone.alpha = 0
            shapeBarForiPhone.delegate = self
            shapeBarForiPhone.iPhoneShapesBarDelegate = self
            shapeBarForiPhone.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            shapeBarForiPhone.layer.shadowColor = UIColor.black.cgColor
            shapeBarForiPhone.layer.shadowOpacity = 0.1
            shapeBarForiPhone.layer.shadowRadius = 10
            shapeBarForiPhone.layer.shadowOffset = .zero
            
            self.view.addSubview(colorBarForiPhone)
            colorBarForiPhone.alpha = 0
            colorBarForiPhone.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            colorBarForiPhone.colorBar.delegate = self
            colorBarForiPhone.delegate = self
            colorBarForiPhone.colorPickerView.colorDelegate = self
            
            colorBarForiPhone.pageView.colorView.delegate = self
            colorBarForiPhone.pageView.sliderView.delegate = self
            
            self.view.addSubview(sheetLayerButton)
//            let largeConfig = UIImage.SymbolConfiguration(pointSize: 200, weight: .bold, scale: .large)
            let sheetBtnImage = UIImage(named: "layer", in: Bundle(for: type(of:self)),with: largeConfig)?.withRenderingMode(.alwaysTemplate)
            sheetLayerButton.setImage(sheetBtnImage, for: .normal)
            sheetLayerButton.imageView?.contentMode = .scaleAspectFit
            sheetLayerButton.imageView?.clipsToBounds = true
            sheetLayerButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            sheetLayerButton.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            sheetLayerButton.layer.cornerRadius = 15
            sheetLayerButton.layer.borderWidth = 5
            sheetLayerButton.layer.borderColor = UIColor.lightGray.cgColor
            
            sheetLayerButton.addTarget(self, action: #selector(animateSideLayerBarForiPhone), for: .touchUpInside)
            
            self.view.addSubview(sideLayerBar)
            
            sideLayerBar.frame = CGRect(x: 0, y: screenHeight, width: self.view.frame.width, height: screenHeight*0.3)
            sideLayerBar.delegate = self
            sideLayerBar.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
            sideLayerBar.layer.cornerRadius = 10
            sideLayerBar.layer.shadowColor = UIColor.black.cgColor
            sideLayerBar.layer.shadowOpacity = 0.1
            sideLayerBar.layer.shadowRadius = 10
            sideLayerBar.layer.shadowOffset = .zero
            sideLayerBar.setMode(sideBarModeParam: .maximized)
            let gestureRecognizerForSideLayer = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(_:)))
            sideLayerBar.addGestureRecognizer(gestureRecognizerForSideLayer)
        }
        
        self.view.addSubview(sideLayerBar)
        sideLayerBar.delegate = self
        sideLayerBar.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        sideLayerBar.layer.cornerRadius = 10
        sideLayerBar.layer.shadowColor = UIColor.black.cgColor
        sideLayerBar.layer.shadowOpacity = 0.1
        sideLayerBar.layer.shadowRadius = 10
        sideLayerBar.layer.shadowOffset = .zero
        sideLayerBar.frame = CGRect(x: 10 , y: self.view.frame.size.height/2, width: 50, height: 50)
        
        self.view.addSubview(colorBar.view)
        colorBar.view.alpha = 0
//        colorBar.view.backgroundColor = .green//UIColor.red
        
        colorBarFirstVC.view.addSubview(colorButtonsView)
        
        colorButtonsView.delegate = self
        colorBar.setViewControllers([colorBarFirstVC], animated: false)
        colorBarFirstVC.navigationItem.title = "Choose Color"
        
        colorBarSecondVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self , action: #selector(backButton))
        colorBarSecondVC.navigationItem.leftBarButtonItem?.tintColor = TCAppearance.shared.theme.change.navigationBarTintColor //UIColor(TCAppearance.shared.theme.change.navigationBarTintColor)
        colorBarSecondVC.colorDelegate = self
        
        
        colorBar.view.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        colorBar.view.layer.cornerRadius = 10
        colorBar.view.layer.shadowColor = UIColor.black.cgColor
        colorBar.view.layer.shadowOpacity = 0.1
        colorBar.view.layer.shadowRadius = 10
        colorBar.view.layer.shadowOffset = .zero

        
        
        colorButtonsView.setSelectedColor(clr : selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor)
        controlBar.fillButton.imgView.backgroundColor = selectedFillColor.redValue == -1 ? .white : getColor(val :selectedFillColor)
        controlBar.strokeButton.imgView.layer.borderColor = selectedStrokeColor.redValue == -1 ? UIColor.white.cgColor : getColor(val :selectedStrokeColor).cgColor
        controlBar.fillButton.imgView.image = selectedFillColor.redValue == -1 ?         UIImage(named: "noColor2") : nil
        controlBar.strokeButton.imgView.image = selectedStrokeColor.redValue == -1 ? UIImage(named: "noColor2") : nil
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func plusButtonClicked(){
//        controlBarAddButton.removeFromSuperview()
        controlBarAddButton.alpha = 0
        sheetLayerButton.alpha = 0
//        self.view.addSubview(controlBarForiPhone)
        controlBarForiPhone.alpha = 1
    }
    
    @objc public func showiPhoneControlBar(){
//        shapeBarForiPhone.removeFromSuperview()
        shapeBarForiPhone.alpha = 0
//        self.view.addSubview(controlBarForiPhone)
        controlBarForiPhone.alpha = 1
    }
    
    @objc public func showEditingOptionsForiPhone(){
        
//        if self.sideBarMode == .maximized{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .transitionCurlDown) {
                self.sideLayerBar.frame = CGRect(x: 0, y: self.screenHeight, width: self.view.frame.width, height: self.sideLayerBar.frame.height)
            } completion: { completed in
//                self.sideBarMode = .minimized
            }
//        }
//        shapeBarForiPhone.removeFromSuperview()
        self.sheetLayerButton.alpha = 0
        self.controlBarAddButton.alpha = 0
        shapeBarForiPhone.alpha = 0
//        controlBarForiPhone.removeFromSuperview()
        controlBarForiPhone.alpha = 0
        colorBarForiPhone.strokeButton.imgView.layer.borderColor = selectedStrokeColor.redValue == -1 ? UIColor.white.cgColor : getColor(val :selectedStrokeColor).cgColor
        colorBarForiPhone.fillButton.imgView.image = selectedFillColor.redValue == -1 ?         UIImage(named: "noColor2") : nil
        colorBarForiPhone.strokeButton.imgView.image = selectedStrokeColor.redValue == -1 ? UIImage(named: "noColor2") : nil
//        self.view.addSubview(colorBarForiPhone)
        colorBarForiPhone.alpha = 1
    }
    @objc public func showiPhoneColorBarView(isShown: Bool){
        self.showColors = isShown
        self.colorBarForiPhone.showColors = isShown
        self.viewWillLayoutSubviews()
        self.colorBarForiPhone.layoutSubviews()
    }
    @objc public func showPublishAlert(){
        self.sideLayerBarDragged = true
        PLMPresenter.shared.sheetDataSource.showPublishtextView = true
    }
    
    @objc func handleDismiss(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            sideLayerBarDragged = true
        case .changed:
//            viewTranslation = sender.translation(in: view)
//            UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
//                if self.viewTranslation.y > 0{
//                    self.sideLayerBar.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            
            let pt = (sender.location(in: sender.view?.superview))
            sideLayerBar.frame = CGRect(x: 0, y: pt.y, width: self.view.frame.width, height: self.view.frame.height - pt.y)
//            sideLayerBar.backgroundColor = UIColor.red
            print("case shanged : pan gesture",pt.y)

//                }
//            })
        case .ended:
            
//            if viewTranslation.y < 100 {
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .transitionCurlDown, animations: {
////                    self.sideLayerBar.transform = CGAffineTransform(translationX: 0, y: 0)
//                })
//            } else {
////                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
////                    self.sideLayerBar.alpha = 0
////                })
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
//                    self.sideLayerBar.alpha = 0
//                } completion: { success in
//                    self.sideBarMode = .minimized
//                    self.controlBarAddButton.alpha = 1
//                    self.sheetLayerButton.alpha = 1
//                }

//            }
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                if self.sideLayerBar.frame.origin.y > self.screenHeight*0.85 {
                    self.sideLayerBar.frame.origin.y = self.screenHeight
                }else if self.sideLayerBar.frame.origin.y >= self.screenHeight*0.5 && self.sideLayerBar.frame.origin.y <= self.screenHeight*0.85{
//                    self.sideLayerBar.frame.origin.y = self.screenHeight * 0.7
                    self.sideLayerBar.frame = CGRect(x: self.sideLayerBar.frame.origin.x, y: self.screenHeight * 0.7, width: self.sideLayerBar.frame.width, height: self.screenHeight*0.3)
//                    sideLayerBar.frame.height = screenHeight * 0.3
                }else if self.sideLayerBar.frame.origin.y <= self.screenHeight*0.5{
                                    
//                    sideLayerBar.frame.origin.y = screenHeight * 0.2
//                    sideLayerBar.frame.height = screenHeight * 0.8
                    self.sideLayerBar.frame = CGRect(x: self.sideLayerBar.frame.origin.x, y: self.screenHeight * 0.15, width: self.sideLayerBar.frame.width, height: self.screenHeight*0.85)
                }
            } completion: { success in
                if self.sideLayerBar.frame.origin.y > self.screenHeight*0.85 {
                    self.controlBarAddButton.alpha = 1
                    self.sheetLayerButton.alpha = 1
                }
                self.sideLayerBarDragged = false
            }
        default:
            break
        }
    }
    public func updateData()
    {
        planSheetImageMasterView.imageCntrlr.imgPhotoHolder.frame.size.width = 0
        let encodedImageString = selectedThumbnail.OriginalImage.base64EncodedString()
        if let imageData2 = Data(base64Encoded: encodedImageString) {
            let img = UIImage(data: imageData2)
            planSheetImageMasterView.imageCntrlr.imgPhoto.image = img//selectedThumbnail.OriginalImage
            planSheetImageMasterView.imageCntrlr.imgPhotoHolder.image = img//selectedThumbnail.OriginalImage
            sheetScaleWidth = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size.width ?? 0
            sheetScaleHeight = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size.height ?? 0
            planSheetImageMasterView.imageCntrlr.scrollView.zoomScale = 1
            markerLayer.rotator.alpha = 0
            planSheetImageMasterView.layoutSubviews()
        }
    }
    public func changeMode() {
        animateSideLayerBar()
        self.sideLayerBar.setMode(sideBarModeParam: self.sideBarMode)
    }
    func getColor(val : RGB_O_ColorType)->UIColor
    {
        if val.redValue == -1
        {
            return UIColor.clear
        }
        else {
            let clr = UIColor.init(red: val.redValue/255, green: val.greenValue/255, blue: val.blueValue/255, alpha: val.opacity)
            return clr
        }
    }
    public func animateSideLayerBar () {
        
        if sideBarMode == .minimized {
            sideBarMode = .maximized

            UIView.animate(withDuration: 0.1, animations: {
                self.sideLayerBar.frame = CGRect(x: 10 , y: (self.view.frame.size.height/2) - 250, width: 250, height: 400)
            }) { (completed) in
                
               
            }
        }
        else{
            
            sideBarMode = .minimized
            UIView.animate(withDuration: 0.1, animations: {
                self.sideLayerBar.frame = CGRect(x: 10 , y: self.view.frame.size.height/2 - 250, width: 50, height: 50)
            }) { (completed) in
                
            }
        }
        
        
    }
    @objc public func animateSideLayerBarForiPhone(){
        self.controlBarAddButton.alpha = 0
        self.sheetLayerButton.alpha = 0
        self.sideLayerBarDragged = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.sideLayerBar.frame = CGRect(x: self.sideLayerBar.frame.origin.x, y: self.screenHeight * 0.7, width: self.sideLayerBar.frame.width, height: self.screenHeight*0.3)
        } completion: { completed in
            self.sideLayerBarDragged = false
        }
    }
    public func hideColorBar()
    {
        colorBar.view.alpha = 0
    }
    public func hideColorbarForiPhone(){
        if controlBarForiPhone.alpha == 1{
            controlBarForiPhone.alpha = 0
            controlBarAddButton.alpha = 1
            sheetLayerButton.alpha = 1
        }
        if shapeBarForiPhone.alpha == 1 {
            shapeBarForiPhone.alpha = 0
            colorBarForiPhone.alpha = 0
            controlBarForiPhone.alpha = 1
        }
        if colorBarForiPhone.alpha == 1{
            colorBarForiPhone.alpha = 0
            controlBarAddButton.alpha = 1
            sheetLayerButton.alpha = 1
        }
    }
    public func pushColorBarSecondVC()
    {
        if iPad{
            colorBar.pushViewController(colorBarSecondVC, animated: true)
    //        layoutSubviews()
            viewWillLayoutSubviews()
        }else{
//            colorBarForiPhone.pushColorPickerView()
            self.present(colorBarSecondVC, animated: true, completion: nil)
        }
    }
    @objc public func backButton(){

       colorBar.popViewController(animated: true)
//        layoutSubviews()
        viewWillLayoutSubviews()
    }
    public func hideColorBar(colorMode : colorModeType)
    {
        if colorBar.view.alpha == 1 && selectedColorMode != colorMode{
          selectedColorMode = colorMode
        }
        else{
          selectedColorMode = colorMode
          colorBar.view.alpha = colorBar.view.alpha == 1 ? 0 : 1
        }
        colorButtonsView.selectedColorMode = selectedColorMode
        colorButtonsView.setSelectedColor(clr : selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor)
        controlBar.fillButton.imgView.backgroundColor = selectedFillColor.redValue == -1 ? .white : getColor(val :selectedFillColor)
        controlBar.strokeButton.imgView.layer.borderColor = selectedStrokeColor.redValue == -1 ? UIColor.white.cgColor : getColor(val :selectedStrokeColor).cgColor
        controlBar.fillButton.imgView.image = selectedFillColor.redValue == -1 ?         UIImage(named: "noColor2") : nil
        controlBar.strokeButton.imgView.image = selectedStrokeColor.redValue == -1 ? UIImage(named: "noColor2") : nil
        
        var type = ""
        if markerLayer.selectedMarkerIndex != -1 && markerLayer.markedViews.count > 0
        {
            if markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .HIGHLIGHTER || markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .PATH || markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .ARROW
            {
                type = "NOFILL"
            }
            if markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .IMAGE
            {
                type = "NOSTROKE"
            }
            if markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .HIGHLIGHTER
            {
                type = "NOOPACITY_NOFILL"
            }
            if markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .TEXT
            {
                type = "NOSIZE"
            }
        }
        colorButtonsView.slider.isHidden = false
        colorButtonsView.valueLabel.isHidden = false
        colorButtonsView.textLabel.isHidden = false
        colorButtonsView.slider.isEnabled = true
        colorButtonsView.opacitySlider.isEnabled = true
        colorButtonsView.enableColors(val: true)
        colorButtonsView.opacitySlider.setValue(Float(100), animated: true)
        colorButtonsView.opacityValueLabel.text = " \(100) %"
        if selectedColorMode == .stroke {
            colorBarFirstVC.navigationItem.title = "Choose Stroke Color"
            colorButtonsView.slider.isHidden = false
            colorButtonsView.valueLabel.isHidden = false
            colorButtonsView.textLabel.isHidden = false
        }
        else if selectedColorMode == .fill{
            colorBarFirstVC.navigationItem.title = "Choose Fill Color"
            colorButtonsView.slider.isHidden = true
            colorButtonsView.valueLabel.isHidden = true
            colorButtonsView.textLabel.isHidden = true
        }
        if type == "NOSIZE"
        {
            colorButtonsView.slider.isEnabled = false
        }
        if type == "NOOPACITY_NOFILL"
        {
            colorButtonsView.opacitySlider.setValue(Float(30), animated: true)
            colorButtonsView.opacityValueLabel.text = " \(30) %"
            colorButtonsView.opacitySlider.isEnabled = false
            if selectedColorMode == .fill{
                colorButtonsView.enableColors(val: false)
            }
        }
        if type == "NOSTROKE"
        {
            if selectedColorMode == .stroke{
                colorButtonsView.opacitySlider.isEnabled = false
                colorButtonsView.enableColors(val: false)
            }
        }
        if type == "NOFILL"
        {
            if selectedColorMode == .fill{
                colorButtonsView.opacitySlider.isEnabled = false
                colorButtonsView.enableColors(val: false)
            }
        }
        colorButtonsView.layoutSubviews()
    }
//    public func hideColorBar(colorMode : colorModeType)
//    {
//        if colorBar.view.alpha == 1 && selectedColorMode != colorMode{
//            selectedColorMode = colorMode
//        }
//        else{
//            selectedColorMode = colorMode
//            colorBar.view.alpha = colorBar.view.alpha == 1 ? 0 : 1
//        }
//        colorButtonsView.setSelectedColor(clr : selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor)
//        controlBar.fillButton.imgView.backgroundColor = selectedFillColor
//        controlBar.strokeButton.imgView.layer.borderColor = selectedStrokeColor.cgColor
//    }
    public func setColorMode(colorMode: colorModeType){
        selectedColorMode = colorMode
        if colorMode == .fill{
            colorBarForiPhone.pageView.sliderView.fillClicked = true
        }else{
            colorBarForiPhone.pageView.sliderView.fillClicked = false
        }
        colorBarForiPhone.pageView.sliderView.showHideStrokeSlider()
        colorBarForiPhone.pageView.colorView.setSelectedColor(clr: selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor)
    }
    
    public func setSelectedColor(clr : RGB_O_ColorType)
    {
        if selectedColorMode == .stroke
        {
            selectedStrokeColor = clr
        }
        else{
            selectedFillColor = clr
        }
        colorButtonsView.setSelectedColor(clr : selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor)
        colorBarForiPhone.pageView.colorView.setSelectedColor(clr: selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor)
        controlBar.fillButton.imgView.backgroundColor = selectedFillColor.redValue == -1  ? .white : getColor(val :selectedFillColor)
        controlBar.strokeButton.imgView.layer.borderColor = selectedStrokeColor.redValue == -1 ? UIColor.white.cgColor : getColor(val :selectedStrokeColor).cgColor
        colorBarForiPhone.fillButton.imgView.backgroundColor = selectedFillColor.redValue == -1  ? .white : getColor(val :selectedFillColor)
        
        colorBarForiPhone.strokeButton.imgView.layer.borderColor = selectedStrokeColor.redValue == -1 ? UIColor.white.cgColor : getColor(val :selectedStrokeColor).cgColor
        
        
        controlBar.fillButton.imgView.image = selectedFillColor.redValue == -1 ?         UIImage(named: "noColor2") : nil
        controlBar.strokeButton.imgView.image = selectedStrokeColor.redValue == -1 ? UIImage(named: "noColor2") : nil
        colorBarForiPhone.fillButton.imgView.image = selectedFillColor.redValue == -1 ? UIImage(named: "noColor2") : nil
        colorBarForiPhone.strokeButton.imgView.image = selectedStrokeColor.redValue == -1 ? UIImage(named: "noColor2") : nil

        if markerLayer.selectedMarkerIndex != -1 && markerLayer.markedViews.count > 0
        {
            markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].setStrokeColor(val: selectedStrokeColor)
            markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].setFillColor(val: selectedFillColor)
            
        }
        if  markerLayer.markedViews[markerLayer.selectedGroupIndex].state == .DRAFT && markerLayer.selectedMarkerIndex != -1
        {
            let t = savedMarkupsType(typeStr: "", plmID: "",sheetID : selectedThumbnail.sheetId, sheetName: selectedThumbnail.title, markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos], lastUpdated: "", state: .DRAFT)
            PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: "", marker: t)
        }
    }
    public func setSelectedSize(percentValue: Int) {
        var s : CGFloat = 3
        if percentValue == 1
        {
            s = 3
        }
        if percentValue == 25
        {
            s = 6
        }
        if percentValue == 50
        {
            s = 9
        }
        if percentValue == 75
        {
            s = 12
        }
        if percentValue == 100
        {
            s = 15
        }
        selectedStrokeWidth = s
        if markerLayer.selectedMarkerIndex != -1 && markerLayer.markedViews.count > 0
        {
//            if markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.type == .PATH
//            {
//                markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].setStrokeWidth(val:s)
//
//            }
//            else {
            let imageViewFrame = planSheetImageMasterView.imageCntrlr.imgPhoto.frame
            let s1 = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size ?? CGSize.zero
            let size2 = (imageViewFrame.size.width < imageViewFrame.size.height) ? imageViewFrame.size.width : imageViewFrame.size.height
            let size3 = (s1.width < s1.height) ? s1.width : s1.height
            let strWidth = ((s/size2) * size3)
            
            markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].markedInfos.originalDetails.originalStrokeWidth = strWidth
                markerLayer.markedViews[markerLayer.selectedGroupIndex].markers[markerLayer.selectedMarkerIndex].setStrokeWidth(val:s)
//            }
        }
    }
    public func setSelectedOpacity(percentValue: Int) {
        let clr = selectedColorMode == .stroke ? selectedStrokeColor : selectedFillColor
        let t = RGB_O_ColorType(redValue: clr.redValue, greenValue: clr.greenValue, blueValue: clr.blueValue, opacity: CGFloat(percentValue)/100)
        setSelectedColor(clr : t)
    }
    public func getStrokeColor()->RGB_O_ColorType
    {
        return selectedStrokeColor
    }
    public func getFillColor() -> RGB_O_ColorType {
        return selectedFillColor
    }
    public func getStrokeWidth() -> CGFloat {
        return selectedStrokeWidth
    }
    public override func viewWillLayoutSubviews() {
//
//    }
//    public override func layoutSubviews() {
        let height = bottomLayoutGuide.length
        if cntrlr == nil{
        planSheetImageMasterView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let s2 : CGFloat = 30
        let s1 : CGFloat = (((70 * 11) + s2) < self.view.frame.size.width) ? 70 : ((self.view.frame.size.width - 60) / 11)
        let s = (s1 * 11) + s2
       
        controlBar.frame = CGRect(x: (self.view.frame.size.width/2) - (s/2) , y: self.view.frame.size.height-70-height, width: s, height: 70)
        
//        controlBar.frame = CGRect(x: (self.frame.size.width/2) - (s / 4) , y: self.frame.size.height - 70, width: 405, height: 70 )
//
//        sideLayerBar.frame = CGRect(x: 10 , y: self.view.frame.size.height/2 - 250, width: sideLayerBar.frame.size.width, height: sideLayerBar.frame.size.height)
        
            if iPad{
                sideLayerBar.frame = CGRect(x: 10 , y: self.view.frame.size.height/2 - 250, width: sideLayerBar.frame.size.width, height: sideLayerBar.frame.size.height)
            }else{
                if !sideLayerBarDragged{
                    sideLayerBar.frame = CGRect(x: 0, y: screenHeight, width: self.view.frame.width, height: self.sideLayerBar.frame.height)
                }
            }
        if colorBarSecondVC == self.colorBar.visibleViewController {
            colorBar.view.frame = CGRect(x: controlBar.frame.origin.x + controlBar.frame.size.width - 420 ,y: self.view.frame.size.height - 540, width: 420 , height: 460)
            
        }
        else{
            colorBar.view.frame = CGRect(x: controlBar.frame.origin.x + controlBar.frame.size.width - 420 ,y: self.view.frame.size.height - 340, width: 420 , height: 260)
        }

        colorButtonsView.frame = CGRect(x:0 ,y: 0, width: 420 , height: 260)
        }
        controlBarAddButton.frame = CGRect(x: (self.view.frame.size.width-40) - (50/2) , y: self.view.frame.size.height-80, width: 50, height: 50)
        sheetLayerButton.frame = CGRect(x: 40 - (50/2) , y: self.view.frame.size.height-80, width: 50, height: 50)
        controlBarForiPhone.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.view.frame.size.width, height: 200)
        controlBarForiPhone.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        colorBarForiPhone.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
        colorBarForiPhone.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        shapeBarForiPhone.frame = CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width, height: 100)
        shapeBarForiPhone.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    public func newShapeMarkerAdd(shapeType: PLMShapeType, pt: CGPoint) {
        hideColorBar()
        markerLayer.deSelectMarker()
        let s = self.getImageViewFrame()
        var pt1 = pt
        pt1.x = pt1.x - s.origin.x + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.x
        pt1.y = pt1.y - s.origin.y + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.y
        markerLayer.newShapeMarkerAdd(shapeType: shapeType, pt: pt1)
    }
    public func newShapeMarkerMoved(pt: CGPoint) {
        hideColorBar()
        let s = self.getImageViewFrame()
        var pt1 = pt
        pt1.x = pt1.x - s.origin.x + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.x
        pt1.y = pt1.y - s.origin.y + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.y
        markerLayer.newShapeMarkerMoved(pt: pt1)
    }
    public func newShapeMarkerDropped(pt: CGPoint) {
        hideColorBar()
        let s = self.getImageViewFrame()
        var pt1 = pt
        pt1.x = pt1.x - s.origin.x + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.x
        pt1.y = pt1.y - s.origin.y + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.y
        markerLayer.newShapeMarkerDropped(pt: pt1)
    }
    public func clearAll() {
        markerLayer.clearAll()
        selectedThumbnail = sheetsListType(sheetId: "0", thumbnailImage: dummyImage, thumbnailCompressedImage: dummyImage2, OriginalImage: dummyImage, title: "", versionnumber: 0, creater_userID: "", tag: "", lastupdated: Date(), isAvailableOffline: false)
        selectedColorMode = colorModeType.stroke
        sideBarMode = SideBarModeType.minimized
        selectedStrokeColor = redColor
        selectedFillColor = clearColor
        selectedStrokeWidth = 3
        lastPointForPathType = CGPoint.zero
        xPointForPathType = 0
        yPointForPathType = 0
        x_widthPointForPathType = 0
        y_heightlastPointForPathType = 0
        sheetScaleWidth = 0
        sheetScaleHeight = 0
        rullerSourceLength = 0
        sideLayerBar.tableView.reloadTableData()
    }
    public func deSelectMarker()
    {
        markerLayer.deSelectMarker()
    }
    public func imageLayoutUpdated() {
        
        markerLayer.imageHolderFrame = planSheetImageMasterView.imageCntrlr.imgPhoto.frame
        markerLayer.frame = CGRect(x: planSheetImageMasterView.imageCntrlr.imgPhoto.frame.origin.x, y: planSheetImageMasterView.imageCntrlr.imgPhoto.frame.origin.y, width: planSheetImageMasterView.imageCntrlr.imgPhoto.frame.size.width, height: planSheetImageMasterView.imageCntrlr.imgPhoto.frame.size.height)
        
        let imageViewFrame = planSheetImageMasterView.imageCntrlr.imgPhoto.frame
        if imageViewFrame.size != CGSize.zero{
            let s1 = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size ?? CGSize.zero
            for i in 0..<markerLayer.markedViews.count
            {
                for j in 0..<markerLayer.markedViews[i].markers.count
                {
                    
                    let size : CGFloat = 20
                    let halfSize : CGFloat = 10

                    if markerLayer.markedViews[i].markers[j].markedInfos.type != .RULLER{
                        
                        let size2 = (imageViewFrame.size.width < imageViewFrame.size.height) ? imageViewFrame.size.width : imageViewFrame.size.height
                        let size3 = (s1.width < s1.height) ? s1.width : s1.height
                        let strWidth = ((markerLayer.markedViews[i].markers[j].markedInfos.originalDetails.originalStrokeWidth/size3) * size2)

                        markerLayer.drawableDefaultCollection.strokeWidth = strWidth
                        
                        let s2 = markerLayer.markedViews[i].markers[j].markedInfos.originalDetails.originalFrameRect == CGRect.zero ? imageViewFrame : markerLayer.markedViews[i].markers[j].markedInfos.originalDetails.originalFrameRect
                        
                        let (x1,y1,w1,h1) = frameComputing.computeForAllMarkupsWhenImageLayoutUpdated(s2: s2, s1: s1, imageViewFrame: imageViewFrame)
                        
                        let x = x1-halfSize
                        let y = y1-halfSize
                        let w = w1+size
                        let h = h1+size

                        markerLayer.markedViews[i].markers[j].transform = .identity
                        markerLayer.markedViews[i].markers[j].markedInfos.drawableDetails.drawableframeRect = CGRect(x: x, y: y, width: w, height: h)
                        markerLayer.markedViews[i].markers[j].frame = CGRect(x: x, y: y, width: w, height: h)
                        markerLayer.markedViews[i].markers[j].markedInfos.drawableDetails.drawableStrokeWidth = strWidth
                        markerLayer.markedViews[i].markers[j].resetAllProperties()
                        
                        markerLayer.attachRotatorToSelectedMarker()
                    }
                    else
                    {
                        let p3 =  markerLayer.markedViews[i].markers[j].markedInfos.originalDetails.originalRullerPosition.point1
                        let p4 =  markerLayer.markedViews[i].markers[j].markedInfos.originalDetails.originalRullerPosition.point2
                        
                        let (x1,y1,x2,y2) = frameComputing.computeForRULLERWhenImageLayoutUpdated(p3: p3, p4: p4, s1: s1, imageViewFrame: imageViewFrame)

                        markerLayer.markedViews[i].markers[j].markedInfos.drawableDetails.drawableRullerPosition = _2PointsType(point1: CGPoint(x: x1, y: y1), point2: CGPoint(x: x2, y: y2))
                        markerLayer.markedViews[i].markers[j].rullerpoint1Holder.center = CGPoint(x: x1, y: y1)
                        markerLayer.markedViews[i].markers[j].rullerpoint2Holder.center = CGPoint(x: x2, y: y2)
                        markerLayer.markedViews[i].markers[j].layoutSubviews()
                        
                    }
//                    if markerLayer.markedViews[i].state == .DRAFT &&  PLMPresenter.shared.selectedProject != nil
//                    {
//                        let t = savedMarkupsType(plmID: "",sheetID : selectedThumbnail.sheetId, sheetName: selectedThumbnail.title, markupName: "Draft", date: "", createdByUserID: "", createdByUserName : "", access: "", markedInfos: [markerLayer.markedViews[i].markers[j].markedInfos], lastUpdated: "", state: .DRAFT)
//                        PLMDBProcessor.shared.storeMarkupsListingTypeForDraft(projectId: PLMPresenter.shared.selectedProject!.projectID, marker: t)
//                    }
              }
           }
       }
    }
    
    public func addNewMarkerGroup()
    {
        markerLayer.markedViews.append(markedGroupCellType(expanded: false, typeStr : "", allHidden: false, title: PLMPresenter.shared.sheetDataSource.sendTitle, permissionType: .EDITABLE, state: .DRAFT, markers: []))
        markerLayer.selectedGroupIndex = markerLayer.markedViews.count - 1
        sideLayerBar.tableView.reloadTableData()
    }
    public func addMarkedInfos(allMarkers : [savedMarkupsType])
    {
        for i in 0..<allMarkers.count
        {
            if i >= markerLayer.markedViews.count
            {
                markerLayer.markedViews.append(markedGroupCellType(expanded: false, typeStr : allMarkers[i].typeStr, allHidden: false, title: allMarkers[i].markupName, permissionType: .VIEWABLE, state: allMarkers[i].state, markers: []))
                    markerLayer.selectedGroupIndex = i
            }
            for marker in allMarkers[i].markedInfos
            {
                if marker.type == .RECT
                {
                    markerLayer.createRectMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .ROUND
                {
                    markerLayer.createRoundMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .ARCS
                {
                    markerLayer.createArcsMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .TEXT
                {
                    markerLayer.createTextMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .PATH
                {
                    markerLayer.createPathMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .HIGHLIGHTER
                {
                    markerLayer.createHighlightMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .IMAGE
                {
                    markerLayer.createImageMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
                }
                else if marker.type == .RULLER
                {
                    let f = getImageViewFrame()
                    markerLayer.createRullerMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: CGRect.zero, markedInfos: marker, state: allMarkers[i].state)
                    let ms = (markerLayer.markedViews[markerLayer.markedViews.count - 1]).markers
                    (markerLayer.markedViews[markerLayer.markedViews.count - 1]).markers[ms.count - 1].frame = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
    
                }
                else if marker.type == .ARROW
                {
                    markerLayer.createArrowMarker(lineWidth: 5, pt: CGPoint.zero, frameRect: CGRect.zero, enableHolders: false, originalSizeParam: marker.originalDetails.originalFrameRect, markedInfos: marker, state : allMarkers[i].state)
    
                }
            }
            if(i != allMarkers.count - 1){
                changeVisibility(groupIndex: i, shouldHide: true)
            }
        }
        imageLayoutUpdated()
        
    }
    public func getMarkersList()->[markedGroupCellType] {
        return markerLayer.markedViews
    }
    public func layerListReload()
    {
        if cntrlr == nil{
            sideLayerBar.tableView.reloadTableData()
        }
    }
    public func changeExpansion(indexedRow : Int,indexedSection : Int, expanded : Bool)
    {
        markerLayer.markedViews[indexedSection].expanded = expanded
    }
    public func changeVisibility(indexedRow : Int,indexedSection : Int)
    {
        if markerLayer.markedViews[indexedSection].markers[indexedRow].visible {
            markerLayer.markedViews[indexedSection].markers[indexedRow].visible = false
            markerLayer.markedViews[indexedSection].markers[indexedRow].alpha = 0
        }
        else{
            markerLayer.markedViews[indexedSection].markers[indexedRow].visible = true
            markerLayer.markedViews[indexedSection].markers[indexedRow].alpha = 1
        }
        if markerLayer.selectedGroupIndex == indexedSection && markerLayer.selectedMarkerIndex == indexedRow
        {
            markerLayer.rotator.alpha = 0
        }
        sideLayerBar.tableView.reloadTableData()
    }
    public func changeVisibility(groupIndex : Int, shouldHide: Bool)
    {
        for j in 0..<markerLayer.markedViews[groupIndex].markers.count
        {
            if shouldHide {
                markerLayer.markedViews[groupIndex].markers[j].visible = false
                markerLayer.markedViews[groupIndex].markers[j].alpha = 0
            }
            else{
                markerLayer.markedViews[groupIndex].markers[j].visible = true
                markerLayer.markedViews[groupIndex].markers[j].alpha = 1
            }
        }
        if markerLayer.selectedGroupIndex == groupIndex
        {
            markerLayer.rotator.alpha = 0
        }
        sideLayerBar.tableView.reloadTableData()
    }
    public func changeLock(indexedRow : Int,indexedSection : Int)
    {
        if markerLayer.markedViews[indexedSection].markers[indexedRow].markedInfos.isLocked {
            markerLayer.markedViews[indexedSection].markers[indexedRow].setLock(val: false)
        }
        else{
            markerLayer.markedViews[indexedSection].markers[indexedRow].setLock(val: true)
        }
        if markerLayer.selectedGroupIndex == indexedSection && markerLayer.selectedMarkerIndex == indexedRow
        {
            markerLayer.rotator.alpha = 0
        }
        sideLayerBar.tableView.reloadTableData()
    }
    public func changeLock(groupIndex : Int, shouldLock: Bool)
    {
        for j in 0..<markerLayer.markedViews[groupIndex].markers.count
        {
            markerLayer.markedViews[groupIndex].markers[j].setLock(val: shouldLock)
        }
        if markerLayer.selectedGroupIndex == groupIndex
        {
            markerLayer.rotator.alpha = 0
        }
        sideLayerBar.tableView.reloadTableData()
    }
    public func changeVisibilityAllLayer(shouldHide: Bool)
    {
        for i in 0..<markerLayer.markedViews.count
        {
            for j in 0..<markerLayer.markedViews[i].markers.count
            {
                if shouldHide {
                    markerLayer.markedViews[i].markers[j].visible = false
                    markerLayer.markedViews[i].markers[j].alpha = 0
                }
                else{
                    markerLayer.markedViews[i].markers[j].visible = true
                    markerLayer.markedViews[i].markers[j].alpha = 1
                }
            }
        }
        markerLayer.rotator.alpha = 0
        sideLayerBar.tableView.reloadTableData()
    }
    public func copyMarkers(groupIndex : Int)
    {
        markersCopy.removeAll()
        markersCopy.append(contentsOf: markerLayer.markedViews[groupIndex].markers)
    }
    public func pasteMarkers(groupIndex : Int)
    {
        for marker in markersCopy{
            let frect = marker.frame
            let drect = marker.markedInfos.drawableDetails.drawableframeRect
            let orect = marker.markedInfos.originalDetails.originalFrameRect
            switch (marker.markedInfos.type)
            {
            case .unknown:
                break
            case .RECT:
                markerLayer.createRectMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .ROUND:
                markerLayer.createRoundMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .ARCS:
                break
            case .TEXT:
                markerLayer.createRectMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .PATH:
                markerLayer.createPathMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .HIGHLIGHTER:
                markerLayer.createHighlightMarkerPaste(lineWidth: 5, frameRect: drect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .IMAGE:
                markerLayer.createImageMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .RULLER:
                markerLayer.createRullerMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            case .ARROW:
                markerLayer.createArrowMarkerPaste(lineWidth: 5, frameRect: frect, enableHolders: false, originalSizeParam: orect, markedInfos: marker.markedInfos, state : .DRAFT)
                break
            }
            
//            marker.visible = true
//            markerLayer.markedViews[groupIndex].markers.append(marker)
//            markerLayer.addSubview(marker)
//            marker.groupIndex = groupIndex
//            marker.rowIndex = markerLayer.markedViews[marker.groupIndex].markers.count-1
//            marker.isThisSavedMarker = false
//            marker.delegate = markerLayer
//            layerListReload()
        }
        changeVisibility(groupIndex: groupIndex, shouldHide: false)
        imageLayoutUpdated()
    }
    public func showArea(indexedRow: Int, indexedSection: Int, show : Bool, type : MeasurmentsType) {
        switch(type){
        case .area:
            markerLayer.markedViews[indexedSection].markers[indexedRow].markedInfos.measurmnetsVisible.areaShown = show
            break
        case .length:
            markerLayer.markedViews[indexedSection].markers[indexedRow].markedInfos.measurmnetsVisible.lengthShown = show
            break
        case .breadth:
            markerLayer.markedViews[indexedSection].markers[indexedRow].markedInfos.measurmnetsVisible.breadthShown = show
            break
        }
        markerLayer.markedViews[indexedSection].markers[indexedRow].layoutSubviews()
        sideLayerBar.tableView.reloadTableData()
    }
    public func deleteMarker(indexedRow : Int,indexedSection : Int)
    {
            PLMDBHandler.shared.deleteMarker(neededProjectID: "", thisMarkerID: markerLayer.markedViews[indexedSection].markers[indexedRow].markedInfos.thisMarkerID, tableName: PLMDBProcessor.MarkupsListingTypeTableName, completion : {(success) in

        })
        markerLayer.markedViews[indexedSection].markers[indexedRow].removeFromSuperview()
        markerLayer.markedViews[indexedSection].markers.remove(at: indexedRow)
        for j in 0..<markerLayer.markedViews[indexedSection].markers.count
        {
            markerLayer.markedViews[indexedSection].markers[j].rowIndex = j
            if markerLayer.selectedGroupIndex == indexedSection && markerLayer.selectedMarkerIndex == j
            {
                markerLayer.rotator.alpha = 0
            }
        }
        sideLayerBar.tableView.reloadTableData()
    }
    public func copyMarkers(indexedRow: Int, indexedSection: Int) {
        markersCopy.removeAll()
        markersCopy.append(contentsOf: [markerLayer.markedViews[indexedSection].markers[indexedRow]])
    }
    
    public func pasteMarkers(indexedRow: Int, indexedSection: Int) {
        pasteMarkers(groupIndex : indexedSection)
    }
    public func deleteMarker(groupIndex : Int)
    {
        if groupIndex < markerLayer.markedViews.count{

            for i in 0..<markerLayer.markedViews[groupIndex].markers.count
            {
                    PLMDBHandler.shared.deleteMarker(neededProjectID: "", thisMarkerID: markerLayer.markedViews[groupIndex].markers[i].markedInfos.thisMarkerID, tableName: PLMDBProcessor.MarkupsListingTypeTableName, completion : {(success) in

                    })
                markerLayer.markedViews[groupIndex].markers[i].removeFromSuperview()
            }
            markerLayer.markedViews.remove(at: groupIndex)
            if markerLayer.selectedGroupIndex == groupIndex
            {
                markerLayer.rotator.alpha = 0
            }
        }
        for i in 0..<markerLayer.markedViews.count
        {
            for j in 0..<markerLayer.markedViews[i].markers.count
            {
                markerLayer.markedViews[i].markers[j].groupIndex = i
                markerLayer.markedViews[i].markers[j].rowIndex = j
            }
        }
        sideLayerBar.tableView.reloadTableData()
    }
    public func getCopyCount(groupIndex: Int) -> Int {
        return markersCopy.count
    }
    public func setScale(text : String)
    {
        if PLMPresenter.shared.sheetDataSource.selectedMeasurmentUnit == PLMPresenter.shared.sheetDataSource.sizes[2]
        {
            sheetScaleWidth = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size.width ?? 0
            sheetScaleHeight = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size.height ?? 0
        }
        else{
            if let n = NumberFormatter().number(from: text) {
                let num = CGFloat(truncating: n)
                let ratio = num / rullerSourceLength
                sheetScaleWidth = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size.width ?? 0
                sheetScaleHeight = planSheetImageMasterView.imageCntrlr.imgPhoto.image?.size.height ?? 0
                sheetScaleWidth = sheetScaleWidth * ratio
                sheetScaleHeight = sheetScaleHeight * ratio
                self.imageLayoutUpdated()
            }
        }
        for markers in markerLayer.markedViews
        {
            for marker in markers.markers
            {
                marker.setAreaText()
            }
        }
    }
    public func setselectedRullerSize(dist:CGFloat)
    {
        rullerSourceLength = dist
    }
    public func getImageViewFrame()->CGRect
    {
        return planSheetImageMasterView.imageCntrlr.imgPhoto.frame
    }
    public func shapesClickedOniPhone(){
//        self.controlBarForiPhone.removeFromSuperview()
        controlBarForiPhone.alpha = 0
//        self.view.addSubview(shapeBarForiPhone)
        shapeBarForiPhone.alpha = 1
    }
    @objc public func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        print("tap pan : tap began")
        touchBegan()
        touchBeganTapMarkerSource(gestureRecognizer)
        if markerLayer.selectedMarkerToBeAdded != .unknown{
            let pt = (gestureRecognizer.location(in: gestureRecognizer.view))
            newShapeMarkerMoved(pt: pt)
            newShapeMarkerDropped(pt: pt)
            markerLayer.selectedMarkerToBeAdded = .unknown
            restSelectedMarker()
            disableHolders()
            imageLayoutUpdated()
        }
    }
    @objc public func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            touchBegan()
            touchBeganPanMarkerSource(gestureRecognizer)
            print("tap pan : pan began")
            break
        case .changed:
            print("tap pan : pan moved")
            touchMovedPanMarkerSource(gestureRecognizer)
            break
        case .possible:
            break
        case .ended:
            touchStoppedPanMarkerSource(gestureRecognizer)
            break
        case .cancelled:
            touchStoppedPanMarkerSource(gestureRecognizer)
            break
        case .failed:
            touchStoppedPanMarkerSource(gestureRecognizer)
            break
        @unknown default:
            break
        }
    }
    public func touchBegan()
    {
        disableHolders()
        markerLayer.selectedMarkerIndex = -1
        markerLayer.attachRotatorToSelectedMarker()
        hideColorBar()
        hideColorbarForiPhone()
    }
    public func touchBeganTapMarkerSource(_ gestureRecognizer: UITapGestureRecognizer){
        let pttmp = (gestureRecognizer.location(in: gestureRecognizer.view))
        let pt = CGPoint(x: pttmp.x + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.x, y: pttmp.y + planSheetImageMasterView.imageCntrlr.scrollView.contentOffset.y)
        let s = getImage().size
        let t = getImageViewFrame()
        if (pt.x - t.origin.x) > 0 && (pt.x - t.origin.x) < t.size.width && (pt.y - t.origin.y) > 0 && (pt.y - t.origin.y) < t.size.height{
            if markerLayer.selectedMarkerToBeAdded == .RULLER
            {
                let ygap : CGFloat = (pt.y - t.origin.y + 50) > t.size.height ? -50 : +50
                let xgap : CGFloat = (pt.x - t.origin.x + 50) > t.size.width ? -50 : +50
                markerLayer.newShapeMarkerAdd(shapeType : .RULLER, pt : pt)
                let h = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].rullerpoint1Holder.center = CGPoint(x: pt.x - t.origin.x, y: pt.y - t.origin.y)
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].rullerpoint2Holder.center = CGPoint(x: pt.x + xgap - t.origin.x, y: pt.y + ygap - t.origin.y)
                let p1 =  markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].rullerpoint1Holder.center
                let p2 =  markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].rullerpoint2Holder.center
                let p3 =  CGPoint(x: (p1.x/t.size.width) * s.width, y: (p1.y/t.size.height) * s.height)
                let p4 =  CGPoint(x: (p2.x/t.size.width) * s.width, y: (p2.y/t.size.height) * s.height)
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].markedInfos.drawableDetails.drawableRullerPosition = _2PointsType(point1: p1, point2: p2)
                
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].markedInfos.originalDetails.originalRullerPosition = _2PointsType(point1: p3, point2: p4)
                
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].layoutSubviews()
//                markerLayer.selectedMarkerToBeAdded = .unknown
//                markerLayer.selectedGroupIndex = markerLayer.markedViews.count - 1
//                markerLayer.selectedMarkerIndex = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
//                restSelectedMarker()
//                disableHolders()
            }
            if markerLayer.selectedMarkerToBeAdded == .ARROW
            {
                let fullsize : CGFloat = 20
                let halfSize : CGFloat = 10
                markerLayer.newShapeMarkerAdd(shapeType : .ARROW, pt : pt)
                let h = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
                let rect = CGRect(x: pt.x - t.origin.x - 40, y: pt.y - t.origin.y - 20, width: 80, height: 40)
                let rect2 = CGRect(x: pt.x - t.origin.x - 40 - halfSize, y: pt.y - t.origin.y - 20 - halfSize, width: 80 + fullsize, height: 40 + fullsize)
                let rect3 = CGRect(x:(rect.origin.y/t.width)*s.width, y: (rect.origin.x/t.height)*s.height, width: (rect.size.width/t.width)*s.width, height: (rect.size.height/t.height)*s.height)
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].markedInfos.drawableDetails.drawableframeRect = rect
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].markedInfos.originalDetails.originalFrameRect = rect3
                
                
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].frame = rect2
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].resetAllProperties()
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].layoutSubviews()
//                markerLayer.selectedMarkerToBeAdded = .unknown
                
//                markerLayer.selectedGroupIndex = markerLayer.markedViews.count - 1
//                markerLayer.selectedMarkerIndex = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
//                restSelectedMarker()
//                disableHolders()
//                imageLayoutUpdated()
               
            }
            if markerLayer.selectedMarkerToBeAdded == .ARCS || markerLayer.selectedMarkerToBeAdded == .RECT || markerLayer.selectedMarkerToBeAdded == .ROUND || markerLayer.selectedMarkerToBeAdded == .TEXT || markerLayer.selectedMarkerToBeAdded == .IMAGE
            {
                let fullsize : CGFloat = 20
                let halfSize : CGFloat = 10
                markerLayer.newShapeMarkerAdd(shapeType : markerLayer.selectedMarkerToBeAdded, pt : pt)
                let h = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
                let rect = CGRect(x: pt.x - t.origin.x - 40, y: pt.y - t.origin.y - 20, width: 100, height: 100)
                let rect2 = CGRect(x: pt.x - t.origin.x - 40 - halfSize, y: pt.y - t.origin.y - 20 - halfSize, width: 100 + fullsize, height: 100 + fullsize)
                let rect3 = CGRect(x:(rect.origin.y/t.width)*s.width, y: (rect.origin.x/t.height)*s.height, width: (rect.size.width/t.width)*s.width, height: (rect.size.height/t.height)*s.height)
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].markedInfos.drawableDetails.drawableframeRect = rect
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].markedInfos.originalDetails.originalFrameRect = rect3
                
                
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].frame = rect2
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].resetAllProperties()
                markerLayer.markedViews[markerLayer.markedViews.count - 1].markers[h].layoutSubviews()
//                markerLayer.selectedMarkerToBeAdded = .unknown
                
//                markerLayer.selectedGroupIndex = markerLayer.markedViews.count - 1
//                markerLayer.selectedMarkerIndex = markerLayer.markedViews[markerLayer.markedViews.count - 1].markers.count - 1
//                restSelectedMarker()
//                disableHolders()
//                imageLayoutUpdated()
               
            }
        }
    }
    
    public func disableHolders()
    {
        for markers in markerLayer.markedViews
        {
            for marker in markers.markers
            {
                marker.shouldEnableHolders(enable: false)
            }
        }
        layerListReload()
    }
    public func getImage()->UIImage
    {
        return planSheetImageMasterView.imageCntrlr.imgPhoto.image ?? UIImage()
    }
    public func getSheetScale()->CGSize
    {
        return CGSize(width: sheetScaleWidth, height: sheetScaleHeight)
    }
    public func getSheetScaleUnit()->String
    {
        return PLMPresenter.shared.sheetDataSource.selectedMeasurmentUnit
    }
    public func selectedMarkerToBeAddedOnTouch(shape:PLMShapeType)
    {
        restSelectedMarker()
        if markerLayer.selectedMarkerToBeAdded == shape
        {
            markerLayer.selectedMarkerToBeAdded = .unknown
        }
        else{
            if shape == .ARROW
            {
                markerLayer.selectedMarkerToBeAdded = .ARROW
                controlBar.arrowButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.arrowButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .RULLER
            {
                markerLayer.selectedMarkerToBeAdded = .RULLER
                controlBar.measureButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.measureButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .PATH
            {
                markerLayer.selectedMarkerToBeAdded = .PATH
                controlBar.penButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.penButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .HIGHLIGHTER
            {
                markerLayer.selectedMarkerToBeAdded = .HIGHLIGHTER
                controlBar.brushButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.brushButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .RECT
            {
                markerLayer.selectedMarkerToBeAdded = .RECT
                controlBar.squareButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.squareButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .ROUND
            {
                markerLayer.selectedMarkerToBeAdded = .ROUND
                controlBar.circleButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.circleButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .ARCS
            {
                markerLayer.selectedMarkerToBeAdded = .ARCS
                controlBar.arcButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.arcButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .TEXT
            {
                markerLayer.selectedMarkerToBeAdded = .TEXT
                controlBar.textButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.textButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
            if shape == .IMAGE
            {
                markerLayer.selectedMarkerToBeAdded = .IMAGE
                controlBar.imageButton.backgroundColor = UIColor(TCAppearance.shared.theme.color.actionButtonFillColor)
                controlBar.imageButton.lbl.textColor = UIColor(TCAppearance.shared.theme.color.actionButtonTextColor)
            }
        }
    }
    public func restSelectedMarker()
    {
        controlBar.squareButton.backgroundColor = .clear
        controlBar.squareButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.circleButton.backgroundColor = .clear
        controlBar.circleButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.arcButton.backgroundColor = .clear
        controlBar.arcButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.textButton.backgroundColor = .clear
        controlBar.textButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.imageButton.backgroundColor = .clear
        controlBar.imageButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.measureButton.backgroundColor = .clear
        controlBar.measureButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.penButton.backgroundColor = .clear
        controlBar.penButton.lbl.textColor =  UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.brushButton.backgroundColor = .clear
        controlBar.brushButton.lbl.textColor =  UIColor(TCAppearance.shared.theme.change.textLabelColor)
        controlBar.arrowButton.backgroundColor = .clear
        controlBar.arrowButton.lbl.textColor =  UIColor(TCAppearance.shared.theme.change.textLabelColor)
    }
    public func showPopOver(cntrlr : PLMPopOverBaseViewCntrlr, sourceView : UIView, size : CGSize, arrowSide : UIPopoverArrowDirection, height : Float) {
        
        if iPad{
            cntrlr.modalPresentationStyle = UIModalPresentationStyle.popover
            cntrlr.preferredContentSize = size
            cntrlr.popoverPresentationController?.sourceView = sourceView
            cntrlr.popoverPresentationController?.permittedArrowDirections = arrowSide
            self.cntrlr = cntrlr
            self.cntrlr?.delegate = self
            self.present(cntrlr, animated: true, completion: nil)
        }else{
            self.cntrlr = cntrlr
            //            let alert:UIAlertController = UIAlertController(title: "" ,message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let alert = CustomAlertController(title: "", message: "", preferredStyle: .actionSheet)
            var heightConstraint:NSLayoutConstraint = NSLayoutConstraint(
                item: alert.view, attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1, constant: CGFloat(height)+90)
            alert.view.addConstraint(heightConstraint)
            alert.custView.frame = CGRect(x: 8.0, y: 8.0, width: alert.view.bounds.size.width - 8.0 * 2, height: CGFloat(height))
            view.backgroundColor = .red
            alert.custView.addSubview((self.cntrlr?.view)!)
            // Present the controller
            let cancelAction = UIAlertAction(title: "Close", style: .cancel)
            {
                UIAlertAction in
                alert.dismiss(animated: true)
            }

            alert.addAction(cancelAction)
            alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .clear
//            //alert.view.tintColor = .yellow
            cancelAction.setValue(TCAppearance.shared.theme.change.textActionButtonTextUIColor, forKey: "titleTextColor")
            
            
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    public func closePopOver()
    {
        if self.cntrlr != nil
        {
            if iPad{
                self.cntrlr?.dismiss(animated: true)
                popOverDismissed()
            }
        }
    }
    public func popOverDismissed() {
        self.cntrlr = nil
    }
    public func shapeMarkerDisableAllHolder() {
        markerLayer.shapeMarkerDisableAllHolder()
        markerLayer.rotator.alpha = 0
    }
    public func getSelectedIndex()->(Int,Int)
    {
        return(markerLayer.selectedMarkerIndex, markerLayer.selectedGroupIndex)
    }
    public func getSheetId()->String
    {
        return selectedThumbnail.sheetId
    }
    public func getSheetName()->String
    {
        return selectedThumbnail.title
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
