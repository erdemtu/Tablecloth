//
//  TableViewCell.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 11/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

public class TableViewCell: UITableViewCell {
    
    public var selectionColor: UIColor?
    
    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let selectionColor = self.selectionColor else { return }

        if selected {
            self.contentView.backgroundColor = selectionColor;
        }
        else {
            self.contentView.backgroundColor = UIColor.clearColor();
        }
    }
    
    public override func setHighlighted(selected: Bool, animated: Bool) {
        super.setHighlighted(selected, animated: animated)
        
        guard let selectionColor = self.selectionColor else { return }
        
        if selected {
            self.contentView.backgroundColor = selectionColor;
        }
        else {
            self.contentView.backgroundColor = UIColor.clearColor();
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        separatorInset = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
    }
    
    
    public class func cellFromTableView(
        tableView: UITableView,
        customConfig: ((TableViewCell) -> Void)?,
        customInit: (() -> TableViewCell)?)
        -> TableViewCell {
            
            let reuseIdentifier = self.reuseIdentifier()
            var cell: TableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? TableViewCell
            
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
    
    public class func cellFromTableView(
        tableView: UITableView,
        customConfig: ((TableViewCell) -> Void)?)
        -> TableViewCell {
            return cellFromTableView(tableView, customConfig: customConfig, customInit: nil)
    }
    
    public class func cellFromTableView(
        tableView: UITableView)
        -> TableViewCell {
            return cellFromTableView(tableView, customConfig: nil, customInit: nil)
    }
    
    public class func reuseIdentifier() -> String {
        return self.description()
    }
    
    public class func cellWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    public class func cellHeight() -> CGFloat {
        return 44.0
    }
}

