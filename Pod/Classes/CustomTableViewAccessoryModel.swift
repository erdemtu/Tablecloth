//
//  CustomTableViewAccessoryModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

public class CustomTableViewAccessoryModel: TableViewAccessoryModel {
 
    var height: CGFloat
    var viewSetup: ((accessoryHeight: CGFloat) -> UIView)
    
    public func accessoryHeight() -> CGFloat {
        return height
    }
    
    public func accessoryView() -> UIView {
        return viewSetup(accessoryHeight: height)
    }
    
    public init(height: CGFloat, viewSetup: ((accessoryHeight: CGFloat) -> UIView)) {
        self.height = height
        self.viewSetup = viewSetup
    }
}
