import EventKit

struct EventPredicates {

    let timeRepository: SCTimeRepository

    func standard() -> NSPredicate {
        return NSPredicate(compoundFrom: [
                notAllDay(),
                isWithinBorder(timeRepository: timeRepository, using: Calendar.autoupdatingCurrent),
                notDeclinedOrCancelled()
        ])
    }

}

extension NSPredicate {

    convenience init(compoundFrom predicates: [NSPredicate]) {
        self.init(block: { (element, _) -> Bool in
            return predicates.reduce(true, { (current, predicate) -> Bool in
                return current && predicate.evaluate(with: element)
            })
        })
    }

}

private func notDeclinedOrCancelled() -> NSPredicate {
    return NSPredicate(eventBlock: { event in
        if let mainUser = event.attendees.or([]).mainUser {
            return mainUser.participantStatus == .accepted
        }
        return false
    })
}

extension Array where Element == EKParticipant {

    var mainUser: EKParticipant? {
        return filter({ $0.isCurrentUser }).first
    }

}

private func notAllDay() -> NSPredicate {
    return NSPredicate(eventBlock: { event in
        return !event.isAllDay
    })
}

private func isWithinBorder(timeRepository: SCTimeRepository, using calendar: Calendar) -> NSPredicate {
    return NSPredicate(eventBlock: { event in
        let start = timeRepository.borderTimeStart()
        let end = timeRepository.borderTimeEnd()
        return event.startDate.timeOfDay(isBetween: start, and: end, onSameDayAs: event.endDate, in: calendar) ||
            event.endDate.timeOfDay(isBetween: start, and: end, in: calendar) ||
            (event.startDate.isBefore(start, in: calendar) && event.endDate.isAfter(end, in: calendar))
    })
}

private extension NSPredicate {

    convenience init(eventBlock: @escaping ((EKEvent) -> Bool)) {
        self.init(block: { element, _ in
            if let event = element as? EKEvent {
                return eventBlock(event)
            }
            return false
        })
    }

}

extension SCTimeOfDay {

    var hours: Int {
        get {
            return Int(hoursInDay())
        }
    }

}
