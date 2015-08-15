package uk.co.amlcurran.social;

import android.support.v4.util.SparseArrayCompat;

import org.joda.time.DateTime;

import uk.co.amlcurran.social.bootstrap.ItemSource;

class CalendarSource implements ItemSource<CalendarItem> {

    private final SparseArrayCompat<CalendarItem> calendarItems;
    private final int daysSize;
    private final DateTime now;

    public CalendarSource(SparseArrayCompat<CalendarItem> calendarItems, int daysSize, DateTime now) {
        this.calendarItems = calendarItems;
        this.daysSize = daysSize;
        this.now = now;
    }

    @Override
    public int count() {
        return daysSize;
    }

    @Override
    public CalendarItem itemAt(int position) {
        return calendarItems.get(position, new EmptyCalendarItem(position, now.plusDays(position)));
    }

    public boolean isEmptyAt(int position) {
        return calendarItems.get(position) == null;
    }
}
