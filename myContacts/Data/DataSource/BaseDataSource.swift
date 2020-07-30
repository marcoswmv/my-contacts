//
//  BaseDataSource.swift
//  myContacts
//
//  Created by Marcos Vicente on 30.07.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class BaseDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private(set) var tableView: UITableView
    var onError: ((_ error: Error) -> ())?
    var onLoading: ((_ isLoading: Bool) -> ())?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        setup()
    }
    
    func setup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func reload() {
        fatalError("Not implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Not implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Not implemented")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    func addTableViewBackgroundView(with text: String) {
        let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                width: tableView.bounds.size.width,
                                                height: tableView.bounds.size.height))
        noDataLabel.text = text
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
    }
}
