//
//  DeletedContactsVC+SearchBarDelegate.swift
//  myContacts
//
//  Created by Marcos Vicente on 30.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import Foundation
import UIKit

extension DeletedContactsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cancelSearchTimer()
        search(query: searchBar.text)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        cancelSearchTimer()
        search(query: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cancelSearchTimer()
        search(query: nil)
        searchBar.text = ""
        tableView.backgroundView = UIView()
        tableView.separatorStyle = .singleLine
        dataSource?.reload()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchIfNedded(query: searchText)
    }
    
    fileprivate func cancelSearchTimer()  {
        if timer != nil, timer!.isValid {
            timer?.invalidate()
            timer = nil
        }
    }
    
    fileprivate func searchIfNedded(query: String?) {
        cancelSearchTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            guard let self = self else { return }
            self.search(query: query)
        })
    }
    
    fileprivate func search(query: String?)  {
//        print(query ?? "none")
        guard let searchText = query else { return }
        dataSource?.startQuery(with: searchText)
    }
}
