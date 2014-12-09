module Dateslices
  module Sqlite

    def self.time_filter(column, field)
      case field
        when :second
          "strftime( \"%Y-%m-%d %H:%M:%S UTC\", #{column} )"
        when :minute
          "strftime( \"%Y-%m-%d %H:%M:00 UTC\", #{column} )"
        when :hour
          "strftime( \"%Y-%m-%d %H:00:00 UTC\", #{column} )"
        when :day
          "strftime( \"%Y-%m-%d 00:00:00 UTC\", #{column} )"
        when :week
          "strftime('%Y-%m-%d 00:00:00 UTC', #{column}, '-6 days', 'weekday 0')"
        when :month
          "strftime( \"%Y-%m-01 00:00:00 UTC\", #{column} )"
        when :year
          "strftime( \"%Y-01-01 00:00:00 UTC\", #{column} )"
        when :hour_of_day
          "strftime( \"%H\", #{column} )"
        when :day_of_week
          "strftime( \"%w\", #{column} )"
        when :day_of_month
          "strftime( \"%d\", #{column} )"
        when :month_of_year
          "strftime( \"%m\", #{column} )"
        else
          throw "Unknown time filter #{field}"
      end
    end

  end
end
