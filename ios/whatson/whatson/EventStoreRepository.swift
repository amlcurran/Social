import UIKit
import EventKit

@objc class EventStoreRepository: NSObject, SCEventsRepository {

    let calculator: NSDateCalculator
    let predicates: EventPredicates

    init(timeRepository: SCTimeRepository) {
        self.calculator = NSDateCalculator.instance
        self.predicates = EventPredicates(timeRepository: timeRepository)
    }

    public func getCalendarItems(with nowTime: SCTimestamp!,
                                 with nextWeek: SCTimestamp!,
                                 with fivePm: SCTimeOfDay!,
                                 with elevenPm: SCTimeOfDay!) -> JavaUtilList {
        let eventStore = EKEventStore()
        let startTime = calculator.date(from: nowTime)
        let endTime = calculator.date(from: nextWeek)
        let search = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: nil)
        let allEvents = eventStore.events(matching: search)
        let filtered = allEvents.filter(predicates.standard().evaluate)
        let items = filtered.flatMap({ ekEvent in
            return SCEventCalendarItem(nsString: ekEvent.eventIdentifier,
                    with: ekEvent.title,
                    with: self.calculator.time(from: ekEvent.startDate),
                    with: self.calculator.time(from: ekEvent.endDate))
        })
        return items.toJavaList()
    }

}

fileprivate extension Array {

    func toJavaList() -> JavaUtilList {
        let list = JavaUtilArrayList()
        for item in self {
            list!.add(withId: item)
        }
        return list!
    }

}
