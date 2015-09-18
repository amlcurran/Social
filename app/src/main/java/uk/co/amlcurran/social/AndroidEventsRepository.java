package uk.co.amlcurran.social;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.provider.CalendarContract;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;

import rx.Subscriber;

public class AndroidEventsRepository implements EventsRepository {

    private static String[] PROJECTION = new String[]{
            CalendarContract.Events.TITLE,
            CalendarContract.Instances.START_DAY,
            CalendarContract.Events.SELF_ATTENDEE_STATUS,
            CalendarContract.Events.DTSTART,
            CalendarContract.Instances.EVENT_ID
    };
    private final ContentResolver contentResolver;

    public AndroidEventsRepository(ContentResolver contentResolver) {
        this.contentResolver = contentResolver;
    }

    @Override
    public EventRepositoryAccessor queryEvents(Subscriber<? super EventRepositoryAccessor> subscriber, long fivePm, long elevenPm,
                                               Time searchStart, Time searchEnd) {
        Uri.Builder builder = CalendarContract.Instances.CONTENT_URI.buildUpon();
        ContentUris.appendId(builder, searchStart.getMillis());
        ContentUris.appendId(builder, searchEnd.getMillis());

        String endsBefore = String.format("%1$s < %2$d", CalendarContract.Instances.END_MINUTE, fivePm);
        String startsAfter = String.format("%1$s > %2$d", CalendarContract.Instances.START_MINUTE, elevenPm);
        String selection = String.format("(NOT (%1$s OR %2$s)) AND %3$s <> %4$d AND %5$s == %6$d",
                endsBefore, startsAfter,
                CalendarContract.Instances.SELF_ATTENDEE_STATUS, CalendarContract.Instances.STATUS_CANCELED,
                CalendarContract.Instances.ALL_DAY, 0);

        Cursor calendarCursor = contentResolver.query(builder.build(), PROJECTION, selection, null, null);
        if (calendarCursor == null) {
            subscriber.onError(new NullPointerException("Calendar cursor was null!"));
            return null;
        }
        return new CursorEventRepositoryAccessor(calendarCursor);
    }

    private class CursorEventRepositoryAccessor implements EventRepositoryAccessor {

        private final Cursor calendarCursor;
        private final int titleColumnIndex;
        private final int dtStartColumnIndex;
        private final int eventIdColumnIndex;

        public CursorEventRepositoryAccessor(Cursor calendarCursor) {
            this.calendarCursor = calendarCursor;
            this.titleColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.TITLE);
            this.dtStartColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTSTART);
            this.eventIdColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.EVENT_ID);
        }

        @Override
        public String getTitle() {
            return calendarCursor.getString(titleColumnIndex);
        }

        @Override
        public long getDtStart() {
            return calendarCursor.getLong(dtStartColumnIndex);
        }

        @Override
        public String getEventIdentifier() {
            return calendarCursor.getString(eventIdColumnIndex);
        }

        @Override
        public boolean nextItem() {
            return calendarCursor.moveToNext();
        }

        @Override
        public void endAccess() {
            calendarCursor.close();
        }

        @Override
        public Time getStartTime() {
            return new JodaTime(new DateTime(getDtStart(), DateTimeZone.getDefault()));
        }
    }

}
