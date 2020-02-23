package uk.co.amlcurran.social;

public interface EventRepositoryAccessor {
    String getTitle();

    String getEventIdentifier();

    boolean nextItem();

    Timestamp getStartTime();

    Timestamp getEndTime();

    String getCalendarId();

    boolean getAllDay();

    boolean isDeleted();

    int getAttendingStatus();

    int getStartMinuteInDay();

    int getEndMinuteInDay();

    String getString(String columnName);
}
