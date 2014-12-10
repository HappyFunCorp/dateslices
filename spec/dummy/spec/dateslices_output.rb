def dateslices_output
  {
    second: [
        {:date_slice=>"2014-07-19 19:26:44 UTC", :count=>2},
        {:date_slice=>"2014-07-19 19:26:45 UTC", :count=>2},
        {:date_slice=>"2014-07-19 19:26:46 UTC", :count=>2},
        {:date_slice=>"2014-07-19 19:26:47 UTC", :count=>2},
        {:date_slice=>"2014-07-19 19:26:48 UTC", :count=>2}],
    minute: [
        {:date_slice=>"2014-07-19 19:23:00 UTC", :count=>1},
        {:date_slice=>"2014-07-19 19:24:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 19:25:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 19:26:00 UTC", :count=>3}],
    hour: [
        {:date_slice=>"2014-07-19 16:00:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 17:00:00 UTC", :count=>2},
        {:date_slice=>"2014-07-19 18:00:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 19:00:00 UTC", :count=>2}],
    day: [
        {:date_slice=>"2014-07-12 00:00:00 UTC", :count=>1},
        {:date_slice=>"2014-07-18 00:00:00 UTC", :count=>2},
        {:date_slice=>"2014-07-19 00:00:00 UTC", :count=>1}],
    week: [
        {:date_slice=>"2014-07-06 00:00:00 UTC", :count=>1},
        {:date_slice=>"2014-07-13 00:00:00 UTC", :count=>7}],
    month: [
        {:date_slice=>"2014-05-01 00:00:00 UTC", :count=>3},
        {:date_slice=>"2014-06-01 00:00:00 UTC", :count=>4},
        {:date_slice=>"2014-07-01 00:00:00 UTC", :count=>3}],
    year: [
        {:date_slice=>"2013-01-01 00:00:00 UTC", :count=>3},
        {:date_slice=>"2014-01-01 00:00:00 UTC", :count=>7}],
    hour_of_day: [
        {:date_slice=>"16", :count=>3},
        {:date_slice=>"17", :count=>2},
        {:date_slice=>"18", :count=>3},
        {:date_slice=>"19", :count=>2}],
    day_of_week: [
        {:date_slice=>"0", :count=>1},
        {:date_slice=>"1", :count=>1},
        {:date_slice=>"2", :count=>1},
        {:date_slice=>"3", :count=>1},
        {:date_slice=>"4", :count=>1},
        {:date_slice=>"5", :count=>1},
        {:date_slice=>"6", :count=>2}],
    day_of_month: [
        {:date_slice=>"10", :count=>2},
        {:date_slice=>"20", :count=>1},
        {:date_slice=>"30", :count=>1},
        {:date_slice=>"31", :count=>1}],
    month_of_year: [
        {:date_slice=>"10", :count=>3},
        {:date_slice=>"11", :count=>4},
        {:date_slice=>"12", :count=>4}
    ],
    count: [
        {:date_slice=>"2014-07-19 16:00:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 17:00:00 UTC", :count=>2},
        {:date_slice=>"2014-07-19 18:00:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 19:00:00 UTC", :count=>2}
    ],
    sum: [
        {:date_slice=>"2014-07-19 16:00:00 UTC", :sum=>24},
        {:date_slice=>"2014-07-19 17:00:00 UTC", :sum=>11},
        {:date_slice=>"2014-07-19 18:00:00 UTC", :sum=>9},
        {:date_slice=>"2014-07-19 19:00:00 UTC", :sum=>1}
    ],
    average: [
        {:date_slice=>"2014-07-19 16:00:00 UTC", :avg=>8.0},
        {:date_slice=>"2014-07-19 17:00:00 UTC", :avg=>5.5},
        {:date_slice=>"2014-07-19 18:00:00 UTC", :avg=>3.0},
        {:date_slice=>"2014-07-19 19:00:00 UTC", :avg=>0.5}
    ],
    range: [
        {:date_slice=>"2014-07-19 18:00:00 UTC", :count=>3},
        {:date_slice=>"2014-07-19 19:00:00 UTC", :count=>2}
    ],
    default: [
        {:date_slice=>"2014-07-12 00:00:00 UTC", :count=>1},
        {:date_slice=>"2014-07-18 00:00:00 UTC", :count=>2},
        {:date_slice=>"2014-07-19 00:00:00 UTC", :count=>1}
    ],
    where: [
        {:date_slice=>"2014-07-12 00:00:00 UTC", :count=>1},
        {:date_slice=>"2014-07-18 00:00:00 UTC", :count=>2}
    ],
    updated_at: [
        {:date_slice=>"2014-07-18 00:00:00 UTC", :count=>2},
        {:date_slice=>"2014-07-19 00:00:00 UTC", :count=>2}
    ]
  }
end
