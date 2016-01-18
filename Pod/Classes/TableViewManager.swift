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
    
    private let tableView: UITableView
    private weak var delegate: TableViewManagerDelegate?
    
    public init(tableView: UITableView, delegate: TableViewManagerDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        tableViewModel = TableViewModel()
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func updateTableViewModel() {
        if let delegate = delegate {
            tableViewModel = delegate.generateTableViewModel(self)
        }
    }
    
    public func updateTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.updateTableViewModel()
            self.tableView.reloadData()
        };
    }
    
    public func updateTableViewWithAnimation() {
        updateTableViewWithAnimationWithCompletion(nil)
    }
    
    public func updateTableViewWithAnimationWithCompletion(completion:((finished: Bool) -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) {
            
            guard let updatedTableViewModel = self.delegate?.generateTableViewModel(self) else {return}
            
            let sectionModels = self.tableViewModel.sectionModels
            let updatedSectionModels = updatedTableViewModel.sectionModels
            
            if sectionModels.count != updatedSectionModels.count {
                self.tableViewModel = updatedTableViewModel
                if sectionModels.count == 0 {
                    self.tableView.insertSections(NSIndexSet(indexesInRange: NSMakeRange(0, updatedSectionModels.count)), withRowAnimation: .Fade)
                }
                else {
                    UIView.transitionWithView(
                        self.tableView,
                        duration: 0.35,
                        options: .TransitionCrossDissolve,
                        animations: { () -> Void in
                            self.tableView.reloadData()
                        },
                        completion: completion)
                }
                return
            }
            
            var insertionIndexPaths = Array<NSIndexPath>()
            var deletionIndexPaths = Array<NSIndexPath>()
            
            for var section = 0; section < self.tableViewModel.sectionModels.count; section++ {
                let delta = self.deltaWithSectionModel(sectionModels[section], updatedSectionModel: updatedSectionModels[section], section: section)
                insertionIndexPaths.appendContentsOf(delta.0)
                deletionIndexPaths.appendContentsOf(delta.1)
            }
            
            self.tableViewModel = updatedTableViewModel
            
            CATransaction.begin()
            
            CATransaction.setCompletionBlock({ () -> Void in
                self.tableView.reloadData()
                if let completion = completion {
                    completion(finished: true)
                }
            })
            
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths(deletionIndexPaths, withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths(insertionIndexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
            CATransaction.commit()
        };
    }
    
    private func deltaWithSectionModel(sectionModel: TableViewSectionModel, updatedSectionModel: TableViewSectionModel, section: Int) -> (Array<NSIndexPath>, Array<NSIndexPath>) {
        
        let cellModels = sectionModel.cellModels
        var updatedCellModels = updatedSectionModel.cellModels
        
        var insertionIndexPaths = indexPathsWithModelCount(updatedCellModels.count, section: section)
        var deletionIndexPaths = indexPathsWithModelCount(cellModels.count, section: section)
        
        var yOffset = 0
        
        for var x = 0; x < cellModels.count; x++ {
            if yOffset >= updatedCellModels.count {
                break
            }
            for var y = yOffset; y < updatedCellModels.count; y++ {
                let cellModel = cellModels[x]
                let updatedCellModel = updatedCellModels[y]
                if cellModel.isEqualToCellModel(updatedCellModel) {
                    cellModel.updateWithContentsOfCellModel(updatedCellModel)
                    updatedCellModels[y] = cellModel
                    
                    deletionIndexPaths.removeAtIndex(x - yOffset)
                    insertionIndexPaths.removeAtIndex(y - yOffset)
                    
                    yOffset++
                    break
                }
            }
        }
        
        return (insertionIndexPaths, deletionIndexPaths)
    }
    
    private func indexPathsWithModelCount(modelCount: Int, section: Int) -> Array<NSIndexPath> {
        var indexPaths = Array<NSIndexPath>()
        for var i = 0; i < modelCount; i++ {
            indexPaths.append(NSIndexPath(forRow: i, inSection: section))
        }
        return indexPaths
    }
    
    private func cellModelAtIndexPath(indexPath: NSIndexPath) -> TableViewCellModel {
        let sectionModel = sectionModelForSection(indexPath.section)
        return sectionModel.cellModels[indexPath.row]
    }
    
    private func sectionModelForSection(section: Int) -> TableViewSectionModel {
        return tableViewModel.sectionModels[section]
    }
}

extension TableViewManager: UITableViewDataSource {
 
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewModel.sectionModels.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModelForSection(section).cellModels.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellModelAtIndexPath(indexPath).cellHeight()!
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellModelAtIndexPath(indexPath).cellFromTableView(tableView)!
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerModel = sectionModelForSection(section).footerModel else { return 0.01 }
        return footerModel.accessoryHeight()
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerModel = sectionModelForSection(section).headerModel else { return 0.01 }
        return headerModel.accessoryHeight()
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionModelForSection(section).footerModel?.accessoryView()
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionModelForSection(section).headerModel?.accessoryView()
    }
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        cellModelAtIndexPath(indexPath).selectCellModel()
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
}

public protocol TableViewManagerDelegate: class {
    
    func generateTableViewModel(tableViewManager: TableViewManager) -> TableViewModel
    
    func scrollViewDidScroll(scrollView: UIScrollView)
}

public extension TableViewManagerDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {}
}
