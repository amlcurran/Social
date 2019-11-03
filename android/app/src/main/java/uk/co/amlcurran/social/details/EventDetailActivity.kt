package uk.co.amlcurran.social.details

import android.app.Dialog
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.util.Log
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.DialogFragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposable
import io.reactivex.rxkotlin.plusAssign
import io.reactivex.rxkotlin.subscribeBy
import kotlinx.android.synthetic.main.activity_event_details.*
import kotlinx.android.synthetic.main.item_event.*
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import uk.co.amlcurran.social.*

class EventDetailActivity: AppCompatActivity() {

    private lateinit var eventId: String
    private val subscriptions = CompositeDisposable()
    private val timeFormatter: DateTimeFormatter by lazy { DateTimeFormat.shortTime() }
    private val jodaCalculator = JodaCalculator()
    private val events: Events by lazy {
        val calendarRepository = CalendarRepository(this)
        val eventsRepository = AndroidEventsRepository(contentResolver, calendarRepository)
        Events(eventsService = EventsService(AndroidTimeRepository(), eventsRepository, jodaCalculator))
    }

    companion object {

        private const val KEY_EVENT_TITLE = "title"
        private const val KEY_EVENT_ID = "event_id"

        fun show(event: EventCalendarItem, context: Context): Intent {
            val intent = Intent(context, EventDetailActivity::class.java)
            intent.putExtra(KEY_EVENT_ID, event.id())
            intent.putExtra(KEY_EVENT_TITLE, event.title)
            return intent
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_details)
        eventId = intent.getStringExtra(KEY_EVENT_ID) ?: throw IllegalStateException("missing event ID")

        subscriptions += events.loadSingleEvent(eventId)
                .subscribeBy(
                        onSuccess = ::render,
                        onError = {
                            it.printStackTrace()
                            Snackbar.make(event_card, R.string.something_went_wrong, Snackbar.LENGTH_LONG).show()
                        }
                )

        toolbar2.setOnMenuItemClickListener(::onOptionsItemSelected)
        toolbar2.setNavigationOnClickListener { finish() }
    }

    private fun render(event: Event) {
        event_title.text = event.item.title
        val startTime = event.item.startTime.format(timeFormatter, jodaCalculator)
        val endTime = event.item.endTime.format(timeFormatter, jodaCalculator)
        event_subtitle.text = getString(R.string.start_to_end, startTime, endTime)
        toolbar2.menu.findItem(R.id.menu_open_outside).isVisible = true
        toolbar2.menu.findItem(R.id.menu_delete_event).isVisible = true
        Log.d("foo", event.location)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.menu_open_outside -> launchInExternalCalendar()
            R.id.menu_delete_event -> confirmDelete()
        }
        return true
    }

    private fun confirmDelete() {
        ConfirmDelete().apply {
            onConfirm = { deleteEvent() }
            show(supportFragmentManager, null)
        }

    }

    private fun deleteEvent() {
        subscriptions += events.delete(eventId)
                .subscribeBy(
                        onComplete = { finish() },
                        onError = { Snackbar.make(event_card, getString(R.string.couldnt_delete_event), Snackbar.LENGTH_SHORT).show() }
                )
    }

    private fun launchInExternalCalendar() {
        val id = eventId.toLong()
        val eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, id)
        startActivity(Intent(Intent.ACTION_VIEW).setData(eventUri))
    }

}

class ConfirmDelete: DialogFragment() {

    lateinit var onConfirm: () -> Unit

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return MaterialAlertDialogBuilder(requireContext())
                .setMessage(R.string.confirm_delete_message)
                .setPositiveButton(R.string.delete) { _, _ -> onConfirm() }
                .setNegativeButton(R.string.cancel) { dialog, _ -> dialog.dismiss() }
                .create()
    }
}

fun Timestamp.format(dateTimeFormatter: DateTimeFormatter, calculator: JodaCalculator) = dateTimeFormatter.print(calculator.getDateTime(this))
