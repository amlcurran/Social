//
//  CalendarsLoader.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation
import EventKit

class CalendarLoader {

    let eventStore: EKEventStore
    let preferenceStore: CalendarPreferenceStore

    init(eventStore: EKEventStore = .instance, preferenceStore: CalendarPreferenceStore) {
        self.eventStore = eventStore
        self.preferenceStore = preferenceStore
    }

    func load(onSuccess: ([EventCalendar]) -> Void, onError: (Error) -> Void) {
        let ekCalendars = eventStore.calendars(for: .event)
        let excludedCalendars = preferenceStore.excludedCalendars
        let calendars = ekCalendars.map({ ekCalendar -> EventCalendar in
            let calendarId = EventCalendar.Id(rawValue: ekCalendar.calendarIdentifier)
            return EventCalendar(name: ekCalendar.title,
                                 account: ekCalendar.source.title,
                                 id: calendarId,
                                 included: excludedCalendars.contains(calendarId) == false,
                                 editable: ekCalendar.allowsContentModifications)
        })
        onSuccess(calendars)
    }

}

struct EventCalendar: Equatable {

    let name: String
    let account: String
    //swiftlint:disable:next variable_name
    let id: Id
    let included: Bool
    let editable: Bool

    //swiftlint:disable:next type_name
    struct Id: Hashable {
        let rawValue: String
    }

}

extension Array where Element == EventCalendar {

    var onlyEditable: [EventCalendar] {
        return filter { calendar in
            calendar.editable
        }
    }

}
