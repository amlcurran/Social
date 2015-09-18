package uk.co.amlcurran.social;

public class EmptyCalendarItem implements CalendarItem {
    private final int position;
    private final Time startTime;

    public EmptyCalendarItem(int position, Time startTime) {
        this.position = position;
        this.startTime = startTime;
    }

    @Override
    public String title() {
        return "Empty";
    }

    @Override
    public int startDay() {
        return position;
    }

    @Override
    public long startTime() {
        return startTime.getMillis();
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
