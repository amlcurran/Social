package uk.co.amlcurran.social;

import android.Manifest;
import android.content.ContentUris;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.CalendarContract;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;

import rx.Observer;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;
import uk.co.amlcurran.social.core.SparseArray;

public class WhatsOnActivity extends AppCompatActivity {

    private static final int REQUEST_CODE_REQUEST_CALENDAR = 1;
    private Permissions permissions;
    private WhatsOnAdapter adapter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_whats_on);
        permissions = new Permissions(this);
        final DateTime now = DateTime.now(DateTimeZone.getDefault());

        RecyclerView recyclerView = (RecyclerView) findViewById(R.id.list_whats_on);
        adapter = new WhatsOnAdapter(LayoutInflater.from(this), eventSelectedListener, new CalendarSource(new SparseArray<CalendarItem>(), 0, new JodaTime(DateTime.now())));
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);

        permissions.requestPermission(REQUEST_CODE_REQUEST_CALENDAR, Manifest.permission.READ_CALENDAR, new Permissions.OnPermissionRequestListener() {
            @Override
            public void onPermissionGranted() {
                load(now, adapter);
            }

            @Override
            public void onPermissionDenied() {

            }
        });
    }

    private final WhatsOnAdapter.EventSelectedListener eventSelectedListener = new WhatsOnAdapter.EventSelectedListener() {
        @Override
        public void eventSelected(EventCalendarItem calendarItem) {
            Uri eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, calendarItem.id());
            startActivity(new Intent(Intent.ACTION_VIEW).setData(eventUri));
        }

        @Override
        public void emptySelected(EmptyCalendarItem calendarItem) {
            Intent intent = new Intent(Intent.ACTION_INSERT);
            intent.setData(CalendarContract.Events.CONTENT_URI);
            DateTime dateTime = DateTime.now(DateTimeZone.getDefault()).withTimeAtStartOfDay();
            DateTime day = dateTime.plusDays(calendarItem.startDay());
            DateTime startTime = day.plusHours(17);
            DateTime endTime = day.plusHours(22);
            intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.getMillis());
            intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.getMillis());
            startActivity(intent);
        }

    };

    private void load(DateTime now, Observer<CalendarSource> calendarSourceObserver) {
        AndroidEventsRepository eventsRepository = new AndroidEventsRepository(getContentResolver());
        AndroidTimeCreator dateCreator = new AndroidTimeCreator();
        new EventsService(dateCreator, eventsRepository)
                .queryEventsFrom(new JodaTime(now), 14)
                .subscribeOn(AndroidSchedulers.mainThread())
                .observeOn(Schedulers.io())
                .subscribe(calendarSourceObserver);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_whats_on, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {

            case R.id.pick_times:
                TimePickerActivity.start(this);
                return true;

        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        this.permissions.onRequestPermissionResult(requestCode, permissions, grantResults);
    }

}
