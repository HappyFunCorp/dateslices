require "active_support/core_ext/module/attribute_accessors"
require "active_support/time"
# require "groupdate/version"
# require "dateslices/magic"

module Dateslices
  FIELDS = [:second, :minute, :hour, :day, :week, :day_of_week, :month, :year ]
  METHODS = FIELDS.map{|v| :"group_by_#{v}" }

  mattr_accessor :week_start, :day_start, :time_zone
  self.week_start = :sun
  self.day_start = 0
end

# require "groupdate/enumerable"

begin
  require "active_record"
rescue LoadError
  # do nothing
end

require 'dateslices/scopes'

ActiveRecord::Base.send(:extend, Dateslices::Scopes)
