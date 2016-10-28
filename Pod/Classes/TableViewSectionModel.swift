//
//  TableViewSectionModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import Foundation

final public class TableViewSectionModel {
    
    var cellModels: Array<TableViewCellModel>
    public var headerModel: TableViewAccessoryModel?
    public var footerModel: TableViewAccessoryModel?
    
    public init() {
        cellModels = Array<TableViewCellModel>()
    }
    
    public init(cellModels: Array<TableViewCellModel>, headerModel: TableViewAccessoryModel? = nil, footerModel: TableViewAccessoryModel? = nil) {
        self.cellModels = cellModels
        self.headerModel = headerModel
        self.footerModel = footerModel
    }
}
