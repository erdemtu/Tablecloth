//
//  TableViewAccessoryModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import UIKit

public protocol TableViewAccessoryModel {

    func accessoryHeight() -> CGFloat
    func accessoryView() -> UIView
}