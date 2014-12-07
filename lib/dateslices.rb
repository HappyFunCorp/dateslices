require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/time'

module Dateslices
  FIELDS = [:second, :minute, :hour, :day, :week, :day_of_week, :month, :year ]
  METHODS = FIELDS.map{|v| :"group_by_#{v}" }

  mattr_accessor :output_format

  self.output_format = :groupdate
end

begin
  require 'active_record'
rescue LoadError
  # do nothing
end

require 'dateslices/sqlite'
require 'dateslices/postgresql'
require 'dateslices/mysql'
require 'dateslices/scopes'

ActiveRecord::Base.send(:extend, Dateslices::Scopes)
