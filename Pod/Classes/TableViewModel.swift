//
//  TableViewModel.swift
//  TableCloth
//
//  Created by Erdem Turanciftci on 23/10/15.
//  Copyright © 2015 Erdem Turanciftci. All rights reserved.
//

import Foundation

final public class TableViewModel {
    
    var sectionModels: Array<TableViewSectionModel>
    
    public init() {
        sectionModels = Array<TableViewSectionModel>()
    }
    
    public init(sectionModels: Array<TableViewSectionModel>) {
        self.sectionModels = sectionModels
    }
}