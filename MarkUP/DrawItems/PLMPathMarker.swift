//
//  PLMPathMarker.swift
//  PlanMarkup
//
//  Created by SIMON on 20/01/22.
//

import Foundation
import UIKit
import SwiftUI
public class PLMPathMarker : PLMShapeTypeMarker{
    let rect = UIView()
    let itemShapeLayer = CAShapeLayer()
    var shapepath = UIBezierPath()
    public init(frame: CGRect,linePointSize: CGFloat, originalSizeParam : CGRect, markedInfosParam : markedInfoType)
    {
        super.init(frame: frame)
        self.addSubview(rect)
        rect.layer.addSublayer(itemShapeLayer)
//        rect.backgroundColor = .green
        itemShapeLayer.path = shapepath.cgPath
        self.setUpHolders()
        markedInfos = markedInfosParam
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
            itemShapeLayer.frame = CGRect(x: 0, y: 0, width: rect.frame.size.width, height: rect.frame.size.height)
            itemShapeLayer.path = shapepath.cgPath
            self.transform = t
            if markedInfos.originalDetails.originalLayerPath != ""{
                drawSVGPath(path: markedInfos.originalDetails.originalLayerPath)
                drawCGPOINTPath()
                drawPath()
            }
            else{
                drawCGPOINTPath()
                drawPath()
            }
        }
    }
    public override func setStrokeWidth(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableStrokeWidth = val
        self.drawPath()
    }
    override public func setStrokeColor(val:RGB_O_ColorType)
    {
        self.markedInfos.drawableDetails.drawableStrokeColor = val
//        self.markedInfos.originalDetails.originalStrokeColor = val
        self.drawPath()
        
    }
    override public func setAngle(val:CGFloat)
    {
        self.markedInfos.drawableDetails.drawableAngle = val
//        self.markedInfos.originalDetails.originalAngle = val
        let rotateTransform  = CGAffineTransform(rotationAngle: val * CGFloat.pi / 180)
        self.transform = rotateTransform
        self.drawPath()
        
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
            self.setAngle(val: self.markedInfos.drawableDetails.drawableAngle)
            self.setLock(val: self.markedInfos.isLocked)
//        })
    }
    public func drawPath()
    {
        let t = self.transform
        self.transform = .identity
        itemShapeLayer.path = shapepath.cgPath
        itemShapeLayer.lineWidth = markedInfos.drawableDetails.drawableStrokeWidth
        itemShapeLayer.fillColor = UIColor.clear.cgColor
        itemShapeLayer.strokeColor = getColor(val: markedInfos.drawableDetails.drawableStrokeColor).cgColor
        self.transform = t
    }
    public func drawCGPOINTPath()
    {
        let t = self.transform
        self.transform = .identity
        shapepath.removeAllPoints()
        for i in 0..<markedInfos.drawableDetails.drawableLayerPoints.count
        {
            let ptrX = (markedInfos.drawableDetails.drawableLayerPoints[i].x * rect.frame.size.width)//t.size.width) * s.size.width
            let ptrY = (markedInfos.drawableDetails.drawableLayerPoints[i].y * rect.frame.size.height)///t.size.height) * s.size.height
            if i == 0
            {
                shapepath.move(to: CGPoint(x: ptrX, y: ptrY))
            }
            else{
                shapepath.addLine(to: CGPoint(x: ptrX, y: ptrY))
            }
        }
        self.transform = t
    }
    public func drawSVGPath(path : String)
    {
        let s2 = markedInfos.originalDetails.originalFrameRect
        let s1 = delegate?.getImageSize() ?? .zero
        let imageViewFrame = delegate?.getImageViewFrame().size ?? .zero
        
        let strArr = path.components(separatedBy: " ")
        var convertedStr = ""
        var xcoordinate = true
        for stritem in strArr
        {
            if stritem != ""
            {
                if Double(stritem) == nil
                {
                    convertedStr = "\(convertedStr) \(stritem)"
                }
                else
                {
                    if xcoordinate
                    {
                        xcoordinate = false
                        let c  = (s2.origin.y/s1.width)
                        let b = ((Double(stritem) ?? 1)/s1.width) - c
                        let a = (b * imageViewFrame.width)//-rectFrame.origin.x
                        convertedStr = "\(convertedStr) \(a),"
                    }
                    else{
                        xcoordinate = true
                        let c = (s2.origin.x/s1.height)
                        let b = ((Double(stritem) ?? 1)/s1.height) - c
                        let a = (b * imageViewFrame.height)//-rectFrame.origin.y
                        convertedStr = "\(convertedStr)\(a)"
                    }
                }
            }
        }
//        if markedInfos.drawableDetails.drawableStrokeColor == RGB_O_ColorType(redValue: 255, greenValue: 255, blueValue: 255, opacity: 0.4)
//           shapepath = UIBezierPath(svgPath: convertedStr, radius: (markedInfos.drawableDetails.drawableStrokeWidth/10))
//        }
//        else{
            shapepath = UIBezierPath(svgPath:convertedStr)
        if markedInfos.drawableDetails.drawableLayerPoints.count == 0{
            let wd : CGFloat = s2.size.width
            let ht : CGFloat = s2.size.height
            markedInfos.drawableDetails.drawableLayerPoints = shapepath.applyCommandsGetPoints(from: SVGPath(path), offset: 0, wd : wd, ht: ht, x: s2.origin.y, y : s2.origin.x)
        }
    }

}

