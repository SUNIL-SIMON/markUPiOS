//
//  PLMMarkerLayersCreaterExt.swift
//  PlanMarkup
//
//  Created by SIMON on 11/03/22.
//

import Foundation
import UIKit
extension PLMMarkedLayers
{
    public func createRectMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMRectMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createRectMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMRectMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)

    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createRoundMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMRoundMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createRoundMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMRoundMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createArcsMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMArcsMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createArcsMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMArcsMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)

    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createArrowMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMArrowMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createArrowMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMArrowMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createTextMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMTextMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createTextMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMTextMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createImageMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMImageMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createImageMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMImageMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createPathMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMPathMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createPathMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMPathMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    func createHighlightMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        let v = PLMHighLightMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createHighlightMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        
        let v = PLMHighLightMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public func createRullerMarker(lineWidth:CGFloat,pt:CGPoint,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        let v = PLMRullerMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.center = pt
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    public func createRullerMarkerPaste(lineWidth:CGFloat,frameRect:CGRect,enableHolders:Bool,originalSizeParam: CGRect, markedInfos: markedInfoType, state : markerStateType)
    {
        let v = PLMRullerMarker(frame: .zero, linePointSize: lineWidth, originalSizeParam: originalSizeParam, markedInfosParam: markedInfos)
        markedViews[selectedGroupIndex].markers.append(v)
        self.addSubview(v)
        v.frame = frameRect
        v.shouldEnableHolders(enable:enableHolders)
        v.groupIndex = markedViews.count-1
        v.rowIndex = markedViews[v.groupIndex].markers.count-1
        v.state = state
        v.delegate = self
        delegate?.layerListReload()
        self.bringSubviewToFront(rotator)
    }
    
}
