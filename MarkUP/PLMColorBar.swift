//
//  PLMColorBar.swift
//  PlanMarkup
//
//  Created by puviyarasan on 22/01/22.
//


import Foundation
import UIKit

import AppearanceFramework
public protocol PLMColorBarDelegate : AnyObject {
    func setSelectedColor(clr : RGB_O_ColorType)
    func setSelectedSize(percentValue : Int)
    func setSelectedOpacity(percentValue : Int)
    func pushColorBarSecondVC()
}
public class PLMColorBar : UIView {
    
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var brownButton = UIButton()
    var orangeButton = UIButton()
    var blueButton = UIButton()
    var redButton = UIButton()
    var greenButton = UIButton()
    var yellowButton = UIButton()
    var noColorButton = UIButton()
    var blackButton = UIButton()
    var whiteButton = UIButton()
    var customButton = UIButton()
    var selectedColor = UIColor.red
    
    var step: Float = 25
    
    
    var slider = UISlider()
    var valueLabel = UILabel()
    var textLabel = UILabel()
    
    var opacitySlider = UISlider()
    var opacityValueLabel = UILabel()
    var opacityTextLabel = UILabel()
    
    var selectedColorMode = colorModeType.stroke
    //var vc = UIViewController()
    weak var delegate : PLMColorBarDelegate?
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        addButtons(button: brownButton, clr: .brown)
        brownButton.addTarget(self, action: #selector(selectedBrown), for: .touchUpInside)
        addButtons(button: orangeButton, clr: .orange)
        orangeButton.addTarget(self, action: #selector(selectedOrange), for: .touchUpInside)
        addButtons(button: blueButton, clr: .blue)
        blueButton.addTarget(self, action: #selector(selectedBlue), for: .touchUpInside)
        addButtons(button: redButton, clr: .red)
        redButton.addTarget(self, action: #selector(selectedRed), for: .touchUpInside)
        addButtons(button: greenButton, clr: .green)
        greenButton.addTarget(self, action: #selector(selectedGreen), for: .touchUpInside)
        addButtons(button: yellowButton, clr: .yellow)
        yellowButton.addTarget(self, action: #selector(selectedYellow), for: .touchUpInside)
        addButtons(button: noColorButton, clr: .clear)
        noColorButton.setImage(UIImage(named: "noColor2"), for: .normal)
        noColorButton.addTarget(self, action: #selector(selectedNoColorButton), for: .touchUpInside)
        addButtons(button: blackButton, clr: .black)
        blackButton.addTarget(self, action: #selector(selectedBlack), for: .touchUpInside)
        addButtons(button: whiteButton, clr: .white)
        whiteButton.addTarget(self, action: #selector(selectedWhite), for: .touchUpInside)
        whiteButton.layer.borderColor = UIColor.gray.cgColor
        addButtons(button: customButton, clr: .clear)
        customButton.setImage(UIImage(named: "colorPicker"), for: .normal)
        customButton.addTarget(self, action: #selector(selectedCustom), for: .touchUpInside)
        
        if iPad{
            self.addSubview(slider)
            slider.minimumValue = 1
            slider.maximumValue = 100
            slider.isContinuous = true
            slider.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            slider.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
            
            addSubview(valueLabel)
            valueLabel.text = "\(Int(slider.value)) %"
            valueLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            
            
            addSubview(textLabel)
            textLabel.text = "Hardness/Size"
            // textLabel.font = textLabel.font.withSize(25)
            textLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            textLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.textAlignment = .center
            
            self.addSubview(opacitySlider)
            opacitySlider.minimumValue = 1
            opacitySlider.maximumValue = 100
            opacitySlider.setValue(100, animated: false)
            opacitySlider.isContinuous = true
            opacitySlider.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            opacitySlider.addTarget(self, action: #selector(self.opacitySliderValue(_:)), for: .valueChanged)
            
            addSubview(opacityValueLabel)
            opacityValueLabel.text = "\(Int(opacitySlider.value)) %"
            opacityValueLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            
            addSubview(opacityTextLabel)
            opacityTextLabel.text = "Opacity"
            opacityTextLabel.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            //opacityTextLabel.font = opacityTextLabel.font.withSize(15)
            opacityTextLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            //opacityTextLabel.adjustsFontSizeToFitWidth = true
            opacityTextLabel.textAlignment = .center
        }
        
    }
    public func addButtons(button : UIButton, clr : UIColor)
    {
        self.addSubview(button)
        button.backgroundColor = clr
        button.layer.cornerRadius = 15
        button.layer.borderColor = (clr == .clear) ? UIColor.lightGray.cgColor : UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = .zero
    }
    public func setSelectedColor(clr : RGB_O_ColorType)
    {
//        selectedColor = clr
        brownButton.layer.borderWidth = 0.5
        orangeButton.layer.borderWidth = 0.5
        blueButton.layer.borderWidth = 0.5
        redButton.layer.borderWidth = 0.5
        greenButton.layer.borderWidth = 0.5
        yellowButton.layer.borderWidth = 0.5
        noColorButton.layer.borderWidth = 0.5
        blackButton.layer.borderWidth = 0.5
        whiteButton.layer.borderWidth = 0.5
        customButton.layer.borderWidth = 0.5
        
        var clr1 = UIColor.init(red: 162/255, green: 42/255, blue: 42/255, alpha: 1).rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            brownButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.init(red: 255/255, green: 165/255, blue: 0, alpha: 1).rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            orangeButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.blue.rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            blueButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.red.rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            redButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.green.rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            greenButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.yellow.rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            yellowButton.layer.borderWidth = 5
            return
        }
        if (-1 == clr.redValue) && (-1 == clr.greenValue) && (-1 == clr.blueValue)
        {
            noColorButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.black.rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            blackButton.layer.borderWidth = 5
            return
        }
        clr1 = UIColor.white.rgb()
        if (CGFloat(clr1?.red ?? 255) == clr.redValue) && (CGFloat(clr1?.green ?? 255) == clr.greenValue) && (CGFloat(clr1?.blue ?? 255) == clr.blueValue)
        {
            whiteButton.layer.borderWidth = 5
            return
        }
        customButton.layer.borderWidth = 5
//        switch(selectedColor)
//        {
//        case UIColor.brown :
//            brownButton.layer.borderWidth = 5
//            break
//        case UIColor.orange :
//            orangeButton.layer.borderWidth = 5
//            break
//        case UIColor.blue :
//            blueButton.layer.borderWidth = 5
//            break
//        case UIColor.red :
//            redButton.layer.borderWidth = 5
//            break
//        case UIColor.green :
//            greenButton.layer.borderWidth = 5
//            break
//        case UIColor.yellow :
//            yellowButton.layer.borderWidth = 5
//            break
//        case UIColor.clear :
//            noColorButton.layer.borderWidth = 5
//            break
//        case UIColor.black :
//            blackButton.layer.borderWidth = 5
//            break
//        case UIColor.white :
//            whiteButton.layer.borderWidth = 5
//            break
//        default:
//            break
//        }
        opacitySlider.setValue(Float(clr.opacity), animated: true)
    }
    func enableColors(val:Bool)
    {
        brownButton.isEnabled = val
        orangeButton.isEnabled = val
        blueButton.isEnabled = val
        redButton.isEnabled = val
        greenButton.isEnabled = val
        yellowButton.isEnabled = val
        noColorButton.isEnabled = val
        blackButton.isEnabled = val
        whiteButton.isEnabled = val
        customButton.isEnabled = val
    }
    @objc public func selectedBrown()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 162, greenValue: 42, blueValue: 42, opacity: 1))
    }
    @objc public func selectedOrange()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 255, greenValue: 165, blueValue: 0, opacity: 1))
    }
    @objc public func selectedBlue()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 0, greenValue: 0, blueValue: 255, opacity: 1))
    }
    @objc public func selectedRed()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 255, greenValue: 0, blueValue: 0, opacity: 1))
    }
    @objc public func selectedGreen()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 0, greenValue: 255, blueValue: 0, opacity: 1))
    }
    @objc public func selectedYellow()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 255, greenValue: 255, blueValue: 0, opacity: 1))
    }
    @objc public func selectedNoColorButton()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: -1, greenValue: -1, blueValue: -1, opacity: 0))
    }
    @objc public func selectedBlack()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 0, greenValue: 0, blueValue: 0, opacity: 1))
    }
    @objc public func selectedWhite()
    {
        delegate?.setSelectedColor(clr: RGB_O_ColorType(redValue: 255, greenValue: 255, blueValue: 255, opacity: 1))
    }
    @objc public func selectedCustom()
    {
        delegate?.pushColorBarSecondVC()
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
    public override func layoutSubviews() {
        if iPad{
            whiteButton.frame = CGRect(x: 15, y: self.frame.size.height - 50, width: 30, height: 30)
            blackButton.frame = CGRect(x: 55, y:  self.frame.size.height - 50, width: 30, height: 30)
            redButton.frame = CGRect(x: 95, y:  self.frame.size.height - 50, width: 30, height: 30)
            greenButton.frame =  CGRect(x: 135, y:  self.frame.size.height - 50, width: 30, height: 30)
            blueButton.frame = CGRect(x: 175, y:  self.frame.size.height - 50, width: 30, height: 30)
            yellowButton.frame = CGRect(x: 215, y:  self.frame.size.height - 50, width: 30, height: 30)
            orangeButton.frame = CGRect(x: 255, y:  self.frame.size.height - 50, width: 30, height: 30)
            brownButton.frame = CGRect(x: 295, y:  self.frame.size.height - 50, width: 30, height: 30)
            noColorButton.frame = CGRect(x: 335, y:  self.frame.size.height - 50, width: 30, height: 30)
            customButton.frame = CGRect(x: 375, y:  self.frame.size.height - 50, width: 30, height: 30)
            //  colorWell.frame = CGRect(x: 375, y:  self.frame.size.height - 50, width: 30, height: 30)
            
            slider.frame = CGRect(x:  135, y: (self.frame.size.height/2) - 50 , width: 175, height: 10)
            valueLabel.frame = CGRect(x:  self.frame.size.width - 65, y: (self.frame.size.height / 2) - 55 , width: 75, height: 20)
            textLabel.frame = CGRect(x: 15, y: (self.frame.size.height / 2) - 55 , width: 90, height: 25)
            if selectedColorMode == .fill{
                opacitySlider.frame = CGRect(x:  135, y: (self.frame.size.height/2) - 15 , width: 175, height: 10)
                opacityValueLabel.frame = CGRect(x:  self.frame.size.width - 65, y: (self.frame.size.height / 2) - 20 , width: 75, height: 20)
                opacityTextLabel.frame = CGRect(x: 15, y: (self.frame.size.height / 2) - 20 , width: 90, height: 25)
            }
            else{
                opacitySlider.frame = CGRect(x:  135, y: (self.frame.size.height/2) + 15 , width: 175, height: 10)
                opacityValueLabel.frame = CGRect(x:  self.frame.size.width - 65, y: (self.frame.size.height / 2) + 10 , width: 75, height: 20)
                opacityTextLabel.frame = CGRect(x: 15, y: (self.frame.size.height / 2) + 10 , width: 90, height: 25)
            }
        }else{
            let space = (self.frame.size.width-150-20)/4
            let width: CGFloat = 30
            let vSpace = (self.frame.size.height-60)/3
            whiteButton.frame = CGRect(x: 10, y: vSpace, width: 30, height: 30)
            blackButton.frame = CGRect(x: space+width+10, y:  vSpace, width: 30, height: 30)
            redButton.frame = CGRect(x: (space*2)+(width*2)+10, y:  vSpace, width: 30, height: 30)
            greenButton.frame =  CGRect(x: (space*3)+(width*3)+10, y:  vSpace, width: 30, height: 30)
            blueButton.frame = CGRect(x: (space*4)+(width*4)+10, y:  vSpace, width: 30, height: 30)
            yellowButton.frame = CGRect(x: 10, y:  (vSpace*2)+30, width: 30, height: 30)
            orangeButton.frame = CGRect(x: space+width+10, y:  (vSpace*2)+30, width: 30, height: 30)
            brownButton.frame = CGRect(x: (space*2)+(width*2)+10, y: (vSpace*2)+30, width: 30, height: 30)
            noColorButton.frame = CGRect(x: (space*3)+(width*3)+10, y: (vSpace*2)+30, width: 30, height: 30)
            customButton.frame = CGRect(x: (space*4)+(width*4)+10, y: (vSpace*2)+30, width: 30, height: 30)
        }
    }
   
}


public class PLMColorPickerView : UIColorPickerViewController, UIColorPickerViewControllerDelegate{
    
    weak var colorDelegate : PLMColorBarDelegate?
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        
        self.delegate = self
        
       
    }
    public func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let c = viewController.selectedColor.rgb()
        let t = RGB_O_ColorType(redValue: CGFloat(c?.red ?? 0), greenValue: CGFloat(c?.green ?? 0), blueValue: CGFloat(c?.blue ?? 0), opacity: CGFloat(c?.alpha ?? 0))
        colorDelegate?.setSelectedColor(clr: t)
    }
}
extension UIColor {

    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
