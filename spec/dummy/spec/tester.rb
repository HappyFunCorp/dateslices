require 'groupdate_output'
require 'dateslices_output'

formats = ['groupdate', 'dateslices']

formats.each do |format|
  output = send("#{format}_output")

  RSpec.shared_examples format do |config|

    before :suite do
      puts "Setting up #{config}"
      ActiveRecord::Base.establish_connection config

      puts "Trying to migrate"
      ActiveRecord::Migration.create_table :users, :force => true do |t|
        t.string :name
        t.integer :score
        t.timestamp :created_at
        t.timestamp :updated_at
      end
    end

    before :each do
      Dateslices.output_format = format.to_sym
      User.delete_all
    end

    context "groupings" do
      it "should return items grouped by second" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (t.seconds/2).to_i
        end

        expect( User.group_by_second ).to eq output[:second]
      end

      it "should return items grouped by minute" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.seconds * t)
        end

        expect( User.group_by_minute ).to eq output[:minute]
      end

      it "should return items grouped by hour" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.minutes * t)
        end

        expect( User.group_by_hour ).to eq output[:hour]
      end

      it "should return items grouped by day" do
        expect( User.count ).to eq(0)

        @initial_time = Time.parse "2014-07-19 15:26:48 -0400"

        User.create created_at: @initial_time
        User.create created_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.week

        expect( User.count ).to eq( 4 )

        res = User.group_by_day( :created_at )

        expect(res).to eq output[:day]
      end

      it "should return items grouped by week" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0000"

        8.times do |t|
          User.create created_at: @t - t.day
        end

        expect( User.group_by_week ).to eq output[:week]
      end

      it "should return items grouped by month" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - t.weeks
        end

        expect( User.group_by_month ).to eq output[:month]
      end

      it "should return items grouped by year" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - t.months
        end

        expect( User.group_by_year ).to eq output[:year]
      end
    end

    context "collections" do
      it "should return items grouped by hour of day" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.minutes * t)
        end

        expect( User.group_by_hour_of_day ).to eq output[:hour_of_day]
      end

      it "should return items grouped by day of week" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        8.times do |t|
          User.create created_at: @t - t.day
        end

        expect( User.group_by_day_of_week ).to eq output[:day_of_week]
      end

      it "should return items grouped by day of month" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-10 15:26:48 -0400"

        5.times do |t|
          User.create created_at: @t - (t*10).days
        end

        expect( User.group_by_day_of_month ).to eq output[:day_of_month]
      end

      it "should return items grouped by month of year" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-12-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - t.weeks
        end

        User.create created_at: @t - 12.months

        expect( User.group_by_month_of_year ).to eq output[:month_of_year]
      end
    end

    context "aggregations" do
      it "should be able to count" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.minutes * t), score: t
        end

        expect( User.group_by_hour( "created_at", "count") ).to eq output[:count]
      end

      it "should be able to sum" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.minutes * t), score: t
        end

        expect( User.group_by_hour( "created_at", "sum", "score") ).to eq output[:sum]
      end

      it "should be able to avergage" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.minutes * t), score: t
        end

        expect( User.group_by_hour( "created_at", "avg", "score") ).to eq output[:average]
      end
    end

    context "conditions" do
      it "should be able to limit the range" do
        expect( User.count ).to eq(0)

        @t = Time.parse "2014-07-19 15:26:48 -0400"

        10.times do |t|
          User.create created_at: @t - (21.minutes * t)
        end

        expect( User.where( "created_at > ?", "2014-07-19 17:59:00 UTC").group_by_hour ).to eq output[:range]
      end


      it "should default to created_at" do
        expect( User.count ).to eq(0)

        @initial_time = Time.parse "2014-07-19 15:26:48 -0400"

        User.create created_at: @initial_time
        User.create created_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.week

        expect( User.count ).to eq( 4 )

        res = User.group_by_day

        expect(res).to eq output[:default]
      end

      it "should work with where clause" do
        expect( User.count ).to eq(0)

        @initial_time = Time.parse "2014-07-19 15:26:48 -0400"

        User.create created_at: @initial_time
        User.create created_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.week

        expect( User.count ).to eq( 4 )

        res = User.where( "created_at < ?", @initial_time ).group_by_day( :created_at )

        expect( res ).to eq output[:where]
      end

      it "should work with updated_at" do
        expect( User.count ).to eq(0)

        @initial_time = Time.parse "2014-07-19 15:26:48 -0400"

        User.create created_at: @initial_time, updated_at: @initial_time
        User.create created_at: @initial_time - 1.day, updated_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.day, updated_at: @initial_time - 1.day
        User.create created_at: @initial_time - 1.week, updated_at: @initial_time

        expect( User.count ).to eq( 4 )

        res = User.group_by_day( :updated_at )

        expect(res).to eq output[:updated_at]
      end
    end

  end
end
