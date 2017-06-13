import UIKit

class CalendarTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

    private let dataProvider: DataProvider
    private let tableView: UITableView
    private weak var delegate: CalendarTableViewDelegate?

    var view: UIView {
        return tableView
    }

    init(delegate: CalendarTableViewDelegate, dataProvider: DataProvider, tableView: UITableView) {
        self.delegate = delegate
        self.tableView = tableView
        self.dataProvider = dataProvider
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as? CalendarSourceViewCell,
            let item = dataProvider.item(at: indexPath),
            let slot = dataProvider.slot(at: indexPath) else {
                preconditionFailure("Tried to dequeue a cell which wasn't a Calendar cell")
        }
        return cell.bound(to: item, slot: slot)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.count
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let slot = dataProvider.slot(at: indexPath),
            slot.count() != 0,
            let slotItem = dataProvider.item(at: indexPath) as? SCEventCalendarItem {
            return [UITableViewRowAction(style: .destructive, title: "Delete", handler: { [weak self] _, _ in
                self?.delegate?.remove(slotItem)
            })]
        }
        return nil
    }

    func update(_ source: SCCalendarSource) {
        let indexes = dataProvider.update(from: source)
        if indexes.count > 0 {
            tableView.reloadRows(at: indexes, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }

    func show() {
        tableView.alpha = 1
        tableView.isUserInteractionEnabled = true
    }

    func hide() {
        tableView.alpha = 0
        tableView.isUserInteractionEnabled = false
    }

    func item(at index: IndexPath) -> SCCalendarItem? {
        return dataProvider.item(at: index)
    }

    func indexPath(under location: CGPoint) -> IndexPath? {
        return tableView.indexPathForRow(at: location)
    }

    func cell(at index: IndexPath) -> UITableViewCell? {
        return tableView.cellForRow(at: index)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataProvider.item(at: indexPath).required(message: "Calendar didn't have item at expected index \((indexPath as NSIndexPath).row)")
        if item.isEmpty() {
            delegate?.addEvent(for: item)
        } else {
            guard let item = item as? SCEventCalendarItem else {
                preconditionFailure("Item isn't empty, but isn't event")
            }
            let cell = tableView.cellForRow(at: indexPath).required()
            delegate?.showDetails(for: item, at: indexPath, in: cell)
        }
    }

    func enablePreviewing(with delegate: UIViewControllerPreviewingDelegate, in viewController: UIViewController) {
        viewController.registerForPreviewing(with: delegate, sourceView: tableView)
    }

    func style(offsetAgainst header: HeaderView) {
        let newCellNib = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        tableView.register(newCellNib, forCellReuseIdentifier: "day")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: header.intrinsicContentSize.height + 38, left: 0, bottom: 16, right: 0)
    }

}

protocol CalendarTableViewDelegate: class {
    func addEvent(for item: SCCalendarItem)

    func showDetails(for item: SCEventCalendarItem, at indexPath: IndexPath, in cell: UITableViewCell)

    func remove(_ event: SCEventCalendarItem)
}