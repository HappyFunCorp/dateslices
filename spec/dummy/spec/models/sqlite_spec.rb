require 'rails_helper'
require 'dateslice_tester'

RSpec.describe "Sqlite", :type => :model do
  include_examples "dateslice", { :adapter => "sqlite3", :database => "db/test.sqlite3" }
end
