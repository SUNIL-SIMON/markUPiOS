//
//  SwiftUIView.swift
//
//
//  Created by Deepak1037 on 24/06/22.
//

import Foundation
import UIKit

import AppearanceFramework

public enum SelectionType{
    case Stroke
    case Fill
    case Hardness
    case Opacity
}
public enum BarType{
    case Colors
    case ColorPicker
    case Stroke
    case Opacity
}

public protocol PLMColorBariPhoneDelegate : AnyObject {
    func setColorMode(colorMode: colorModeType)
    func setSelectedOpacity(percentValue: Int)
    func setSelectedSize(percentValue: Int)
    func showiPhoneColorBarView(isShown: Bool)
}

public class PLMColorBarForiPhone : UIView, UIGestureRecognizerDelegate , UIScrollViewDelegate{
    
    var strokeButton = PLMControBarButton3()
    var fillButton = PLMControBarButton3()
    var strokeSizeButton = PLMControBarButton3()
    var opacityButton = PLMControBarButton3()
    var colorBar = PLMColorBar()
    var colorPickerView = PLMColorPickerView()
    var backbutton = UIButton()
    var selectionViewHolder = UIView()
    var toolsViewHolder = UIView()
    var firstVC = UIViewController()
    var secondVC = UIViewController()
    var pageView = MyPageViewController()
    
    
    var slider = UISlider()
    var valueLabel = UILabel()
    var textLabel = UILabel()
    
    var opacitySlider = UISlider()
    var opacityValueLabel = UILabel()
    var opacityTextLabel = UILabel()
    
    @Published var selectedButton: SelectionType = .Stroke
    
    var step: Float = 25
    
    var lineView = UIView()
    weak var delegate : PLMColorBariPhoneDelegate?
    weak var iPhoneShapesBarDelegate : PLMShapesBariPhoneDelegate?
    
    var showColors: Bool = true
    
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.white
        proxy.currentPageIndicatorTintColor = UIColor.black
        
        self.addSubview(selectionViewHolder)
        self.selectionViewHolder.addSubview(strokeButton)
        strokeButton.imgView.layer.borderWidth = 5
        strokeButton.imgView.layer.cornerRadius = 15
        strokeButton.lbl.text = "Stroke"
        strokeButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        strokeButton.lbl.font = UIFont.boldSystemFont(ofSize: 10)
        strokeButton.imgView.layer.shadowColor = UIColor.black.cgColor
        strokeButton.imgView.layer.shadowOpacity = 0.3
        strokeButton.imgView.layer.shadowOffset = .zero
        strokeButton.addTarget(self, action: #selector(showHideStrokeColorBar), for: .touchUpInside)
        
        self.selectionViewHolder.addSubview(fillButton)
        fillButton.imgView.layer.cornerRadius = 15
        fillButton.lbl.text = "Fill"
        fillButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        fillButton.layer.cornerRadius = 10
        fillButton.imgView.layer.shadowColor = UIColor.black.cgColor
        fillButton.imgView.layer.shadowOpacity = 0.3
        fillButton.imgView.layer.shadowOffset = .zero
        fillButton.addTarget(self, action: #selector(showHideFillColorBar), for: .touchUpInside)
        
        self.addSubview(lineView)
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(TCAppearance.shared.theme.change.textLabelColor).cgColor
        
        self.addSubview(pageView.view)
        
        
    }
    func setSelectedColor(clr: RGB_O_ColorType){
        colorBar.setSelectedColor(clr: clr)
    }
    func disableAllButton(){
        strokeButton.lbl.textColor = UIColor.gray
        strokeButton.lbl.font = UIFont.systemFont(ofSize: 20)
        fillButton.lbl.textColor = UIColor.gray
        fillButton.lbl.font = UIFont.systemFont(ofSize: 20)
    }
    @objc public func showHideFillColorBar()
    {
        delegate?.setColorMode(colorMode: .fill)
        disableAllButton()
        fillButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        fillButton.lbl.font =  UIFont.boldSystemFont(ofSize: 15)
    }
    @objc public func showHideStrokeColorBar()
    {
        delegate?.setColorMode(colorMode: .stroke)
        disableAllButton()
        strokeButton.lbl.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        strokeButton.lbl.font =  UIFont.boldSystemFont(ofSize: 15)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        
        let cornerSpace = self.frame.size.width*0.08
        let height = self.frame.size.height*0.20
        let yPosition = self.frame.size.height*0.87 - (height/2)
        selectionViewHolder.frame = CGRect(x: cornerSpace, y: yPosition, width: self.frame.size.width*0.84, height: 45)
        lineView.frame = CGRect(x: self.frame.size.width*0.04, y: self.frame.size.height*0.7, width: self.frame.size.width*0.92, height: 0.5)
        pageView.view.frame = CGRect(x: self.frame.size.width*0.04, y: 0, width: self.frame.size.width*0.92, height: self.frame.size.height*0.7)
        let space = (self.selectionViewHolder.frame.width-100)/3
        strokeButton.frame = CGRect(x: space, y: 0, width: 50, height: 50)
        fillButton.frame = CGRect(x: (space*2)+50, y: 0, width: 50, height: 50)
        
    }
    
    @objc public func clearAll()
    {
//        delegate?.clearAll()
    }
    
}


class MyPageViewController: UIPageViewController {

    
    var firstVC = UIViewController()
    var secondVC = UIViewController()
    var colorView = PLMColorBar()
    var sliderView = SliderViewController()
    var pages: [UIViewController] = [UIViewController]()

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = nil

