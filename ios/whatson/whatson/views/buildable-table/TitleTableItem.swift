//
//  TitleTableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

struct TitleTableItem: TableItem {

    static var cellIdentifier = "singleCell"

    let title: String
    let isSelectable = false

    func bind(to cell: UITableViewCell) {
        cell.textLabel?.text = title
    }

    static func register(in tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TitleTableItem.cellIdentifier)
    }

}
