package uk.co.amlcurran.social

import android.database.Cursor
import android.provider.CalendarContract

class CursorEventRepositoryAccessor(private val calendarCursor: Cursor, private val timeCalculator: TimeCalculator) : EventRepositoryAccessor {

    private val titleColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.TITLE) }
    private val dtStartColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTSTART) }
    private val dtEndColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTEND) }
    private val eventIdColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.EVENT_ID) }
    private val calendarIdColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.CALENDAR_ID) }

    override fun getTitle(): String {
        return calendarCursor.getString(titleColumnIndex)
    }

    override fun getEventIdentifier(): String {
        return calendarCursor.getString(eventIdColumnIndex)
    }

    override fun nextItem(): Boolean {
        return calendarCursor.moveToNext()
    }

    override fun getStartTime(): Timestamp {
        val startMillis = calendarCursor.getLong(dtStartColumnIndex)
        return Timestamp(startMillis, timeCalculator)
    }

    override fun getEndTime(): Timestamp {
        val endMillis = calendarCursor.getLong(dtEndColumnIndex)
        return Timestamp(endMillis, timeCalculator)
    }

    override fun getCalendarId(): String {
        return calendarCursor.getString(calendarIdColumnIndex)
    }

    override fun getString(columnName: String): String {
        return calendarCursor.getString(calendarCursor.getColumnIndexOrThrow(columnName))
    }
}