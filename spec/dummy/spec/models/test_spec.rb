require 'rails_helper'
require 'dateslice_tester'
require 'groupdate_tester'

databases = [{ :adapter => 'mysql', :database => 'dateslice_test', :user => 'root'},
             { :adapter => 'postgresql', :database => 'dateslice_test'},
             { :adapter => 'sqlite3', :database => 'db/test.sqlite3'}]

formats = ['groupdate', 'dateslice']

databases.each do |database|
  formats.each do |format|
    RSpec.describe "#{database[:adapter].titleize} #{format}", :type => :model do
      include_examples format, database
    end
  end
end