        firstVC.view.addSubview(colorView)
        secondVC.view.addSubview(sliderView)

        pages.append(firstVC)
        pages.append(secondVC)

        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    func setSelectedColor(clr: RGB_O_ColorType){
        colorView.setSelectedColor(clr: clr)
    }
    override func viewWillLayoutSubviews() {
        colorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.95)
        sliderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.95)

    }

}

// typical Page View Controller Data Source
extension MyPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return pages.last }

        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return pages.first }

        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
}

// typical Page View Controller Delegate
extension MyPageViewController: UIPageViewControllerDelegate {

    // if you do NOT want the built-in PageControl (the "dots"), comment-out these funcs

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.index(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}

public class SliderViewController: UIView {
    
    var slider = UISlider()
    var valueLabel = UILabel()
    var textLabel = UILabel()
    
    var opacitySlider = UISlider()
    var opacityValueLabel = UILabel()
    var opacityTextLabel = UILabel()
    
    var fillClicked: Bool = false
    
    var step: Float = 25
    weak var delegate : PLMColorBariPhoneDelegate?

    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.addSubview(slider)
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.isContinuous = true
        slider.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        slider.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        
        self.addSubview(valueLabel)
        valueLabel.text = "\(Int(slider.value)) %"
        valueLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
        
        self.addSubview(textLabel)
        textLabel.text = "Hardness/Size"
        textLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        textLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)

        
        self.addSubview(opacitySlider)
        opacitySlider.minimumValue = 1
        opacitySlider.maximumValue = 100
        opacitySlider.setValue(100, animated: false)
        opacitySlider.isContinuous = true
        opacitySlider.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        opacitySlider.addTarget(self, action: #selector(self.opacitySliderValue(_:)), for: .valueChanged)
        
        self.addSubview(opacityValueLabel)
        opacityValueLabel.text = "\(Int(opacitySlider.value)) %"
        opacityValueLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
        self.addSubview(opacityTextLabel)
        opacityTextLabel.text = "Opacity"
        opacityTextLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        opacityTextLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
    }
    
    @objc public func sliderValue(_ sender:UISlider!)
    {
            let roundedStepValue = round(sender.value / step) * step
            sender.value = roundedStepValue
            slider.setValue(roundedStepValue, animated: false)
            let roundValue = Int(sender.value)
            valueLabel.text = " \(roundValue) %"
            delegate?.setSelectedSize(percentValue: roundValue)
            
    }
    
    @objc public func opacitySliderValue(_ sender:UISlider!)
    {
            let Value = round(sender.value)
            sender.value = Value
            opacitySlider.setValue(Value, animated: false)
            let roundValue = Int(sender.value)
            opacityValueLabel.text = " \(roundValue) %"
            delegate?.setSelectedOpacity(percentValue: roundValue)
            
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showHideStrokeSlider(){
        if fillClicked{
            textLabel.alpha = 0
            valueLabel.alpha = 0
            slider.alpha = 0
        }else{
            textLabel.alpha = 1
            valueLabel.alpha = 1
            slider.alpha = 1
        }
        layoutSubviews()
    }
    
    public override func layoutSubviews() {
        let width = self.frame.width
        let height = self.frame.height
        if fillClicked{
            opacityTextLabel.frame = CGRect(x: 10, y: height*0.4, width: width*0.4, height: height*0.1)
            opacityValueLabel.frame = CGRect(x: width-((width*0.15) + 10), y: height*0.4, width: width*0.15, height: height*0.1)
            opacitySlider.frame = CGRect(x: 10, y: height*0.55, width: width-20, height: height*0.15)
        }else{
            opacityTextLabel.frame = CGRect(x: 10, y: height*0.1, width: width*0.4, height: height*0.1)
            opacityValueLabel.frame = CGRect(x: width-((width*0.15) + 10), y: height*0.1, width: width*0.15, height: height*0.1)
            opacitySlider.frame = CGRect(x: 10, y: height*0.25, width: width-20, height: height*0.15)
        }
        textLabel.frame = CGRect(x: 10, y: height*0.5, width: width*0.4, height: height*0.1)
        valueLabel.frame = CGRect(x: width-((width*0.15) + 10), y: height*0.5, width: width*0.15, height: height*0.1)
        slider.frame = CGRect(x: 10, y: height*0.65, width: width-20, height: height*0.15)
    }
}

