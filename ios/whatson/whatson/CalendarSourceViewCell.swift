import Foundation
import UIKit

@IBDesignable
class EventCell: UITableViewCell {

    let eventLabel = UILabel()
    let roundedView = RoundedRectBorderView()
    let timeFormatter = DateFormatter.shortTime
    let timeCalculator = NSDateCalculator.instance
    let secondaryLabel = UILabel()
    let otherEventsLabel = UILabel()

    var secondaryLabelZeroHeightConstraint: NSLayoutConstraint?

    var type: SlotCellStyle = .empty {
        didSet {
            roundedView.backgroundColor = type.cellBackground
            eventLabel.textColor = type.mainText
            secondaryLabel.textColor = type.secondaryText
            otherEventsLabel.textColor = type.secondaryText
            roundedView.borderColor = type.borderColor
            roundedView.borderWidth = type.borderWidth
            roundedView.borderDash = type.borderDash
            updateSecondaryHeight()
        }
    }

    var detail: SlotDetail = .mid {
        didSet {
            updateSecondaryHeight()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleViews()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleViews()
        layout()
    }

    private func styleViews() {
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        backgroundColor = .clear
        selectionStyle = .none

        eventLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        secondaryLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        otherEventsLabel.font = .systemFont(ofSize: 18, weight: UIFontWeightMedium)
        otherEventsLabel.textAlignment = .right
    }

    private func layout() {
        roundedView.addSubview(otherEventsLabel)
        otherEventsLabel.constrainToSuperview([.trailing, .top, .bottom], insetBy: 16)
        roundedView.addSubview(eventLabel)
        eventLabel.constrainToSuperview([.top, .leading], insetBy: 16)
        eventLabel.constrain(.trailing, to: otherEventsLabel, .leading)
        eventLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        roundedView.addSubview(secondaryLabel)
        secondaryLabel.constrainToSuperview([.leading, .trailing, .bottom], insetBy: 16)
        secondaryLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        secondaryLabel.constrain(.top, to: eventLabel, .bottom)
        secondaryLabelZeroHeightConstraint = secondaryLabel.constrain(height: 0)
        updateSecondaryHeight()

        contentView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView.add(roundedView, constrainedTo: [.topMargin, .leadingMargin, .trailingMargin, .bottomMargin])
        roundedView.cornerRadius = 6
        roundedView.layer.shadowOffset = CGSize(width: 0, height: 6)
        roundedView.layer.shadowRadius = 4
        roundedView.layer.shadowColor = UIColor.red.cgColor
    }

    func updateSecondaryHeight() {
        if detail.isSecondaryTextShown && type.isSecondaryTextShown {
            secondaryLabelZeroHeightConstraint?.isActive = false
        } else {
            secondaryLabelZeroHeightConstraint?.isActive = true
        }
    }

    func bound(to item: SCCalendarItem, slot: SCCalendarSlot) -> Self {
        let startTime = timeFormatter.string(from: timeCalculator.date(from: item.startTime()))
        secondaryLabel.text = String(format: "From %@", startTime)
        if slot.isEmpty() {
            type = .empty
            eventLabel.text = "Add event"
        } else {
            type = .full
            eventLabel.text = item.title()
        }
        if slot.count() > 1 {
            otherEventsLabel.text = "+\(slot.extraItemsCount)"
        } else {
            otherEventsLabel.text = nil
        }
        return self
    }

}

extension SCCalendarSlot {

    var extraItemsCount: Int {
        return Int(count()) - 1
    }

}
