package uk.co.amlcurran.social

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.provider.CalendarContract

import java.util.ArrayList

class AndroidEventsRepository(private val contentResolver: ContentResolver) : EventsRepository {

    private fun getCursor(fivePm: TimeOfDay, elevenPm: TimeOfDay, searchStart: Timestamp, searchEnd: Timestamp): Cursor? {
        val builder = CalendarContract.Instances.CONTENT_URI.buildUpon()
        ContentUris.appendId(builder, searchStart.millis)
        ContentUris.appendId(builder, searchEnd.millis)

        val endsBefore = String.format("%1\$s < %2\$d", CalendarContract.Instances.END_MINUTE, fivePm.minutesInDay())
        val startsAfter = String.format("%1\$s > %2\$d", CalendarContract.Instances.START_MINUTE, elevenPm.minutesInDay())
        val selection = String.format("(NOT (%1\$s OR %2\$s)) AND %3\$s <> %4\$d AND %5\$s == %6\$d",
                endsBefore, startsAfter,
                CalendarContract.Instances.SELF_ATTENDEE_STATUS, CalendarContract.Instances.STATUS_CANCELED,
                CalendarContract.Instances.ALL_DAY, 0)

        return contentResolver.query(builder.build(), PROJECTION, selection, null, null)
    }

    override fun getCalendarItems(nowTime: Timestamp, nextWeek: Timestamp, fivePm: TimeOfDay, elevenPm: TimeOfDay): List<CalendarItem> {
        val calendarCursor = getCursor(fivePm, elevenPm, nowTime, nextWeek)
        val accessor = CursorEventRepositoryAccessor(calendarCursor!!, JodaCalculator())
        val calendarItems = ArrayList<CalendarItem>()
        while (accessor.nextItem()) {
            val title = accessor.title
            val eventId = accessor.eventIdentifier
            val time = accessor.startTime
            val endTime = accessor.endTime
            calendarItems.add(EventCalendarItem(eventId, title, time, endTime))
        }
        calendarCursor.close()
        return calendarItems
    }

    private class CursorEventRepositoryAccessor(private val calendarCursor: Cursor, private val timeCalculator: TimeCalculator) : EventRepositoryAccessor {
        private val titleColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.TITLE) }
        private val dtStartColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTSTART) }
        private val dtEndColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTEND) }
        private val eventIdColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.EVENT_ID) }

        override fun getTitle(): String {
            return calendarCursor.getString(titleColumnIndex)
        }

        override fun getEventIdentifier(): String {
            return calendarCursor.getString(eventIdColumnIndex)
        }

        override fun nextItem(): Boolean {
            return calendarCursor.moveToNext()
        }

        override fun endAccess() {
            calendarCursor.close()
        }

        override fun getStartTime(): Timestamp {
            val startMillis = calendarCursor.getLong(dtStartColumnIndex)
            return Timestamp(startMillis, timeCalculator)
        }

        override fun getEndTime(): Timestamp {
            val endMillis = calendarCursor.getLong(dtEndColumnIndex)
            return Timestamp(endMillis, timeCalculator)
        }
    }

    companion object {

        private val PROJECTION = arrayOf(CalendarContract.Events.TITLE, CalendarContract.Instances.START_DAY, CalendarContract.Events.SELF_ATTENDEE_STATUS, CalendarContract.Events.DTSTART, CalendarContract.Events.DTEND, CalendarContract.Instances.EVENT_ID)
    }

}
