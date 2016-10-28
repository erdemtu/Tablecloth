//
//  TableViewCell.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 11/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

open class TableViewCell: UITableViewCell {
    
    open var selectionColor: UIColor?
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let selectionColor = self.selectionColor else { return }

        if selected {
            self.contentView.backgroundColor = selectionColor;
        }
        else {
            self.contentView.backgroundColor = UIColor.clear;
        }
    }
    
    open override func setHighlighted(_ selected: Bool, animated: Bool) {
        super.setHighlighted(selected, animated: animated)
        
        guard let selectionColor = self.selectionColor else { return }
        
        if selected {
            self.contentView.backgroundColor = selectionColor;
        }
        else {
            self.contentView.backgroundColor = UIColor.clear;
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
    }
    
    
    open class func cellFromTableView(
        _ tableView: UITableView,
        customConfig: ((TableViewCell) -> Void)?,
        customInit: (() -> TableViewCell)?)
        -> TableViewCell {
            
            let reuseIdentifier = self.reuseIdentifier()
            var cell: TableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TableViewCell
            
            if cell == nil {
                if let customInit = customInit {
                    cell = customInit()
                }
                else {
                    cell = self.init(reuseIdentifier: reuseIdentifier)
                }
            }
            
            if let customConfig = customConfig {
                customConfig(cell!)
            }
            
            return cell!
    }
    
    open class func cellFromTableView(
        _ tableView: UITableView,
        customConfig: ((TableViewCell) -> Void)?)
        -> TableViewCell {
            return cellFromTableView(tableView, customConfig: customConfig, customInit: nil)
    }
    
    open class func cellFromTableView(
        _ tableView: UITableView)
        -> TableViewCell {
            return cellFromTableView(tableView, customConfig: nil, customInit: nil)
    }
    
    open class func reuseIdentifier() -> String {
        return self.description()
    }
    
    open class func cellWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    open class func cellHeight() -> CGFloat {
        return 44.0
    }
}