//
//  PLMSVGPathHandler.swift
//  PlanMarkup
//
//  Created by SIMON on 20/01/22.
//



import Foundation
import CoreGraphics
import UIKit
public extension UIBezierPath {
    
    convenience init (svgPath: String, offset: CGFloat = 0) {
        self.init()
        applyCommands(from: SVGPath(svgPath), offset: offset)
    }
    convenience init (svgPath: String, radius: CGFloat, offset: CGFloat = 0) {
        self.init()
        applyCommandsForHiglighter(from: SVGPath(svgPath), radius: radius, offset: offset)
    }
    convenience init (svgPath: String, frame : CGRect, offset: CGFloat = 0) {
        self.init()
        applyCommandsWitRatio(from: SVGPath(svgPath), frame: frame, offset: offset)
    }
}

extension UIBezierPath {
    func applyCommandsWitRatio(from svgPath: SVGPath, frame : CGRect, offset: CGFloat) {
        for command in svgPath.commands {
            let point = CGPoint(x: command.point.x - offset, y: command.point.y - offset)
            let controlPoint1 = CGPoint(x: (command.control1.x - offset) * 3, y: (command.control1.y - offset) * 3)
            let controlPoint2 = CGPoint(x: (command.control2.x - offset) * 3, y: (command.control2.y - offset) * 3)
            
            switch command.type {
            case .move: move(to: CGPoint(x: point.x * 3, y: point.y * 3) )
            case .line: addLine(to: CGPoint(x: point.x * 3, y: point.y * 3))
            case .quadCurve: addQuadCurve(to: CGPoint(x: point.x * 3, y: point.y * 3), controlPoint: controlPoint1)
            case .cubeCurve: addCurve(to: CGPoint(x: point.x * 3, y: point.y * 3), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            case .close: close()
            }
        }
    }
    func applyCommands(from svgPath: SVGPath, offset: CGFloat) {
        for command in svgPath.commands {
            let point = CGPoint(x: command.point.x.isNaN ? 0 : command.point.x - offset, y: command.point.y.isNaN ? 0 : command.point.y - offset)
            let controlPoint1 = CGPoint(x: command.control1.x.isNaN ? 0 : command.control1.x - offset, y: command.control1.y.isNaN ? 0 : command.control1.y - offset)
            let controlPoint2 = CGPoint(x: command.control2.x.isNaN ? 0 : command.control2.x - offset, y: command.control2.y.isNaN ? 0 : command.control2.y - offset)
            print("command = \(svgPath)")
            switch command.type {
            case .move:
                print("path.move(to: \(command)")
                move(to: point)
            case .line:
                print("path.addLine(to: \(point)")
                addLine(to: point)
            case .quadCurve:
                print("path.addQuadCurve")
                addQuadCurve(to: point, controlPoint: controlPoint1)
            case .cubeCurve:
                print("path.addCurve(to: \(point), controlPoint1: \(controlPoint1), controlPoint2: \(controlPoint2))")
                addCurve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            case .close: close()
            }
        }
    }
    func applyCommandsGetPoints(from svgPath: SVGPath, offset: CGFloat, wd : CGFloat, ht : CGFloat, x : CGFloat, y : CGFloat)->[CGPoint] {
        var r = [CGPoint]()
        for command in svgPath.commands {
            let point = CGPoint(x: command.point.x.isNaN ? 0 : command.point.x - offset, y: command.point.y.isNaN ? 0 : command.point.y - offset)
            let controlPoint1 = CGPoint(x: command.control1.x.isNaN ? 0 : command.control1.x - offset, y: command.control1.y.isNaN ? 0 : command.control1.y - offset)
            let controlPoint2 = CGPoint(x: command.control2.x.isNaN ? 0 : command.control2.x - offset, y: command.control2.y.isNaN ? 0 : command.control2.y - offset)
            print("command = \(svgPath)")
            r.append(CGPoint(x: (point.x - x)/wd, y: (point.y - y)/ht) )
            switch command.type {
            case .move:
                print("path.move(to: \(command)")
                move(to: point)
            case .line:
                print("path.addLine(to: \(point)")
            case .quadCurve:
                print("path.addQuadCurve")
                addQuadCurve(to: point, controlPoint: controlPoint1)
            case .cubeCurve:
                print("path.addCurve(to: \(point), controlPoint1: \(controlPoint1), controlPoint2: \(controlPoint2))")
                addCurve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            case .close: close()
            }
        }
        return r
    }
    func applyCommandsForHiglighter(from svgPath: SVGPath, radius: CGFloat, offset: CGFloat) {
        for command in svgPath.commands {
            let point = CGPoint(x: command.point.x - offset, y: command.point.y - offset)
            let controlPoint1 = CGPoint(x: command.control1.x - offset, y: command.control1.y - offset)
            let controlPoint2 = CGPoint(x: command.control2.x - offset, y: command.control2.y - offset)
            
            switch command.type {
            case .move: addArc(withCenter: point, radius: radius, startAngle: DEGREES_TO_RADIANS(0), endAngle: DEGREES_TO_RADIANS(360), clockwise: true)//move(to: point)
            case .line: addArc(withCenter: point, radius: radius, startAngle: DEGREES_TO_RADIANS(0), endAngle: DEGREES_TO_RADIANS(360), clockwise: true)//(to: point)
            case .quadCurve:
//                addQuadCurve(to: point, controlPoint: controlPoint1)
                addArc(withCenter: point, radius: radius, startAngle: DEGREES_TO_RADIANS(0), endAngle: DEGREES_TO_RADIANS(360), clockwise: true)//addQuadCurve(to: point, controlPoint: controlPoint1)
                
            case .cubeCurve:
//                addCurve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                addArc(withCenter: point, radius: radius, startAngle: DEGREES_TO_RADIANS(0), endAngle: DEGREES_TO_RADIANS(360), clockwise: true)
                
            case .close: addArc(withCenter: point, radius: radius, startAngle: DEGREES_TO_RADIANS(0), endAngle: DEGREES_TO_RADIANS(360), clockwise: true)
                
            }
        }
    }
    func DEGREES_TO_RADIANS(_ degrees: Double) -> Double {
        (.pi * degrees) / 180
    }
    
}

// MARK: Enums

fileprivate enum Coordinates {
    case absolute
    case relative
}

// MARK: Class

public class SVGPath {
    public var commands: [SVGCommand] = []
    private var builder: SVGCommandBuilder = move
    private var coords: Coordinates = .absolute
    private var increment: Int = 2
    private var numbers = ""

