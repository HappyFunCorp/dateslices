RSpec.shared_examples "dateslice" do |config|
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

    # ActiveRecord::Migration.create_table :posts, :force => true do |t|
    #   t.references :user
    #   t.timestamp :created_at
    # end
  end

  before do
    User.delete_all
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

  it "should return items grouped by week" do
    expect( User.count ).to eq(0)

    @t = Time.parse "2014-07-19 15:26:48 -0000"

    User.create created_at: @t
    User.create created_at: @t - 1.day
    User.create created_at: @t - 2.day
    User.create created_at: @t - 3.day
    User.create created_at: @t - 4.day
    User.create created_at: @t - 5.day
    User.create created_at: @t - 6.day
    User.create created_at: @t - 7.day


    expect( User.group_by_week ).to eq({
      "2014-07-06 00:00:00 UTC"  => 1,
      "2014-07-13 00:00:00 UTC"  => 7})
  end
  it "should return items grouped by day of week" do
    expect( User.count ).to eq(0)

    @t = Time.parse "2014-07-19 15:26:48 -0400"

    User.create created_at: @t
    User.create created_at: @t - 1.day
    User.create created_at: @t - 2.day
    User.create created_at: @t - 3.day
    User.create created_at: @t - 4.day
    User.create created_at: @t - 5.day
    User.create created_at: @t - 6.day
    User.create created_at: @t - 7.day

    expect( User.group_by_day_of_week ).to eq({
      "0"  => 1,
      "1"  => 1,
      "2"  => 1,
      "3"  => 1,
      "4"  => 1,
      "5"  => 1,
      "6"  => 2})
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

  it "should return items grouped by month" do
    expect( User.count ).to eq(0)

    @t = Time.parse "2014-07-19 15:26:48 -0400"

    10.times do |t|
      User.create created_at: @t - t.months
    end

    expect( User.group_by_year ).to eq({
      "2013-01-01 00:00:00 UTC"  => 3,
      "2014-01-01 00:00:00 UTC"  => 7})
  end

  it "should return items group by second" do
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

  it "should return items group by minute" do
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

  it "should return items group by hour" do
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
end


# class User < ActiveRecord::Base
# end
