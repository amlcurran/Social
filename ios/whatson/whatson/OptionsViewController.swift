import Foundation
import UIKit

class OptionsViewController: UIViewController {

    private let startPicker = UIDatePicker()
    private let beginningLabel = UILabel()
    private let intermediateLabel = UILabel()
    private let startSelectableView = TimeLabel()
    private let endSelectableView = TimeLabel()
    private let timeStore = UserDefaultsTimeStore()
    private let dateFormatter = DateFormatter()
    private let picker: UIDatePicker = UIDatePicker()
    private var pickerHeightConstraint: NSLayoutConstraint!

    private var editState: EditState = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .windowBackground

        layoutViews()
        styleViews()
        startSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = true
            self?.endSelectableView.selected = false
            self?.showPicker()
            self?.editState = .start
            self?.beginEditing()
        }
        endSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = false
            self?.endSelectableView.selected = true
            self?.showPicker()
            self?.editState = .end
            self?.beginEditing()
        }
        picker.addTarget(self, action: #selector(spinnerUpdated), for: .valueChanged)
        picker.datePickerMode = .time

        dateFormatter.dateFormat = "HH:mm"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))

        spinnerUpdated()
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func styleViews() {
        beginningLabel.set(style: .header)
        intermediateLabel.set(style: .header)
    }

    private func showPicker() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pickerHeightConstraint.isActive = false
            self?.view.layoutIfNeeded()
        })
    }

    private func layoutViews() {
        let holdingView = UIView()

        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4

        stackView.addArrangedSubview(beginningLabel)
        stackView.addArrangedSubview(startSelectableView)
        stackView.addArrangedSubview(intermediateLabel)
        stackView.addArrangedSubview(endSelectableView)

        [beginningLabel, startSelectableView, intermediateLabel, endSelectableView].forEach({ view in
            view.hugContent(.vertical)
        })
        holdingView.add(stackView, constrainedTo: [.leading, .trailing])
        stackView.centerYAnchor.constraint(equalTo: holdingView.centerYAnchor).isActive = true
        stackView.hugContent(.vertical)

        view.add(holdingView, constrainedTo: [.top, .leading, .trailing])
        pickerHeightConstraint = picker.constrain(height: 0)
        pickerHeightConstraint.isActive = true
        view.add(picker, constrainedTo: [.leading, .trailing, .bottom])
        picker.constrain(.top, to: holdingView, .bottom)
    }

    func doneTapped() {
//        let startComponents = Calendar.current.dateComponents([.hour], from: startPicker.date)
//        let endComponents = Calendar.current.dateComponents([.hour], from: 23)
//        timeStore.startTime = startComponents.hour
//        timeStore.endTime = endComponents.hour
        dismiss(animated: true, completion: nil)
    }

    func beginEditing() {
        if (editState == .start) {
            picker.hour = timeStore.startTime
        }
        if (editState == .end) {
            picker.hour = timeStore.endTime
        }
    }

    func spinnerUpdated() {
        if (editState == .start) {
            timeStore.startTime = Calendar.current.dateComponents([.hour], from: picker.date).hour.or(17)
        }
        if (editState == .end) {
            timeStore.endTime = Calendar.current.dateComponents([.hour], from: picker.date).hour.or(23)
        }
        beginningLabel.text = "Show me events from"
        startSelectableView.text = dateFormatter.string(from: NSDateCalculator.instance.date(timeStore.startTimestamp))
        intermediateLabel.text = "to"
        endSelectableView.text = dateFormatter.string(from: NSDateCalculator.instance.date(timeStore.endTimestamp))
    }

    enum EditState {
        case none
        case start
        case end
    }

}

class UserDefaultsTimeStore {

    private let userDefaults: UserDefaults
    private let dateCalculator = NSDateCalculator.instance

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var startTimestamp: SCTimestamp {
        get {
            return dateCalculator.startOfToday().plusHours(with: Int32(startTime))
        }
    }

    var endTimestamp: SCTimestamp {
        get {
            return dateCalculator.startOfToday().plusHours(with: Int32(endTime))
        }
    }

    var startTime: Int {
        get {
            if let startTime = userDefaults.value(forKey: "startHour") as? Int {
                return startTime
            }
            return 17
        }
        set {
            userDefaults.set(newValue, forKey: "startHour")
        }
    }

    var endTime: Int {
        get {
            if let endTime = userDefaults.value(forKey: "endHour") as? Int {
                return endTime
            }
            return 23
        }
        set {
            userDefaults.set(newValue, forKey: "endHour")
        }
    }

}

extension UIDatePicker {

    var hour: Int? {
        get {
            return Calendar.current.dateComponents([.hour], from: date).hour
        }
        set {
            var components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
            components.hour = newValue
            components.minute = 0
            date = Calendar.current.date(from: components)!
        }
    }

}
