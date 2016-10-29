//
//  ViewController.swift
//  Tablecloth
//
//  Created by Erdem Turançiftçi on 29/10/2016.
//  Copyright © 2016 Erdem Turançiftçi. All rights reserved.
//

import UIKit
import Tablecloth

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var tableViewManager: TableViewManager!
    
    fileprivate var items = [Item]()
    
    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = view.frame.width
        let height = view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: width, height: height - 20))
        tableView.backgroundColor = UIColor.white
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: width, height: 1))
        view.addSubview(tableView)
        
        tableViewManager = TableViewManager(tableView: tableView, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableViewManager.updateTableViewWithAnimation()
    }
    
    var currentIdentifier = 0
    
    func buttonTouched() {
        items.append(Item(text: currentIdentifier.description, identifier: currentIdentifier))
        currentIdentifier = currentIdentifier + 1
        
        tableViewManager.updateTableViewWithAnimation()
    }
    
    func itemSelected(_ selectedItem: Item) {
        
        if let itemIndex = items.index(where: { return $0.identifier == selectedItem.identifier }) {
            items.remove(at: itemIndex)
            tableViewManager.updateTableViewWithAnimation()
        }
    }
}

extension ViewController: TableViewManagerDelegate {
    
    func generateTableViewModel(_ tableViewManager: TableViewManager) -> TableViewModel {
        var cellModels = Array<TableViewCellModel>()
        
        cellModels.append(
            ButtonCellModel(
                buttonTitle: "Add Item",
                cellSelection: { [weak self] _ in
                    
                    self?.buttonTouched()
                }))
        
        for item in items {
            
            cellModels.append(
                ItemCellModel(
                    item: item,
                    cellSelection: { [weak self] (wrappedObject, indexPath) in
                        
                        if let item = wrappedObject as? Item {
                            self?.itemSelected(item)
                        }
                }))
        }
        
        let sectionModel = TableViewSectionModel(cellModels: cellModels)
        let sectionModels = [sectionModel]
        return TableViewModel(sectionModels: sectionModels)
    }
}
