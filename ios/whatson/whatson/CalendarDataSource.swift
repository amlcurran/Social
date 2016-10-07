import UIKit

class CalendarDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [SCCalendarItem?] = []
    private var slots: [SCCalendarSlot] = []
    private weak var delegate: CalendarDataSourceDelegate?
    
    init(delegate: CalendarDataSourceDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as! CalendarSourceViewCell
        cell.bind(items[indexPath.row]!, slot: slots[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slots.count;
    }
    
    func update(_ source: SCCalendarSource) {
        items.removeAll()
        slots.removeAll()
        let sourceCount = Int(source.count())
        for i in 0 ..< sourceCount {
            items.append(source.itemAt(with: jint(i)))
            slots.append(source.slotAt(with: jint(i)))
        }
    }
    
    func item(at index: IndexPath) -> SCCalendarItem? {
        return items[index.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) else {
            preconditionFailure("Calendar didn't have item at expected index \((indexPath as NSIndexPath).row)")
        }
        if item.isEmpty() {
            delegate?.addEvent(for: item)
        } else {
            delegate?.showDetails(for: item as! SCEventCalendarItem)
        }
    }

}

protocol CalendarDataSourceDelegate: class {
    func addEvent(for item: SCCalendarItem)
    
    func showDetails(for item: SCEventCalendarItem)
}