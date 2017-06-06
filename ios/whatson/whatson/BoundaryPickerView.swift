//
//  BoundaryPickerView.swift
//  whatson
//
//  Created by Alex Curran on 04/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class BoundaryPickerView: UIView {

    enum EditState {
        case none
        case start
        case end
    }

    private let beginningLabel = UILabel()
    private let intermediateLabel = UILabel()
    private let startSelectableView = TimeLabel()
    private let endSelectableView = TimeLabel()
    private let dateFormatter = DateFormatter(dateFormat: "HH:mm")

    weak var delegate: BoundaryPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        startSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = true
            self?.endSelectableView.selected = false
            self?.delegate?.boundaryPickerDidBeginEditing(in: .start)
        }
        endSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = false
            self?.endSelectableView.selected = true
            self?.delegate?.boundaryPickerDidBeginEditing(in: .end)
        }
        layout()
        style()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4

        stackView.addArrangedSubview(beginningLabel)
        stackView.addArrangedSubview(startSelectableView)
        stackView.addArrangedSubview(intermediateLabel)
        stackView.addArrangedSubview(endSelectableView)

        addSubview(stackView)
        stackView.constrainToSuperview([.top, .leading, .trailing, .bottom])
        stackView.hugContent(.vertical)
    }

    private func style() {
        beginningLabel.set(style: .header)
        intermediateLabel.set(style: .header)
    }

    func updateText(from timeStore: UserDefaultsTimeStore) {
        beginningLabel.text = NSLocalizedString("Options.Beginning", comment: "Text explaining the time boundaries")
        startSelectableView.text = dateFormatter.string(from: NSDateCalculator.instance.date(timeStore.startTimestamp))
        intermediateLabel.text = NSLocalizedString("Options.Intermediate", comment: "Text explaining the time boundaries")
        endSelectableView.text = dateFormatter.string(from: NSDateCalculator.instance.date(timeStore.endTimestamp))
    }

}

protocol BoundaryPickerViewDelegate: class {

    func boundaryPickerDidBeginEditing(in state: BoundaryPickerView.EditState)

}