    public init (_ string: String) {
        for char in string {
            switch char {
            case "M": use(.absolute, 2, move)
            case "m": use(.relative, 2, move)
            case "L": use(.absolute, 2, line)
            case "l": use(.relative, 2, line)
            case "V": use(.absolute, 1, lineVertical)
            case "v": use(.relative, 1, lineVertical)
            case "H": use(.absolute, 1, lineHorizontal)
            case "h": use(.relative, 1, lineHorizontal)
            case "Q": use(.absolute, 4, quadBroken)
            case "q": use(.relative, 4, quadBroken)
            case "T": use(.absolute, 2, quadSmooth)
            case "t": use(.relative, 2, quadSmooth)
            case "C": use(.absolute, 6, cubeBroken)
            case "c": use(.relative, 6, cubeBroken)
            case "S": use(.absolute, 4, cubeSmooth)
            case "s": use(.relative, 4, cubeSmooth)
            case "Z": use(.absolute, 1, close)
            case "z": use(.absolute, 1, close)
            default: numbers.append(char)
            }
        }
        finishLastCommand()
    }
    
    private func use (_ coords: Coordinates, _ increment: Int, _ builder: @escaping SVGCommandBuilder) {
        finishLastCommand()
        self.builder = builder
        self.coords = coords
        self.increment = increment
    }
    
    private func finishLastCommand () {
        for command in take(SVGPath.parseNumbers(numbers), increment: increment, coords: coords, last: commands.last, callback: builder) {
            commands.append(coords == .relative ? command.relative(to: commands.last) : command)
        }
        numbers = ""
    }
}

// MARK: Numbers

private let numberSet = CharacterSet(charactersIn: "-.0123456789eE")
private let locale = Locale(identifier: "en_US")


public extension SVGPath {
    class func parseNumbers (_ numbers: String) -> [CGFloat] {
        var all:[String] = []
        var curr = ""
        var last = ""
        
