//
//  TableViewManager.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 24/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

final public class TableViewManager: NSObject {
    
    var tableViewModel: TableViewModel
    
    fileprivate let tableView: UITableView
    fileprivate weak var delegate: TableViewManagerDelegate?
    
    public init(tableView: UITableView, delegate: TableViewManagerDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        tableViewModel = TableViewModel()
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    fileprivate func updateTableViewModel() {
        if let delegate = delegate {
            tableViewModel = delegate.generateTableViewModel(self)
        }
    }
    
    public func updateTableView() {
        DispatchQueue.main.async {
            self.updateTableViewModel()
            self.tableView.reloadData()
        };
    }
    
    public func updateTableViewWithAnimation() {
        updateTableViewWithAnimationWithCompletion(nil)
    }
    
    public func updateTableViewWithAnimationWithCompletion(_ completion:((_ finished: Bool) -> Void)?) {
        DispatchQueue.main.async {
            
            guard let updatedTableViewModel = self.delegate?.generateTableViewModel(self) else {return}
            
            let sectionModels = self.tableViewModel.sectionModels
            let updatedSectionModels = updatedTableViewModel.sectionModels
            
            if sectionModels.count != updatedSectionModels.count {
                self.tableViewModel = updatedTableViewModel
                if sectionModels.count == 0 {
                    self.tableView.insertSections(IndexSet(integersIn: NSMakeRange(0, updatedSectionModels.count).toRange()!), with: .fade)
                }
                else {
                    UIView.transition(
                        with: self.tableView,
                        duration: 0.35,
                        options: .transitionCrossDissolve,
                        animations: { () -> Void in
                            self.tableView.reloadData()
                        },
                        completion: completion)
                }
                return
            }
            
            var insertionIndexPaths = Array<IndexPath>()
            var deletionIndexPaths = Array<IndexPath>()
            
            for section in 0 ..< self.tableViewModel.sectionModels.count {
                let delta = self.deltaWithSectionModel(sectionModels[section], updatedSectionModel: updatedSectionModels[section], section: section)
                insertionIndexPaths.append(contentsOf: delta.0)
                deletionIndexPaths.append(contentsOf: delta.1)
            }
            self.tableViewModel = updatedTableViewModel
            
            CATransaction.begin()
            
            CATransaction.setCompletionBlock({ () -> Void in
                self.tableView.reloadData()
                if let completion = completion {
                    completion(true)
                }
            })
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: deletionIndexPaths, with: .fade)
            self.tableView.insertRows(at: insertionIndexPaths, with: .fade)
            self.tableView.endUpdates()
            
            CATransaction.commit()
        };
    }
    
    fileprivate func deltaWithSectionModel(_ sectionModel: TableViewSectionModel, updatedSectionModel: TableViewSectionModel, section: Int) -> (Array<IndexPath>, Array<IndexPath>) {
        
        let cellModels = sectionModel.cellModels
        var updatedCellModels = updatedSectionModel.cellModels
        
        var insertionIndexPaths = indexPathsWithModelCount(updatedCellModels.count, section: section)
        var deletionIndexPaths = indexPathsWithModelCount(cellModels.count, section: section)
        
        var yOffset = 0
        
        for x in 0 ..< cellModels.count {
            if yOffset >= updatedCellModels.count {
                break
            }
            for y in yOffset ..< updatedCellModels.count {
                let cellModel = cellModels[x]
                let updatedCellModel = updatedCellModels[y]
                if cellModel.isEqualToCellModel(updatedCellModel) {
                    cellModel.updateWithContentsOfCellModel(updatedCellModel)
                    updatedCellModels[y] = cellModel
                    
                    deletionIndexPaths.remove(at: x - yOffset)
                    insertionIndexPaths.remove(at: y - yOffset)
                    
                    yOffset += 1
                    break
                }
            }
        }
        
        return (insertionIndexPaths, deletionIndexPaths)
    }
    
    fileprivate func indexPathsWithModelCount(_ modelCount: Int, section: Int) -> Array<IndexPath> {
        var indexPaths = Array<IndexPath>()
        for i in 0 ..< modelCount {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        return indexPaths
    }
    
    fileprivate func cellModelAtIndexPath(_ indexPath: IndexPath) -> TableViewCellModel {
        let sectionModel = sectionModelForSection((indexPath as IndexPath).section)
        return sectionModel.cellModels[(indexPath as IndexPath).row]
    }
    
    fileprivate func sectionModelForSection(_ section: Int) -> TableViewSectionModel {
        return tableViewModel.sectionModels[section]
    }
}

extension TableViewManager: UITableViewDataSource {
 
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.sectionModels.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModelForSection(section).cellModels.count
    }
    
    @objc(tableView:heightForRowAtIndexPath:) public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellModelAtIndexPath(indexPath).cellHeight()!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellModelAtIndexPath(indexPath).cellFromTableView(tableView)!
    }
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellModelAtIndexPath(indexPath).selectCellModelWithIndexPath(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerModel = sectionModelForSection(section).footerModel else { return 0.01 }
        return footerModel.accessoryHeight()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerModel = sectionModelForSection(section).headerModel else { return 0.01 }
        return headerModel.accessoryHeight()
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionModelForSection(section).footerModel?.accessoryView()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionModelForSection(section).headerModel?.accessoryView()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop(scrollView)
    }
}

public protocol TableViewManagerDelegate: class {
    
    func generateTableViewModel(_ tableViewManager: TableViewManager) -> TableViewModel
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
}

public extension TableViewManagerDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {}
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {}
}
