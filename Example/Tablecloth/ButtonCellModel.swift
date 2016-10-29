//
//  ButtonCellModel.swift
//  Tablecloth
//
//  Created by Erdem Turanciftci on 29/10/2016.
//  Copyright © 2016 Erdem Turançiftçi. All rights reserved.
//

import Tablecloth

class ButtonCellModel: TableViewCellModel {
    
    fileprivate let buttonTitle: String
    
    init(buttonTitle: String, cellSelection: ((Any?, IndexPath) -> Void)? = nil) {
        self.buttonTitle = buttonTitle
        super.init()
        self.cellSelection = cellSelection
    }
    
    override func cellFromTableView(_ tableView: UITableView) -> UITableViewCell? {
        return ButtonCell.cellFromTableView(tableView, buttonTitle: buttonTitle)
    }
    
    override func cellHeight() -> CGFloat? {
        return ButtonCell.cellHeight()
    }
    
    override func identifier() -> String? {
        return buttonTitle
    }
}
