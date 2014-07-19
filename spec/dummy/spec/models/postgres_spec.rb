require 'rails_helper'
require 'dateslice_tester'

RSpec.describe "Postgres", :type => :model do
  include_examples "dateslice", { :adapter => "postgresql", :database => "dateslice_test" }
end