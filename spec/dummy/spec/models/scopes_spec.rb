require 'rails_helper'

RSpec.describe "Scopes", :type => :model do
  Dateslices::METHODS.each do |f|
    it "should respond to #{f}" do
      expect( User.respond_to?( f ) ).to be(true)
    end

    it "should implement #{f}" do
      User.send f.to_sym
    end
  end
end