        for char in numbers.unicodeScalars {
            let next = String(char)
            if next == "-" && last != "" && last != "E" && last != "e" {
                if curr.utf16.count > 0 {
                    all.append(curr)
                }
                curr = next
            } else if numberSet.contains(UnicodeScalar(char.value)!) {
                curr += next
            } else if curr.utf16.count > 0 {
                all.append(curr)
                curr = ""
            }
            last = next
        }
        
        all.append(curr)
        
        return all.map { CGFloat(truncating: NSDecimalNumber(string: $0, locale: locale)) }
    }
}

// MARK: Commands

public struct SVGCommand {
    public var point:CGPoint
    public var control1:CGPoint
    public var control2:CGPoint
    public var type:Kind
    
    public enum Kind {
        case move
        case line
        case cubeCurve
        case quadCurve
        case close
    }
    
    public init () {
        let point = CGPoint()
        self.init(point, point, point, type: .close)
    }
    
    public init (_ x: CGFloat, _ y: CGFloat, type: Kind) {
        let point = CGPoint(x: x, y: y)
        self.init(point, point, point, type: type)
    }
    
    public init (_ cx: CGFloat, _ cy: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        let control = CGPoint(x: cx, y: cy)
        self.init(control, control, CGPoint(x: x, y: y), type: .quadCurve)
    }
    
    public init (_ cx1: CGFloat, _ cy1: CGFloat, _ cx2: CGFloat, _ cy2: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        self.init(CGPoint(x: cx1, y: cy1), CGPoint(x: cx2, y: cy2), CGPoint(x: x, y: y), type: .cubeCurve)
    }
    
    public init (_ control1: CGPoint, _ control2: CGPoint, _ point: CGPoint, type: Kind) {
        self.point = point
        self.control1 = control1
        self.control2 = control2
        self.type = type
    }
    
    fileprivate func relative (to other:SVGCommand?) -> SVGCommand {
        if let otherPoint = other?.point {
            return SVGCommand(control1 + otherPoint, control2 + otherPoint, point + otherPoint, type: type)
        }
        return self
    }
}

// MARK: CGPoint helpers

private func +(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
}

private func -(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}

// MARK: Command Builders

private typealias SVGCommandBuilder = ([CGFloat], SVGCommand?, Coordinates) -> SVGCommand

private func take (_ numbers: [CGFloat], increment: Int, coords: Coordinates, last: SVGCommand?, callback: SVGCommandBuilder) -> [SVGCommand] {
    var out: [SVGCommand] = []
    var lastCommand:SVGCommand? = last

    let count = (numbers.count / increment) * increment
    var nums:[CGFloat] = [0, 0, 0, 0, 0, 0];
    
    for i in stride(from: 0, to: count, by: increment) {
        for j in 0 ..< increment {
            nums[j] = numbers[i + j]
        }
        lastCommand = callback(nums, lastCommand, coords)
        out.append(lastCommand!)
    }
    
    return out
}

// MARK: Mm - Move

private func move (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], type: .move)
}

// MARK: Ll - Line

private func line (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], type: .line)
}

// MARK: Vv - Vertical Line

private func lineVertical (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(coords == .absolute ? last?.point.x ?? 0 : 0, numbers[0], type: .line)
}

// MARK: Hh - Horizontal Line

private func lineHorizontal (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], coords == .absolute ? last?.point.y ?? 0 : 0, type: .line)
}

// MARK: Qq - Quadratic Curve To

private func quadBroken (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], numbers[2], numbers[3])
}

// MARK: Tt - Smooth Quadratic Curve To

private func quadSmooth (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    var lastControl = last?.control1 ?? CGPoint()
    let lastPoint = last?.point ?? CGPoint()
    if (last?.type ?? .line) != .quadCurve {
        lastControl = lastPoint
    }
    var control = lastPoint - lastControl
    if coords == .absolute {
        control = control + lastPoint
    }
    return SVGCommand(control.x, control.y, numbers[0], numbers[1])
}

// MARK: Cc - Cubic Curve To

private func cubeBroken (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5])
}

// MARK: Ss - Smooth Cubic Curve To

private func cubeSmooth (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    var lastControl = last?.control2 ?? CGPoint()
    let lastPoint = last?.point ?? CGPoint()
    if (last?.type ?? .line) != .cubeCurve {
        lastControl = lastPoint
    }
    var control = lastPoint - lastControl
    if coords == .absolute {
        control = control + lastPoint
    }
    return SVGCommand(control.x, control.y, numbers[0], numbers[1], numbers[2], numbers[3])
}

// MARK: Zz - Close Path

private func close (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand()
}
