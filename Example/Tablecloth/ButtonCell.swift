//
//  ButtonCell.swift
//  Tablecloth
//
//  Created by Erdem Turanciftci on 29/10/2016.
//  Copyright © 2016 Erdem Turançiftçi. All rights reserved.
//

import Tablecloth

class ButtonCell: TableViewCell {
    
    fileprivate var buttonTitleLabel: UILabel!
    
    func setButtonTitle(_ buttonTitle: String) {
        buttonTitleLabel.text = buttonTitle
    }
    
    class func cellFromTableView(
        _ tableView: UITableView,
        buttonTitle: String)
        -> TableViewCell {
            return cellFromTableView(tableView) { (cell) -> Void in
                if let cell = cell as? ButtonCell {
                    cell.setButtonTitle(buttonTitle)
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
        
        buttonTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        buttonTitleLabel.textColor = UIColor.blue
        buttonTitleLabel.textAlignment = .center
        buttonTitleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        contentView.addSubview(buttonTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
