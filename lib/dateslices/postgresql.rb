module Dateslices
  module Postgresql

    def self.time_filter(column, field)
      case field
        when :hour_of_day
          "EXTRACT(HOUR from #{column})"
        when :day_of_week
          "EXTRACT(DOW from #{column})"
        when :day_of_month
          "EXTRACT(DAY from #{column})"
        when :month_of_year
          "EXTRACT(MONTH from #{column})"
        when :week # Postgres weeks start on monday
          "(DATE_TRUNC( 'week', #{column} + INTERVAL '1 day' ) - INTERVAL '1 day')"
        else
          "DATE_TRUNC( '#{field.to_s}' , #{column} )"
      end
    end

  end
end
