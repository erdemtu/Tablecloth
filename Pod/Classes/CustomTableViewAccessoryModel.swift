//
//  CustomTableViewAccessoryModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

open class CustomTableViewAccessoryModel: TableViewAccessoryModel {
 
    var height: CGFloat
    var viewSetup: ((_ accessoryHeight: CGFloat) -> UIView)
    
    open func accessoryHeight() -> CGFloat {
        return height
    }
    
    open func accessoryView() -> UIView {
        return viewSetup(height)
    }
    
    public init(height: CGFloat, viewSetup: @escaping ((_ accessoryHeight: CGFloat) -> UIView)) {
        self.height = height
        self.viewSetup = viewSetup
    }
}
