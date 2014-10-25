module Dateslices
  module Scopes

    Dateslices::FIELDS.each do |field|
      define_method :"group_by_#{field}" do |*args|
        args = args.dup

        column = args[0]
        column = 'created_at' if column.blank?

        sql = ['count(*) as cnt']

        time_filter = ''

        case connection.adapter_name
        when 'SQLite'
          time_filter = Dateslices::Sqlite.time_filter(column, field)
        when 'PostgreSQL', 'PostGIS'
          time_filter = Dateslices::Postgresql.time_filter(column, field)
        when 'MySQL'
          time_filter = Dateslices::Mysql.time_filter(column, field)
        else
          throw "Unknown database adaptor #{connection.adapter_name}"
        end

        sql << "#{time_filter} as date_slice"

        select( sql.join(', ')).group('date_slice').order('date_slice').collect do |c|
          slice = c['date_slice']
          slice = slice.to_i.to_s if slice.is_a? Float
          slice = slice.to_s if slice.is_a? Integer
          { date_slice: slice, count: c["cnt"] }
        end
      end
    end

  end
end
