package uk.co.amlcurran.social;

import java.util.ArrayList;
import java.util.List;

import uk.co.amlcurran.social.core.SparseArray;

public class EventsService {
    private final TimeRepository timeRepository;
    private final EventsRepository eventsRepository;

    public EventsService(TimeRepository dateCreator, EventsRepository eventsRepository) {
        this.eventsRepository = eventsRepository;
        this.timeRepository = dateCreator;
    }

    public CalendarSource getCalendarSource(final int numberOfDays, final Time now) {
        Time nowTime = timeRepository.startOfToday();
        Time nextWeek = nowTime.plusDays(numberOfDays);
        long fivePm = timeRepository.startOfBorderTimeInMinutes();
        long elevenPm = timeRepository.endOfBorderTimeInMinutes();

        EventRepositoryAccessor accessor = eventsRepository.queryEvents(fivePm, elevenPm, nowTime, nextWeek);
        List<CalendarItem> calendarItems = new ArrayList<>();
        while (accessor.nextItem()) {
            String title = accessor.getTitle();
            String eventId = accessor.getEventIdentifier();
            Time time = accessor.getStartTime();
            Time endTime = accessor.getEndTime();
            calendarItems.add(new EventCalendarItem(eventId, title, time, endTime));
        }

        SparseArray<CalendarItem> itemArray = new SparseArray<>(numberOfDays);
        int epochToNow = now.daysSinceEpoch();
        for (CalendarItem item : calendarItems) {
            itemArray.put(item.startTime().daysSinceEpoch() - epochToNow, item);
        }

        CalendarSource calendarSource = new CalendarSource(timeRepository, itemArray, numberOfDays);
        accessor.endAccess();
        return calendarSource;
    }

}
