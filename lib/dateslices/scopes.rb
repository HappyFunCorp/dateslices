module Dateslices
  module Scopes
    Dateslices::FIELDS.each do |field|
      define_method :"group_by_#{field}" do |*args|
        args = args.dup

        column = args[0]
        column = "created_at" if column.blank?

        sql = ["count(*) as cnt"]

        time_filter = ""

        case connection.adapter_name
        when 'SQLite'
          time_filter = case field
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
          when :day_of_week
            "strftime( \"%w\", #{column} )"
          else
            throw "Unknown time filter #{field}"
          end
        when "PostgreSQL", "PostGIS"
          time_filter = case field
          when :day_of_week
            "EXTRACT(DOW from #{column})"
          when :week # Postgres weeks start on monday
            "(DATE_TRUNC( 'week', #{column} + INTERVAL '1 day' ) - INTERVAL '1 day')"
          else
            "DATE_TRUNC( '#{field.to_s}' , #{column} )"
          end
        when "MySQL"
          time_filter = case field
          when :day_of_week
            "(DAYOFWEEK(#{column}) - 1)"
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
            throw "Implement #{field}"
          end
        else
          throw "Unknown database adaptor #{connection.adapter_name}"
        end

        sql << "#{time_filter} as date_slice"

        select( sql.join( ", " )).group("date_slice").order("date_slice").collect do |c|
          slice = c["date_slice"]
          slice = slice.to_i.to_s if slice.is_a? Float
          slice = slice.to_s if slice.is_a? Integer
          { date_slice: slice, count: c["cnt"] }
        end
      end
    end

  end
end
