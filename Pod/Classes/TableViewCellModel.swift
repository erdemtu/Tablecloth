//
//  TableViewCellModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

open class TableViewCellModel {
    
    open var cellSelection: ((Any?, IndexPath) -> Void)?
    
    open func identifier() -> String? {
        return nil
    }
    
    open func wrappedObject() -> Any? {
        return nil
    }
    
    open func cellFromTableView(_ tableView: UITableView) -> UITableViewCell? {
        return nil
    }
    
    open func cellHeight() -> CGFloat? {
        return TableViewCell.cellHeight()
    }

    open func isEqualToCellModel(_ cellModel: TableViewCellModel) -> Bool {
        if Mirror(reflecting: self).subjectType != Mirror(reflecting: cellModel).subjectType {
            return false
        }
        if let identifier = identifier(), let cellModelIdentifier = cellModel.identifier() {
            return identifier == cellModelIdentifier
        }
        return true
    }
    
    open func updateWithContentsOfCellModel(_ cellModel: TableViewCellModel) {
        cellSelection = cellModel.cellSelection
    }
    
    open func selectCellModelWithIndexPath(_ indexPath: IndexPath) {
        if let cellSelection = cellSelection {
            cellSelection(wrappedObject(), indexPath)
        }
    }
    
    public init() {}
}

