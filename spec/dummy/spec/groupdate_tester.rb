RSpec.shared_examples "groupdate" do |config|

  before :context do
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

  before do
    Dateslices.output_format = :groupdate
    User.delete_all
  end

  context "groupings" do
    it "should return items grouped by second" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (t.seconds/2).to_i
      end

      expect( User.group_by_second ).to eq({
        "2014-07-19 19:26:44 UTC"  => 2,
        "2014-07-19 19:26:45 UTC"  => 2,
        "2014-07-19 19:26:46 UTC"  => 2,
        "2014-07-19 19:26:47 UTC"  => 2,
        "2014-07-19 19:26:48 UTC"  => 2})
    end

    it "should return items grouped by minute" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.seconds * t)
      end

      expect( User.group_by_minute ).to eq({
        "2014-07-19 19:23:00 UTC"  => 1,
        "2014-07-19 19:24:00 UTC"  => 3,
        "2014-07-19 19:25:00 UTC"  => 3,
        "2014-07-19 19:26:00 UTC"  => 3})
    end

    it "should return items grouped by hour" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.minutes * t)
      end

      expect( User.group_by_hour ).to eq({
        "2014-07-19 16:00:00 UTC"  => 3,
        "2014-07-19 17:00:00 UTC"  => 2,
        "2014-07-19 18:00:00 UTC"  => 3,
        "2014-07-19 19:00:00 UTC"  => 2})
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

      expect(res).to eq({
        "2014-07-12 00:00:00 UTC" => 1,
        "2014-07-18 00:00:00 UTC" => 2,
        "2014-07-19 00:00:00 UTC" => 1})
    end

    it "should return items grouped by week" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0000"

      8.times do |t|
        User.create created_at: @t - t.day
      end

      expect( User.group_by_week ).to eq({
        "2014-07-06 00:00:00 UTC"  => 1,
        "2014-07-13 00:00:00 UTC"  => 7})
    end

    it "should return items grouped by month" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - t.weeks
      end

      expect( User.group_by_month ).to eq({
        "2014-05-01 00:00:00 UTC"  => 3,
        "2014-06-01 00:00:00 UTC"  => 4,
        "2014-07-01 00:00:00 UTC"  => 3})
    end

    it "should return items grouped by year" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - t.months
      end

      expect( User.group_by_year ).to eq({
        "2013-01-01 00:00:00 UTC"  => 3,
        "2014-01-01 00:00:00 UTC"  => 7})
    end
  end

  context "collections" do
    it "should return items grouped by hour of day" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.minutes * t)
      end

      expect( User.group_by_hour_of_day ).to eq({
        "16"  => 3,
        "17"  => 2,
        "18"  => 3,
        "19"  => 2})
    end

    it "should return items grouped by day of week" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      8.times do |t|
        User.create created_at: @t - t.day
      end

      expect( User.group_by_day_of_week ).to eq({
        "0"  => 1,
        "1"  => 1,
        "2"  => 1,
        "3"  => 1,
        "4"  => 1,
        "5"  => 1,
        "6"  => 2})
    end

    it "should return items grouped by day of month" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-10 15:26:48 -0400"

      5.times do |t|
        User.create created_at: @t - (t*10).days
      end

      expect( User.group_by_day_of_month ).to eq({
        "10"=>2,
        "20"=>1,
        "30"=>1,
        "31"=>1})
    end

    it "should return items grouped by month of year" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-12-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - t.weeks
      end

      User.create created_at: @t - 12.months

      expect( User.group_by_month_of_year ).to eq({
        "10"  => 3,
        "11"  => 4,
        "12"  => 4})
    end
  end

  context "aggregations" do
    it "should be able to count" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.minutes * t), score: t
      end

      expect( User.group_by_hour( "created_at", "count") ).to eq({
      "2014-07-19 16:00:00 UTC" => 3,
      "2014-07-19 17:00:00 UTC" => 2,
      "2014-07-19 18:00:00 UTC" => 3,
      "2014-07-19 19:00:00 UTC" => 2})
    end

    it "should be able to sum" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.minutes * t), score: t
      end

      expect( User.group_by_hour( "created_at", "sum", "score") ).to eq({
        "2014-07-19 16:00:00 UTC" => 24,
        "2014-07-19 17:00:00 UTC" => 11,
        "2014-07-19 18:00:00 UTC" => 9,
        "2014-07-19 19:00:00 UTC" => 1})
    end

    it "should be able to avergage" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.minutes * t), score: t
      end

      expect( User.group_by_hour( "created_at", "avg", "score") ).to eq({
        "2014-07-19 16:00:00 UTC" => 8.0,
        "2014-07-19 17:00:00 UTC" => 5.5,
        "2014-07-19 18:00:00 UTC" => 3.0,
        "2014-07-19 19:00:00 UTC" => 0.5}
       )
    end
  end

  context "conditions" do
    it "should be able to limit the range" do
      expect( User.count ).to eq(0)

      @t = Time.parse "2014-07-19 15:26:48 -0400"

      10.times do |t|
        User.create created_at: @t - (21.minutes * t)
      end

      expect( User.where( "created_at > ?", "2014-07-19 17:59:00 UTC").group_by_hour ).to eq({
        "2014-07-19 18:00:00 UTC" => 3,
        "2014-07-19 19:00:00 UTC" => 2})
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

      expect(res).to eq({
        "2014-07-12 00:00:00 UTC"  => 1,
        "2014-07-18 00:00:00 UTC"  => 2,
        "2014-07-19 00:00:00 UTC"  => 1})
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

      expect( res ).to eq({
        "2014-07-12 00:00:00 UTC"  => 1,
        "2014-07-18 00:00:00 UTC"  => 2})
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

      expect(res).to eq({
        "2014-07-18 00:00:00 UTC"  => 2,
        "2014-07-19 00:00:00 UTC"  => 2})
    end
  end

end

