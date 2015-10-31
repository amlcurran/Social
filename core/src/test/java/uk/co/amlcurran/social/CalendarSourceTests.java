package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import uk.co.amlcurran.social.core.SparseArray;

import static org.fest.assertions.api.Assertions.assertThat;

public class CalendarSourceTests {

    @Test
    public void testOneDayWithNoItemsIsEmpty() {
        List<CalendarItem> items = new ArrayList<>();
        CalendarSource calendarSource = getSource(items, 1);

        assertThat(calendarSource.slotAt(0).isEmpty()).isTrue();
    }

    private CalendarSource getSource(List<CalendarItem> items, int numberOfItems) {
        return getSource(items, numberOfItems, 0);
    }

    private CalendarSource getSource(List<CalendarItem> items, int numberOfItems, int position) {
        SparseArray<CalendarSlot> slots = new SparseArray<>(numberOfItems);
        if (!items.isEmpty()) {
            CalendarSlot calendarSlot = new CalendarSlot();
            calendarSlot.addItem(items.get(0));
            slots.put(position, calendarSlot);
        }
        return new CalendarSource(null, slots, numberOfItems);
    }

    @Test
    public void testOneDayWithOneItemIsNotEmpty() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem());
        CalendarSource calendarSource = getSource(items, 1);

        assertThat(calendarSource.slotAt(0).isEmpty()).isFalse();
    }

    @Test
    public void testTwoDaysWithOneItemOnDayTwoIsEmptyOnDayOne() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem());
        CalendarSource calendarSource = getSource(items, 2, 1);

        assertThat(calendarSource.slotAt(0).isEmpty()).isTrue();
    }

    @Test
    public void testTwoDaysWithNegativeStartDayItemOnDayOneIsEmptyOnDayTwo() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem());
        CalendarSource calendarSource = getSource(items, 2, 0);

        assertThat(calendarSource.slotAt(0).isEmpty()).isFalse();
    }

}