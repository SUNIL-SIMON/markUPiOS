//
//  PLMSideLayerBar.swift
//  PlanMarkup
//
//  Created by puviyarasan on 20/01/22.
//


import Foundation
import UIKit

import AppearanceFramework
public enum SideBarModeType {
    case minimized
    case maximized
}
public enum colorModeType {
    case stroke
    case fill
}
public protocol PLMSheetBaseViewDelegate : AnyObject {

}
public protocol PLMPopOverBaseViewCntrlrDelegate : AnyObject {
    func popOverDismissed()
}
public class PLMPopOverBaseViewCntrlr : UIViewController
{
    public weak var delegate : PLMPopOverBaseViewCntrlrDelegate?
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (isBeingDismissed || isMovingFromParent) {
            delegate?.popOverDismissed()
        }
    }
}
public protocol PLMSideLayerBarDelegate : AnyObject {
    func changeMode()
    func getMarkersList()->[markedGroupCellType]
    func changeExpansion(indexedRow : Int,indexedSection : Int, expanded : Bool)
    func changeVisibility(indexedRow : Int,indexedSection : Int)
    func changeVisibility(groupIndex : Int, shouldHide: Bool)
    func changeVisibilityAllLayer(shouldHide : Bool)
    func changeLock(groupIndex : Int, shouldLock: Bool)
    func changeLock(indexedRow : Int,indexedSection : Int)
    func showPopOver(cntrlr : PLMPopOverBaseViewCntrlr, sourceView : UIView, size : CGSize, arrowSide : UIPopoverArrowDirection, height: Float)
    func closePopOver()
    func copyMarkers(groupIndex : Int)
    func pasteMarkers(groupIndex : Int)
    func getCopyCount(groupIndex : Int)->Int
    func deleteMarker(indexedRow : Int,indexedSection : Int)
    func copyMarkers(indexedRow: Int, indexedSection: Int)
    func pasteMarkers(indexedRow: Int, indexedSection: Int)
    func deleteMarker(groupIndex : Int)
    func showArea(indexedRow : Int,indexedSection : Int, show : Bool, type : MeasurmentsType)
    func getSelectedIndex()->(Int,Int)
    func showPublishAlert()
}


public class PLMSideLayerBar : UIView , PLMSideLayerBarDelegate{
    
    
    
    
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var tableView = PLMTableView()
    var sideButton = UIButton()
    var sideBarMode = SideBarModeType.minimized
    
