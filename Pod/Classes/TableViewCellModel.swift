//
//  TableViewCellModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

public class TableViewCellModel {
    
    public var cellSelection: ((AnyObject?) -> Void)?
    
    public func identifier() -> String? {
        return nil
    }
    
    public func wrappedObject() -> AnyObject? {
        return nil
    }
    
    public func cellFromTableView(tableView: UITableView) -> UITableViewCell? {
        return nil
    }
    
    public func cellHeight() -> CGFloat? {
        return TableViewCell.cellHeight()
    }

    public func isEqualToCellModel(cellModel: TableViewCellModel) -> Bool {
        if Mirror(reflecting: self).subjectType != Mirror(reflecting: cellModel).subjectType {
            return false
        }
        if let identifier = identifier(), cellModelIdentifier = cellModel.identifier() {
            return identifier == cellModelIdentifier
        }
        return true
    }
    
    public func updateWithContentsOfCellModel(cellModel: TableViewCellModel) {
        cellSelection = cellModel.cellSelection
    }
    
    public func selectCellModel() {
        if let cellSelection = cellSelection {
            cellSelection(wrappedObject())
        }
    }
    
    public init() {}
}

