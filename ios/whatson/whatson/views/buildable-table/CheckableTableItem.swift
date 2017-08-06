//
//  CheckableTableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class CheckableTableItem: TableItem {

    static var cellIdentifier = "singleCell"

    let title: String
    let isChecked: Bool
    let isSelectable = true
    let isEnabled = true

    init(title: String, isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }

    func bind(to cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.accessoryType = isChecked ? .checkmark : .none
    }

    static func register(in tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TitleTableItem.cellIdentifier)
    }

    var withFlippedCheck: CheckableTableItem {
        return CheckableTableItem(title: title, isChecked: !isChecked)
    }

}