    public weak var delegate : PLMSideLayerBarDelegate?
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.addSubview(sideButton)
        let img = UIImage(named: "layer")
        let tintedImg = img?.withRenderingMode(.alwaysTemplate)
        sideButton.setBackgroundImage(tintedImg, for: .normal)
        sideButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        sideButton.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        sideButton.contentMode = .center
        
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        
        tableView.layer.cornerRadius = 10
        self.changeMode()
        
    }
    
    @objc public func changeMode(){
        delegate?.changeMode()
 
    }
    
    public func setMode(sideBarModeParam : SideBarModeType)
    {
        sideBarMode = sideBarModeParam
        if sideBarMode == .minimized
        {
            sideButton.alpha = 1
            tableView.alpha = 0
        }
        else{
            sideButton.alpha = 0
            tableView.alpha = 1
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getMarkersList()->[markedGroupCellType]
    {
        return delegate?.getMarkersList() ?? []
    }
    public func changeVisibility(indexedRow : Int,indexedSection : Int)
    {
      delegate?.changeVisibility(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func changeVisibility(groupIndex : Int, shouldHide: Bool)
    {
        delegate?.changeVisibility(groupIndex: groupIndex, shouldHide : shouldHide)
    }
    public func changeVisibilityAllLayer(shouldHide: Bool) {
        delegate?.changeVisibilityAllLayer(shouldHide: shouldHide)
    }
    public func changeLock(indexedRow : Int,indexedSection : Int)
    {
      delegate?.changeLock(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func changeLock(groupIndex : Int, shouldLock: Bool)
    {
        delegate?.changeLock(groupIndex: groupIndex, shouldLock : shouldLock)
    }
    public override func layoutSubviews() {
        sideButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        tableView.frame = CGRect(x: 0, y:0, width: self.frame.size.width, height: self.frame.size.height)
    }
    public func changeExpansion(indexedRow : Int,indexedSection : Int, expanded : Bool)
    {
        delegate?.changeExpansion(indexedRow: indexedRow, indexedSection: indexedSection, expanded: expanded)
    }
    public func showPopOver(cntrlr : PLMPopOverBaseViewCntrlr, sourceView : UIView, size : CGSize, arrowSide : UIPopoverArrowDirection, height: Float)
    {
        delegate?.showPopOver(cntrlr: cntrlr, sourceView: sourceView, size : size, arrowSide : arrowSide, height: height)
    }
    public func copyMarkers(groupIndex : Int)
    {
        delegate?.copyMarkers(groupIndex: groupIndex)
    }
    public func pasteMarkers(groupIndex : Int)
    {
        delegate?.pasteMarkers(groupIndex: groupIndex)
    }
    public func getCopyCount(groupIndex : Int)->Int
    {
        return delegate?.getCopyCount(groupIndex: groupIndex) ?? 0
    }
    public func closePopOver()
    {
        delegate?.closePopOver()
    }
    public func deleteMarker(indexedRow : Int,indexedSection : Int)
    {
        delegate?.deleteMarker(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func copyMarkers(indexedRow: Int, indexedSection: Int) {
        delegate?.copyMarkers(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    
    public func pasteMarkers(indexedRow: Int, indexedSection: Int) {
        delegate?.pasteMarkers(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func deleteMarker(groupIndex : Int)
    {
        delegate?.deleteMarker(groupIndex: groupIndex)
    }
    public func showArea(indexedRow : Int,indexedSection : Int, show : Bool, type : MeasurmentsType) {
        delegate?.showArea(indexedRow: indexedRow, indexedSection: indexedSection, show : show, type: type)
    }
    public func getSelectedIndex()->(Int,Int)
    {
        return delegate?.getSelectedIndex() ?? (-1,0)
    }
    public func showPublishAlert() {
        delegate?.showPublishAlert()
    }
}
public class PLMTableView : UIView, UITableViewDelegate,UITableViewDataSource,PLMTableViewCustomCellDelegate {
   
    
  
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    public weak var delegate : PLMSideLayerBarDelegate?
    
    let sideBarTableview = UITableView()//(frame: .zero, style: .grouped)
    
    var markedViews = [markedGroupCellType]()
    
    
    var topView1Labelname = UILabel()
    var minimizeButton = UIButton()
    var publishButton = UIButton()
    var dropDownView = UIButton()
    var line1 = UIView()
    var topView1 = UIView()
    
    var topView2Labelname = UILabel()
//    var lockButton = UIButton()
    var eyeButton = UIButton()
    var plusButton = UIButton()
    var line2 = UIView()
    var topView2 = UIView()
    
    @objc var allHidden = false
    public init(){
        super.init(frame: .zero)
        
        sideBarTableview.delegate = self
        sideBarTableview.dataSource = self
        sideBarTableview.layer.cornerRadius = 10
//        sideBarTableview.backgroundColor = TCAppearance.shared.theme.color.white_blackUIColor
        sideBarTableview.backgroundColor =  UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        self.sideBarTableview.tableFooterView = UIView()
        self.addSubview(sideBarTableview)
        
        self.addSubview(topView1)
        topView1.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        topView1.layer.cornerRadius = 10
        
        topView1.addSubview(line1)
        line1.backgroundColor = UIColor(TCAppearance.shared.theme.change.seperatorLineColor)
        topView1.addSubview(topView1Labelname)
        topView1Labelname.text = "Layer Editor"
        topView1Labelname.textColor = UIColor(TCAppearance.shared.theme.change.headingColor)
        topView1Labelname.font = UIFont.systemFont(ofSize: 18)
        
        if iPad{
            topView1.addSubview(minimizeButton)
            minimizeButton.setImage(UIImage(systemName: "minus"), for: .normal)
            minimizeButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
            minimizeButton.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
            minimizeButton.layer.cornerRadius = 15
            minimizeButton.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewBackgroundColor)
        }else{
            topView1.addSubview(publishButton)
//            publishButton.setImage(UIImage(named: "Publish"), for: .normal)
            publishButton.setTitle("Publish", for: .normal)
            publishButton.layer.borderColor = UIColor(TCAppearance.shared.theme.change.tableViewBackgroundColor).cgColor
            publishButton.layer.borderWidth = 1
            publishButton.layer.cornerRadius = 8
            publishButton.backgroundColor = UIColor(TCAppearance.shared.theme.change.actionButtonFillColor)
//            minimizeButton.tintColor = .white
            publishButton.setTitleColor(UIColor(TCAppearance.shared.theme.change.tableViewCellColor), for: .normal)
            publishButton.addTarget(self, action: #selector(showPublishAlert), for: .touchUpInside)
            
            self.addSubview(dropDownView)
            //dropDownView.setImage(UIImage(named: "rectangle"), for: .normal)
            dropDownView.setImage(UIImage(systemName: "minus"), for: .normal)
            dropDownView.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor) //TCAppearance.shared.theme.color.black_whiteUIColor
            dropDownView.addTarget(self, action: #selector(dropDownClicked), for: .touchUpInside)
//            publishButton.setImage(UIImage(named: "Publish"), for: .normal)
////            minimizeButton.tintColor = .white
//            publishButton.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        }
        
        self.addSubview(topView2)
        topView2.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        
        topView2.addSubview(topView2Labelname)
        topView2Labelname.text = "Markeups"
        topView2Labelname.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        topView2Labelname.font = UIFont.systemFont(ofSize: 13)
        
        topView2.addSubview(eyeButton)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.addTarget(self, action: #selector(setAllHiden), for: .touchUpInside)
        eyeButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
//        topView2.addSubview(lockButton)
//        lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
//        lockButton.addTarget(self, action: #selector(setAllHiden), for: .touchUpInside)
//        lockButton.tintColor = .black
        
        topView2.addSubview(line2)
        line2.backgroundColor = UIColor(TCAppearance.shared.theme.change.seperatorLineColor)
        
        topView2.addSubview(plusButton)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        plusButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        plusButton.isUserInteractionEnabled = false
        plusButton.alpha = 0.3
    }
    @objc func changeMode(){
        delegate?.changeMode()
    }
    @objc func showPublishAlert(){
        delegate?.showPublishAlert()
    }
    @objc func dropDownClicked(){
        
    }
    public func reloadTableData()
    {
        setChkVisibility()
        setChkLock()
        sideBarTableview.reloadData()
    }
    func setChkVisibility()
    {
        var a = delegate?.getMarkersList() ?? []
        var found2 = false
        for i in 0..<a.count{
            var found = false
            for marker in a[i].markers{
                if marker.visible
                {
                    found2 = true
                    found = true
                    break
                }
            }
            if !found
            {
                a[i].allHidden = true
            }
            else{
                a[i].allHidden = false
            }
        }
        markedViews.removeAll()
        markedViews.append(contentsOf: a)
        if !found2
        {
            allHidden = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else{
            allHidden = false
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }

        
        
    }
    func setChkLock()
    {
        let a = delegate?.getMarkersList() ?? []
        for i in 0..<a.count{
            var found = false
            for marker in a[i].markers{
                if !marker.markedInfos.isLocked
                {
                    found = true
                    break
                }
            }
            if !found
            {
                markedViews[i].allLocked = true
            }
            else{
                markedViews[i].allLocked = false
            }
        }
        
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if markedViews[section].expanded == true
        {
            return markedViews[section].markers.count + 1
        }
        return 1
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return markedViews.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "defaultSection") as! PLMSideBarTableViewSectionCell?
            if(cell == nil)
            {
                cell = PLMSideBarTableViewSectionCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "defaultSection")
            }
            cell?.labelname.text = markedViews[indexPath.section].title
            if markedViews[indexPath.section].expanded
            {
              cell?.expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            }
            else{
              cell?.expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
            if markedViews[indexPath.section].allHidden || allHidden
            {
              cell?.eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            else{
              cell?.eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            }
            cell?.indexedSection = indexPath.section
            cell?.delegate = self
            cell?.visible = markedViews[indexPath.section].allHidden
            cell?.locked = markedViews[indexPath.section].allLocked
            cell?.state = markedViews[indexPath.section].state
            let clr : UIColor = markedViews[indexPath.section].typeStr.contains("rfi") ? .red : markedViews[indexPath.section].typeStr.contains("schedule") ? .yellow : markedViews[indexPath.section].typeStr.contains("punchlist") ? .green : .clear
            cell?.typeView.backgroundColor = clr
            return cell!
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "defaultRow") as! PLMSideBarTableViewRowCell?
            if(cell == nil)
            {
                cell = PLMSideBarTableViewRowCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "defaultRow")
            }
            
            
            
            cell?.index = indexPath.row - 1
            cell?.delegate = self
            if !markedViews[indexPath.section].markers[indexPath.row - 1].visible || allHidden
            {
              cell?.eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            else{
              cell?.eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            }
            if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.isLocked
            {
              cell?.lockButton.setImage(UIImage(systemName: "lock"), for: .normal)
            }
            else{
              cell?.lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
            }
            if markedViews[indexPath.section].state == .PUBLISHED
            {
                cell?.lockButton.isUserInteractionEnabled = false
                cell?.lockButton.alpha = 0.3
            }
            else{
                cell?.lockButton.isUserInteractionEnabled = true
                cell?.lockButton.alpha = 1
            }
            cell?.markerType.layer.borderWidth = 1
            cell?.markerType.image = UIImage().withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
            cell?.markerType.backgroundColor = .clear
            if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .ROUND
            {
                cell?.markerType.layer.cornerRadius = 12.5
                cell?.labelname.text = "Round/Ellipse"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .RECT
            {
                cell?.markerType.layer.cornerRadius = 0
                cell?.labelname.text = "Rect"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .PATH
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.image = UIImage(systemName: "scribble")?.withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
                cell?.labelname.text = "Draw"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .HIGHLIGHTER
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 0.3)
                cell?.labelname.text = "Highlighter"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .ARROW
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.image = UIImage(systemName: "arrow.up.right")?.withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
                cell?.labelname.text = "Arrow"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .TEXT
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.image = UIImage(named: "text")?.withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
                cell?.labelname.text = "Text"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .IMAGE
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.image = UIImage(systemName: "photo")?.withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
                cell?.labelname.text = "Image"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .RULLER
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.image = UIImage(named: "line")?.withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
                cell?.labelname.text = "Scale"
            }
            else if markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type == .ARCS
            {
                cell?.markerType.layer.borderWidth = 0
                cell?.markerType.layer.cornerRadius = 0
                cell?.markerType.image = UIImage(named: "couldshaper")?.withTintColor(UIColor(TCAppearance.shared.theme.change.textLabelColor))
                cell?.labelname.text = "Cloud"
            }
            cell?.mkdrawType = markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.type
            cell?.layoutSubviews()
            
            cell?.markerType.layer.borderColor = UIColor(TCAppearance.shared.theme.change.textLabelColor).cgColor
            cell?.indexedRow = indexPath.row
            cell?.indexedSection = indexPath.section
            cell?.areaShown = markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.measurmnetsVisible.areaShown
            cell?.lengthShown = markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.measurmnetsVisible.lengthShown
            cell?.breadthShown = markedViews[indexPath.section].markers[indexPath.row - 1].markedInfos.measurmnetsVisible.breadthShown
            cell?.state = markedViews[indexPath.section].state
            
            let (ix,gix) = delegate?.getSelectedIndex() ?? (-1,0)
            if ix + 1 == indexPath.row && gix == indexPath.section
            {
                cell?.baseView.backgroundColor = UIColor(TCAppearance.shared.theme.change.status_completed)
            }
            else{
                cell?.baseView.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewBackgroundColor)
            }
            
            return cell!
        }
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if markedViews[indexPath.section].expanded == true {
                markedViews[indexPath.section].expanded = false
                delegate?.changeExpansion(indexedRow: indexPath.row-1, indexedSection: indexPath.section, expanded : false)
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                markedViews[indexPath.section].expanded = true
                delegate?.changeExpansion(indexedRow: indexPath.row-1, indexedSection: indexPath.section, expanded : true)
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return iPad ? 40 : 50
    }
    public func changeVisibility(indexedRow : Int,indexedSection : Int)
    {
        delegate?.changeVisibility(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func changeVisibility(groupIndex : Int, shouldHide: Bool)
    {
        delegate?.changeVisibility(groupIndex: groupIndex, shouldHide:shouldHide)
    }
    public func changeLock(indexedRow : Int,indexedSection : Int)
    {
        delegate?.changeLock(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func changeLock(groupIndex : Int, shouldLock: Bool)
    {
        delegate?.changeLock(groupIndex: groupIndex, shouldLock:shouldLock)
    }
    @objc public func plusAction()
    {
        PLMPresenter.shared.sheetDataSource.showsendtextView = true
    }
    public func showPopOver(cntrlr : PLMPopOverBaseViewCntrlr, sourceView : UIView, size : CGSize, arrowSide : UIPopoverArrowDirection, height: Float)
    {
        delegate?.showPopOver(cntrlr: cntrlr, sourceView: sourceView, size : size, arrowSide : arrowSide, height: height)
    }
    @objc public func setAllHiden()
    {
        if allHidden
        {
            allHidden = false
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            delegate?.changeVisibilityAllLayer(shouldHide: allHidden)
        }
        else{
            allHidden = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            delegate?.changeVisibilityAllLayer(shouldHide: allHidden)
        }
    }
    public func copyMarkers(groupIndex : Int)
    {
        delegate?.copyMarkers(groupIndex: groupIndex)
    }
    public func pasteMarkers(groupIndex : Int)
    {
        delegate?.pasteMarkers(groupIndex: groupIndex)
    }
    public func getCopyCount(groupIndex : Int)->Int
    {
        return delegate?.getCopyCount(groupIndex: groupIndex) ?? 0
    }
    public func deleteMarker(indexedRow : Int,indexedSection : Int)
    {
        delegate?.deleteMarker(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func copyMarkers(indexedRow: Int, indexedSection: Int) {
        delegate?.copyMarkers(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    
    public func pasteMarkers(indexedRow: Int, indexedSection: Int) {
        delegate?.pasteMarkers(indexedRow: indexedRow, indexedSection: indexedSection)
    }
    public func deleteMarker(groupIndex : Int)
    {
        delegate?.deleteMarker(groupIndex: groupIndex)
    }
    public func closePopOver()
    {
        delegate?.closePopOver()
    }
    public func showArea(indexedRow : Int,indexedSection : Int, show : Bool, type : MeasurmentsType)
    {
        delegate?.showArea(indexedRow: indexedRow, indexedSection: indexedSection, show : show, type: type)
    }
    public override func layoutSubviews() {
        topView1.frame = CGRect(x: 0 , y: 0, width: self.frame.size.width, height: 45)
        if iPad{
            minimizeButton.frame = CGRect(x: self.frame.size.width-40 , y: self.iPad ? 10 : 20, width: 30, height: 30)
        }else{
            publishButton.frame = CGRect(x: self.frame.size.width-90 , y: 10 , width: 80, height: 30)
            dropDownView.frame = CGRect(x: (self.frame.size.width/2)-20, y: 4, width: 40, height: 4)
        }
        topView1Labelname.frame = CGRect(x: 10 , y: 10, width: self.frame.size.width-90, height: 30)
        line1.frame = CGRect(x: 0 , y: 44.5, width: self.frame.size.width, height: 0.5)
        
        topView2.frame = CGRect(x: 0 , y: self.iPad ? 45 : 55, width: self.frame.size.width, height: 30)
        topView2Labelname.frame = CGRect(x: 10 , y: self.iPad ? 0 : 10, width: self.frame.size.width-90, height: 30)
//        lockButton.frame = CGRect(x: self.frame.size.width-120 , y: 0, width: 30, height: 30)
        eyeButton.frame = CGRect(x: self.frame.size.width-80 , y: self.iPad ? 0 : 10, width: 30, height: 30)
        line2.frame = CGRect(x: 0 , y: self.iPad ? 34.5 : 44.5, width: self.frame.size.width, height: 0.5)
        plusButton.frame = CGRect(x: self.frame.size.width-40 , y: self.iPad ? 0 : 10, width: 30, height: 30)
        sideBarTableview.frame = CGRect(x: 0 , y: self.iPad ? 75 : 95, width: self.frame.size.width, height: self.frame.size.height - 75)
    }
    
}
public protocol PLMTableViewCustomCellDelegate : AnyObject {
    func changeVisibility(indexedRow : Int,indexedSection : Int)
    func changeVisibility(groupIndex : Int, shouldHide: Bool)
    func changeLock(groupIndex : Int, shouldLock: Bool)
    func changeLock(indexedRow : Int,indexedSection : Int)
    func showPopOver(cntrlr : PLMPopOverBaseViewCntrlr, sourceView : UIView, size : CGSize, arrowSide : UIPopoverArrowDirection, height: Float)
    func copyMarkers(groupIndex : Int)
    func pasteMarkers(groupIndex : Int)
    func getCopyCount(groupIndex : Int)->Int
    func closePopOver()
    func deleteMarker(indexedRow : Int,indexedSection : Int)
    func copyMarkers(indexedRow : Int,indexedSection : Int)
    func pasteMarkers(indexedRow : Int,indexedSection : Int)
    func deleteMarker(groupIndex : Int)
    func showArea(indexedRow : Int,indexedSection : Int, show : Bool, type : MeasurmentsType)
}
public class PLMSideBarTableViewSectionCell : UITableViewCell {
    public weak var delegate : PLMTableViewCustomCellDelegate?
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var typeView = UIView()
    var eyeButton = UIButton()
    var moreOptions = UIButton()
    var expandButton = UIButton()
    var labelname = UILabel()
    var baseView = UIView()
    var line2 = UIView()
    var indexedSection = -1
    var visible = false
    var locked = false
    var state = markerStateType.PUBLISHED
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
               super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseView.backgroundColor = UIColor(TCAppearance.shared.theme.change.tableViewCellColor)
        contentView.addSubview(baseView)
        baseView.addSubview(typeView)
        typeView.backgroundColor = .red
        baseView.addSubview(labelname)
        baseView.addSubview(eyeButton)
        baseView.addSubview(moreOptions)
        baseView.addSubview(expandButton)
        contentView.addSubview(line2)
        line2.backgroundColor = UIColor(TCAppearance.shared.theme.change.seperatorLineColor)
        
//        lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        let img = UIImage(named: "ellipsis.vertical")
        let renderedImg = img?.withRenderingMode(.alwaysTemplate)
        moreOptions.setImage(renderedImg, for: .normal)
        moreOptions.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        expandButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        eyeButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
//        expandButton.backgroundColor = .yellow
//        moreOptions.backgroundColor = .yellow
        labelname.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        labelname.font = UIFont.systemFont(ofSize: 13)
        
        moreOptions.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        
        eyeButton.addTarget(self, action: #selector(changeVisibility), for: .touchUpInside)
        expandButton.isUserInteractionEnabled = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public  override func layoutSubviews() {
        baseView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        typeView.frame =  CGRect(x: 0, y: 5, width: 5, height: self.frame.size.height - 5)
        moreOptions.frame = CGRect(x: self.frame.size.width - 30, y: iPad ? 7 : 12, width: 25, height: 25)
//        lockButton.frame = CGRect(x: self.frame.size.width - 90, y: 7, width: 25, height: 25)
        eyeButton.frame = CGRect(x: self.frame.size.width - 60, y: iPad ? 7 : 12, width: 25, height: 25)
        labelname.frame = CGRect(x: 50, y: 0, width: self.frame.size.width - 90, height: self.frame.size.height)
        expandButton.frame = CGRect(x: 10, y: iPad ? 10 : 15, width: 25, height: 25)
        line2.frame = CGRect(x: 0, y: baseView.frame.size.height - 0.5, width: baseView.frame.size.width, height: 0.5)
    }
    @objc public func changeVisibility()
    {
        delegate?.changeVisibility(groupIndex: indexedSection, shouldHide: !visible)
    }
    @objc public func moreAction()
    {
        let cntrlr = PLMPopOverBaseViewCntrlr()
       // cntrlr.view.backgroundColor = iPad ? .white : .clear
        cntrlr.view.backgroundColor = iPad ? .clear : .clear
        
        let popSize = CGSize(width: self.iPad ? 160 : cntrlr.view.frame.width*0.9, height: 150)
        let paste = UIButton()
        paste.setTitle("Paste", for: .normal)
        paste.setTitleColor(TCAppearance.shared.theme.change.textActionButtonTextUIColor, for: .normal)
        paste.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        paste.addTarget(self, action: #selector(pasteAction), for: .touchUpInside)
        paste.frame = CGRect(x: 0, y: 5, width: popSize.width, height: 30)
                
        let t = delegate?.getCopyCount(groupIndex: indexedSection) ?? 0
        if t <= 0 || state == markerStateType.PUBLISHED{
            paste.isUserInteractionEnabled = false
            paste.alpha = 0.3
        }
        
        let copy = UIButton()
        copy.setTitle("Copy", for: .normal)
        copy.setTitleColor(TCAppearance.shared.theme.change.textActionButtonTextUIColor, for: .normal)
        copy.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        copy.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        copy.frame = CGRect(x: 0, y: 35, width: popSize.width, height: 30)
        
        let lockButton = UILabel()
        lockButton.text = "Lock"
        lockButton.textColor = TCAppearance.shared.theme.change.textActionButtonTextUIColor
        lockButton.font = UIFont.systemFont(ofSize: 13)
        lockButton.frame = CGRect(x: 10, y: 75, width: (popSize.width/2) - 10, height: 30)
        if state == markerStateType.PUBLISHED{
            lockButton.isUserInteractionEnabled = false
            lockButton.alpha = 0.3
        }

        
        let lockSwitch = UISwitch()
        lockSwitch.addTarget(self, action: #selector(lockSwitchDidChange(_:)), for: .valueChanged)
        lockSwitch.setOn(locked, animated: true)
        lockSwitch.frame = CGRect(x:(popSize.width) - 55, y: 70, width: 30, height: 30)
        if state == markerStateType.PUBLISHED{
            lockSwitch.isUserInteractionEnabled = false
            lockSwitch.alpha = 0.3
        }
        
        let delete = UIButton()
        delete.setTitle("Delete", for: .normal)
        delete.setTitleColor(.red, for: .normal)
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        delete.frame = CGRect(x: 0, y: 110, width: popSize.width, height: 30)
        delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        if state == markerStateType.PUBLISHED{
            delete.isUserInteractionEnabled = false
            delete.alpha = 0.3
        }
        
        cntrlr.view.addSubview(paste)
        cntrlr.view.addSubview(copy)
        cntrlr.view.addSubview(lockButton)
        cntrlr.view.addSubview(lockSwitch)
        cntrlr.view.addSubview(delete)
        
        
        
        showPopOver(cntrlr: cntrlr, sourceView: moreOptions, size: popSize, arrowSide : .right, height: Float(popSize.height))
    }
    @objc public func copyAction()
    {
        delegate?.copyMarkers(groupIndex: indexedSection)
        delegate?.closePopOver()
    }
    @objc public func pasteAction()
    {
        delegate?.pasteMarkers(groupIndex: indexedSection)
        delegate?.closePopOver()
    }
    @objc public func deleteAction()
    {
        delegate?.deleteMarker(groupIndex: indexedSection)
        delegate?.closePopOver()
    }
    public func showPopOver(cntrlr : PLMPopOverBaseViewCntrlr, sourceView : UIView, size : CGSize, arrowSide : UIPopoverArrowDirection, height: Float)
    {
        delegate?.showPopOver(cntrlr: cntrlr, sourceView: sourceView, size : size, arrowSide: arrowSide, height: height)
    }
    @objc public func lockSwitchDidChange(_ sender: UISwitch) {
        delegate?.changeLock(groupIndex: indexedSection, shouldLock: !locked)
        delegate?.closePopOver()
    }
}
public class PLMSideBarTableViewRowCell : UITableViewCell {
    
    public var iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    var lockButton = UIButton()
    var eyeButton = UIButton()
    var moreOptions = UIButton()
    var labelname = UILabel()
    var markerType = UIImageView()
    var baseView = UIView()
    var line = UIView()
    var mkdrawType = PLMShapeType.unknown
    var index = 0
    var indexedRow = -1
    var indexedSection = -1
    var areaShown = false
    var lengthShown = false
    var breadthShown = false
    var state = markerStateType.PUBLISHED
    public weak var delegate : PLMTableViewCustomCellDelegate?
    
        
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
               super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(baseView)
        baseView.addSubview(labelname)
        baseView.addSubview(lockButton)
        baseView.addSubview(eyeButton)
        baseView.addSubview(moreOptions)
        baseView.addSubview(markerType)
        contentView.addSubview(line)
        line.backgroundColor = UIColor(TCAppearance.shared.theme.change.seperatorLineColor)
        labelname.textColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        labelname.font = UIFont.systemFont(ofSize: 13)
        
       // markerType.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
        lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        lockButton.addTarget(self, action: #selector(changeLock), for: .touchUpInside)
        lockButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
        eyeButton.addTarget(self, action: #selector(changeVisibility), for: .touchUpInside)
        eyeButton.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        
        moreOptions.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreOptions.tintColor = UIColor(TCAppearance.shared.theme.change.textLabelColor)
        moreOptions.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        
        
        
       
//        self.baseView.backgroundColor = .green
//        baseView.layer.cornerRadius = 10
        
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        baseView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        if mkdrawType == .HIGHLIGHTER{
            markerType.frame = CGRect(x: 10, y: iPad ? 7 : 14, width: baseView.frame.size.width - 110, height: 25)
            labelname.frame = CGRect(x: 22, y: 0, width: baseView.frame.size.width - 90, height: baseView.frame.size.height)
        }
        else{
            markerType.frame = CGRect(x: 20, y: iPad ? 7 : 14, width: 25, height: 25)
            labelname.frame = CGRect(x: 60, y: 0, width: baseView.frame.size.width - 90, height: baseView.frame.size.height)
        }
        lockButton.frame = CGRect(x: baseView.frame.size.width - 90, y: iPad ? 7 : 14, width: 25, height: 25)
        eyeButton.frame = CGRect(x: baseView.frame.size.width - 60, y: iPad ? 7 : 14, width: 25, height: 25)
        moreOptions.frame = CGRect(x: baseView.frame.size.width - 30, y: iPad ? 7 : 14, width: 25, height: 25)
        line.frame = CGRect(x: 0, y: baseView.frame.size.height - 0.5, width: baseView.frame.size.width, height: 0.5)
    }
    @objc public func moreAction()
    {
        let cntrlr = PLMPopOverBaseViewCntrlr()
        cntrlr.view.backgroundColor = self.iPad ? .clear : .clear
        
        
        var popSize = CGSize(width:100 , height: 40)
        if mkdrawType == .RECT || mkdrawType == .ROUND{
            popSize = CGSize(width: self.iPad ? 160 : cntrlr.view.frame.size.width*0.9 , height: 215)
            
            let paste = UIButton()
            paste.setTitle("Paste", for: .normal)
            paste.setTitleColor(TCAppearance.shared.theme.change.textActionButtonTextUIColor, for: .normal)
            paste.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//            paste.addTarget(self, action: #selector(pasteAction), for: .touchUpInside)
            paste.frame = CGRect(x: 0, y: 5, width: popSize.width, height: 30)
                    
            let t = delegate?.getCopyCount(groupIndex: indexedSection) ?? 0
            if t <= 0 || state == markerStateType.PUBLISHED{
                paste.isUserInteractionEnabled = false
                paste.alpha = 0.3
            }
            
            let copy = UIButton()
            copy.setTitle("Copy", for: .normal)
            copy.setTitleColor(TCAppearance.shared.theme.change.textActionButtonTextUIColor, for: .normal)
            copy.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//            copy.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
            copy.frame = CGRect(x: 0, y: 35, width: popSize.width, height: 30)
            
            let area = UILabel()
            area.text = "Area"
            area.textColor = TCAppearance.shared.theme.change.textActionButtonTextUIColor
            area.font = UIFont.systemFont(ofSize: 13)
            area.frame = CGRect(x: 10, y: 70, width: (popSize.width/2) - 10, height: 30)
            
            let areaSwitch = UISwitch()
            areaSwitch.addTarget(self, action: #selector(areaSwitchDidChange(_:)), for: .valueChanged)
            areaSwitch.setOn(areaShown, animated: true)
            areaSwitch.frame = CGRect(x: (popSize.width) - 55, y: 70, width: 30, height: 30)
            
            let length = UILabel()
            length.text = mkdrawType == .ROUND ? "Hor radius" : "Length"
            length.textColor = TCAppearance.shared.theme.change.textActionButtonTextUIColor
            length.font = UIFont.systemFont(ofSize: 13)
            length.frame = CGRect(x: 10, y: 105, width: (popSize.width/2) - 10, height: 30)
            
            let lengthSwitch = UISwitch()
            lengthSwitch.addTarget(self, action: #selector(lengthSwitchDidChange(_:)), for: .valueChanged)
            lengthSwitch.setOn(lengthShown, animated: true)
            lengthSwitch.frame = CGRect(x:(popSize.width) - 55, y: 105, width: 30, height: 30)
            
            let breadth = UILabel()
            breadth.text = mkdrawType == .ROUND ? "Vert radius" : "Breadth"
            breadth.textColor = TCAppearance.shared.theme.change.textActionButtonTextUIColor
            breadth.font = UIFont.systemFont(ofSize: 13)
            breadth.frame = CGRect(x: 10, y: 140, width: (popSize.width/2) - 10, height: 30)
            
            let breadthSwitch = UISwitch()
            breadthSwitch.addTarget(self, action: #selector(breadthSwitchDidChange(_:)), for: .valueChanged)
            breadthSwitch.setOn(breadthShown, animated: true)
            breadthSwitch.frame = CGRect(x: (popSize.width) - 55, y: 140, width: 30, height: 30)
            
            let delete = UIButton()
            delete.setTitle("Delete", for: .normal)
            delete.setTitleColor(.red, for: .normal)
            delete.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            delete.titleLabel?.textAlignment = .left
            delete.frame = CGRect(x: 0, y: 175, width: popSize.width, height: 30)
            delete.addTarget(self, action: #selector(deleteMarker), for: .touchUpInside)
            if state == markerStateType.PUBLISHED{
                delete.isUserInteractionEnabled = false
                delete.alpha = 0.3
            }
            
            cntrlr.view.addSubview(paste)
            cntrlr.view.addSubview(copy)
            cntrlr.view.addSubview(area)
            cntrlr.view.addSubview(areaSwitch)
            cntrlr.view.addSubview(length)
            cntrlr.view.addSubview(lengthSwitch)
            cntrlr.view.addSubview(breadth)
            cntrlr.view.addSubview(breadthSwitch)
            cntrlr.view.addSubview(delete)
        }
        else{
            popSize = CGSize(width:self.iPad ? 100 : cntrlr.view.frame.size.width*0.9 , height: 40)
            let delete = UIButton()
            delete.setTitle("Delete", for: .normal)
            delete.setTitleColor(.red, for: .normal)
            delete.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            delete.titleLabel?.textAlignment = .left
            delete.frame = CGRect(x: 0, y: 5, width: popSize.width, height: 30)
            delete.addTarget(self, action: #selector(deleteMarker), for: .touchUpInside)
            cntrlr.view.addSubview(delete)
            if state == markerStateType.PUBLISHED{
                delete.isUserInteractionEnabled = false
                delete.alpha = 0.3
            }
        }
        delegate?.showPopOver(cntrlr: cntrlr, sourceView: moreOptions, size: popSize, arrowSide : .right, height: Float(popSize.height))
    }
    @objc public func changeVisibility()
    {
        delegate?.changeVisibility(indexedRow: indexedRow - 1, indexedSection: indexedSection)
    }
    @objc public func changeLock()
    {
        delegate?.changeLock(indexedRow: indexedRow - 1, indexedSection: indexedSection)
    }
    @objc public func deleteMarker()
    {
        delegate?.deleteMarker(indexedRow: indexedRow - 1, indexedSection: indexedSection)
        delegate?.closePopOver()
    }
    @objc public func copyAction()
    {
        delegate?.copyMarkers(indexedRow: indexedRow - 1, indexedSection: indexedSection)
        delegate?.closePopOver()
    }
    @objc public func pasteAction()
    {
        delegate?.pasteMarkers(indexedRow: indexedRow - 1, indexedSection: indexedSection)
        delegate?.closePopOver()
    }
    @objc public func areaSwitchDidChange(_ sender: UISwitch) {
        delegate?.showArea(indexedRow: indexedRow - 1, indexedSection: indexedSection, show : !areaShown, type: .area)
        delegate?.closePopOver()
    }
    @objc public func lengthSwitchDidChange(_ sender: UISwitch) {
        delegate?.showArea(indexedRow: indexedRow - 1, indexedSection: indexedSection, show : !lengthShown, type: .length)
        delegate?.closePopOver()
    }
    @objc public func breadthSwitchDidChange(_ sender: UISwitch) {
        delegate?.showArea(indexedRow: indexedRow - 1, indexedSection: indexedSection, show : !breadthShown, type: .breadth)
        delegate?.closePopOver()
    }
}

public struct PLMTableViewDatasource {
    
    var lblName : String
    var eyeImage : String
    var trashImage : String

}

class CustomAlertController: UIAlertController{
    let custView = UIView()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.addSubview(custView)
        custView.backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        
    }
}
