import UIKit
import EventKit
import CoreLocation
import MapKit

protocol DetailsCardDelegate: class {
    func didTapMap(on detailsCard: DetailsCard, onRegion region: MKCoordinateRegion)
}

class DetailsCard: UIView {

    lazy var titleLabel = UILabel()
    lazy var locationLabel = UILabel()
    lazy var timingLabel = UILabel()
    lazy var locationMapView = MKMapView()
    lazy var line = Line(height: 1, color: .cardDivider)
    lazy var mapTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped))

    var mapHeightConstraint: NSLayoutConstraint!
    var timingTitleContraint: NSLayoutConstraint?

    private let timeFormatter = DateFormatter.shortTime

    private weak var delegate: DetailsCardDelegate?

    func layout() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        backgroundColor = .surface

        addSubview(titleLabel)
        titleLabel.constrain(toSuperview: .leading, .top, .trailing, insetBy: 16)

        addSubview(timingLabel)
        timingLabel.constrain(toSuperview: .leading, .trailing, insetBy: 16)
        timingTitleContraint = timingLabel.constrain(.top, to: titleLabel, .bottom, withOffset: 4)

        addSubview(line)
        line.constrain(.width, to: self, .width)
        line.constrain(toSuperview: .leading, .trailing)
        line.constrain(.top, to: timingLabel, .bottom, withOffset: 16)

        addSubview(locationLabel)
        locationLabel.constrain(toSuperview: .leading, .trailing, insetBy: 16)
        locationLabel.constrain(.top, to: line, .bottom, withOffset: 16)

        let locationHostView = UIView()
        add(locationHostView, constrainedTo: [.leading, .trailing, .bottom])
        mapHeightConstraint = locationHostView.constrain(height: 136)
        locationHostView.constrain(.top, to: locationLabel, .bottom, withOffset: 16)
        locationHostView.addGestureRecognizer(mapTapRecognizer)
        locationHostView.add(locationMapView, constrainedTo: [.leading, .top, .trailing, .bottom])
    }

    @objc func mapTapped() {
        delegate?.didTapMap(on: self, onRegion: locationMapView.region)
    }

    func style() {
        titleLabel.set(style: .header)
        locationLabel.set(style: .lower)
        timingLabel.set(style: .lower)
        locationMapView.isUserInteractionEnabled = false
    }

    func set(event: EKEvent, delegate: DetailsCardDelegate) {
        self.delegate = delegate
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(timeFormatter.string(from: event.startDate)) to \(timeFormatter.string(from: event.endDate))"
    }

    func hideMap() {
        mapHeightConstraint.constant = 0
    }

    func collapseMap() {
        mapHeightConstraint.constant = 0
        line.removeFromSuperview()
        locationLabel.removeFromSuperview()
        locationMapView.removeFromSuperview()
        timingLabel.constrain(toSuperview: .bottom, insetBy: 16)
    }

    func expandMap() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.mapHeightConstraint.constant = 160
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.superview?.layoutIfNeeded()
            })
        }
    }

    func show(_ location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        locationMapView.setRegion(region, animated: false)
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate
        locationMapView.addAnnotation(point)
    }

}
