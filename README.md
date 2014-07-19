= Dateslices

This project rocks and uses MIT-LICENSE.

This project is based upon [groupdate](https://github.com/ankane/groupdate) and follows a similar API.

The differences between the groupdate and dateslices are:
- dateslices has much less functionality.
- dateslices supports sqlite3
- dateslices ignores timezones
- dateslices is rails 4 only.
- dateslices uses rspecs for tests.
- dateslices doesn't have hour_of_day since I don't deal with timezones


The reason that I wrote this is that I use sqlite in development, and wanted to make sure that I could test things locally.  I didn't understand the test suite of groupdate, so I ended up rewriting it.


== Example Usage

```
User.where( :created_at > 1.month.ago ).group_by_day
```

== All find methods

- group_by_second
- group_by_minute
- group_by_hour
- group_by_day
- group_by_week
- group_by_day_of_week
- group_by_month
- group_by_year

== Tests

Rspec tests need to be run out of the spec/dummy directory, and you'll need to have a postgres and a mysql database named "dateslice_test" for them to success.
