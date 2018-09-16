package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.Arrays;
import java.util.List;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;

public class EventsServiceTest {

    @Test
    public void givenASlotWithTwoEventsThenTheSlotHasACountOfTwo() {
        EventsService service = new EventsService(new MyTimeRepository(), new MyEventsRepository(), null);

        CalendarSource calendarSource = service.getCalendarSource(14, new Timestamp(0, new TestCalculator()));

        assertThat(calendarSource.slotAt(0).count(), is(2));
    }

    private static class MyEventsRepository implements EventsRepository {

        @Override
        public List<CalendarItem> getCalendarItems(Timestamp nowTime, Timestamp nextWeek, TimeOfDay fivePm, TimeOfDay elevenPm) {
            return Arrays.asList(new TestCalendarItem(), new TestCalendarItem());
        }
    }

    private static class MyTimeRepository implements TimeRepository {
        @Override
        public TimeOfDay borderTimeEnd() {
            return TimeOfDay.fromHours(23);
        }

        @Override
        public TimeOfDay borderTimeStart() {
            return TimeOfDay.fromHours(17);
        }

    }

}