module Dateslices
  module Mysql

    def self.time_filter(column, field)
      case field
        when :hour_of_day
          "(EXTRACT(HOUR from #{column}))"
        when :day_of_week
          "(DAYOFWEEK(#{column}) - 1)"
        when :day_of_month
          "DAYOFMONTH(#{column})"
        when :month_of_year
          "MONTH(#{column})"
        when :second
          "DATE_FORMAT(#{column}, '%Y-%m-%d %H:%i:%S UTC')"
        when :minute
          "DATE_FORMAT(#{column}, '%Y-%m-%d %H:%i:00 UTC')"
        when :hour
          "DATE_FORMAT(#{column}, '%Y-%m-%d %H:00:00 UTC')"
        when :day
          "DATE_FORMAT(#{column}, '%Y-%m-%d 00:00:00 UTC')"
        when :month
          "DATE_FORMAT(#{column}, '%Y-%m-01 00:00:00 UTC')"
        when :year
          "DATE_FORMAT(#{column}, '%Y-01-01 00:00:00 UTC')"
        when :week # Sigh...
          "DATE_FORMAT( date_sub( created_at, interval ((weekday( created_at ) + 1)%7) day ), '%Y-%m-%d 00:00:00 UTC')"
        else
          throw "Unknown time filter #{field}"
      end
    end

  end
end
