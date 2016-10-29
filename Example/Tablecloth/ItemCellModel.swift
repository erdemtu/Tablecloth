//
//  ItemCellModel.swift
//  Tablecloth
//
//  Created by Erdem Turanciftci on 29/10/2016.
//  Copyright © 2016 Erdem Turançiftçi. All rights reserved.
//

import Tablecloth

class ItemCellModel: TableViewCellModel {
    
    fileprivate let item: Item
    
    init(item: Item, cellSelection: ((Any?, IndexPath) -> Void)? = nil) {
        self.item = item
        super.init()
        self.cellSelection = cellSelection
    }
    
    override func cellFromTableView(_ tableView: UITableView) -> UITableViewCell? {
        return ItemCell.cellFromTableView(tableView, itemText: item.text)
    }
    
    override func wrappedObject() -> Any? {
        return item
    }
    
    override func cellHeight() -> CGFloat? {
        return ItemCell.cellHeight()
    }
    
    override func identifier() -> String? {
        return item.identifier.description
    }
}
