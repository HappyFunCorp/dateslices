require 'rails_helper'
require 'dateslice_tester'

RSpec.describe "Mysql", :type => :model do
  include_examples "dateslice", { :adapter => "mysql", :database => "dateslice_test", :user => "root" }
end