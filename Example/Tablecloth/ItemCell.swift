//
//  ItemCell.swift
//  Tablecloth
//
//  Created by Erdem Turanciftci on 29/10/2016.
//  Copyright © 2016 Erdem Turançiftçi. All rights reserved.
//

import Tablecloth

class ItemCell: TableViewCell {
    
    fileprivate var itemTextLabel: UILabel!
    
    func setItemText(_ itemText: String) {
        itemTextLabel.text = itemText
    }
    
    class func cellFromTableView(
        _ tableView: UITableView,
        itemText: String)
        -> TableViewCell {
            return cellFromTableView(tableView) { (cell) -> Void in
                if let cell = cell as? ItemCell {
                    cell.setItemText(itemText)
                }
            }
    }
    
    override class func cellHeight() -> CGFloat {
        return 44.0
    }
    
    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        selectionColor = UIColor.gray
        
        let width = ItemCell.cellWidth()
        let height = ItemCell.cellHeight()
        
        itemTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        itemTextLabel.textColor = UIColor.darkText
        itemTextLabel.textAlignment = .center
        itemTextLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        contentView.addSubview(itemTextLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
