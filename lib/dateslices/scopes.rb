module Dateslices
  module Scopes

    Dateslices::FIELDS.each do |field|
      define_method :"group_by_#{field}" do |*args|

        args = args.dup

        column = args[0].blank? ? 'created_at' : args[0]

        aggregation = args[1].blank? ? 'count' : args[1]

        aggregation_column = args[2].blank? ? '*' : args[2]

        sql = ["#{aggregation}(#{aggregation_column}) as count"]

        time_filter = case connection.adapter_name
                        when 'SQLite'
                          Dateslices::Sqlite.time_filter(column, field)
                        when 'PostgreSQL', 'PostGIS'
                          Dateslices::Postgresql.time_filter(column, field)
                        when 'MySQL', 'Mysql2'
                          Dateslices::Mysql.time_filter(column, field)
                        else
                          throw "Unknown database adaptor #{connection.adapter_name}"
                      end

        sql << "#{time_filter} as date_slice"

        slices = select( sql.join(', ')).where.not(column => nil).group('date_slice').order('date_slice')

        if Dateslices.output_format == :groupdate
          slices = slices.collect do |c|
            [slice(c), c['count']]
          end

          Hash[slices]
        else
          slices.collect do |c|
            { date_slice: slice(c), aggregation.to_sym => c['count'] }
          end
        end
      end 
    end

    def slice(c)
      slice = c['date_slice']
      slice.is_a?(Float) ? slice.to_i.to_s : slice.to_s
    end

  end
end
