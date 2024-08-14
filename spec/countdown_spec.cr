require "./spec_helper"

describe Countdown do
  it "has version" do
    Countdown::VERSION.should_not be_nil
  end

  it "works" do
    start_time = Time.local(2022, 2, 24, 3, 40)
    end_time = Time.local(2024, 8, 14, 15, 55)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 2, months: 5, days: 18, hours: 13, minutes: 15, seconds: 0})
  end

  it "handle summer time" do
    start_time = Time.local(2022, 3, 27, 2, 59)
    end_time = Time.local(2022, 3, 28, 2, 59)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 1, hours: 1, minutes: 0, seconds: 0})
  end

  it "handle winter time" do
    start_time = Time.local(2022, 10, 30, 2, 59)
    end_time = Time.local(2022, 10, 30, 4, 0)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 0, hours: 0, minutes: 1, seconds: 0})
  end

  it "calculates time difference within the same day" do
    start_time = Time.local(2024, 2, 29, 10, 15)
    end_time = Time.local(2024, 2, 29, 12, 30)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 0, hours: 2, minutes: 15, seconds: 0})
  end

  it "calculates full year difference" do
    start_time = Time.local(2023, 1, 1)
    end_time = Time.local(2024, 1, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 1, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates difference across February in a leap year" do
    start_time = Time.local(2024, 2, 28)
    end_time = Time.local(2024, 3, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 2, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates time difference across multiple years" do
    start_time = Time.local(2020, 6, 15)
    end_time = Time.local(2023, 6, 14)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 2, months: 11, days: 29, hours: 0, minutes: 0, seconds: 0})
  end

  it "handles time difference crossing daylight saving time" do
    start_time = Time.local(2023, 3, 12, 1, 59)
    end_time = Time.local(2023, 3, 12, 3, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 0, hours: 1, minutes: 2, seconds: 0})
  end

  it "calculates difference from one year-end to another year’s start" do
    start_time = Time.local(2023, 12, 31)
    end_time = Time.local(2024, 1, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates correct difference crossing December to February" do
    start_time = Time.local(2023, 12, 31)
    end_time = Time.local(2024, 2, 29)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 1, days: 29, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates time difference from end of one month to the beginning of the next month" do
    start_time = Time.local(2024, 1, 31)
    end_time = Time.local(2024, 2, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates time difference from February 29th in a leap year to March 1st" do
    start_time = Time.local(2024, 2, 29)
    end_time = Time.local(2024, 3, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates exact year and day difference" do
    start_time = Time.local(2023, 6, 1)
    end_time = Time.local(2024, 6, 2)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 1, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates difference from a month with 31 days to a month with 30 days" do
    start_time = Time.local(2023, 7, 31)
    end_time = Time.local(2023, 9, 1)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 1, days: 1, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates time difference from the beginning of one year to the end of the same year" do
    start_time = Time.local(2023, 1, 1)
    end_time = Time.local(2023, 12, 31)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 11, days: 30, hours: 0, minutes: 0, seconds: 0})
  end

  it "calculates difference between the same date and time but across two years" do
    start_time = Time.local(2022, 3, 15, 14, 30)
    end_time = Time.local(2023, 3, 15, 14, 30)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 1, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0})
  end

  it "issue 1" do
    start_time = Time.local(2024, 8, 15)
    end_time = Time.local(2024, 9, 16)

    countdown = Countdown.new(start_time, end_time)

    countdown.components.should eq({years: 0, months: 1, days: 1, hours: 0, minutes: 0, seconds: 0})
  end

  it "start should be before end time" do
    expect_raises Countdown::Exception, "Start should be before end time" do
      start_time = Time.local(2024, 1, 1)
      end_time = Time.local(2023, 1, 1)

      Countdown.new(start_time, end_time)
    end
  end

  it "start end time should have the same offset" do
    expect_raises Countdown::Exception, "Start and end time must have the same Time::Location" do
      start_time = Time.local(2023, 1, 1, location: Time::Location.load("Europe/Kyiv"))
      end_time = Time.utc(2024, 1, 1)

      Countdown.new(start_time, end_time)
    end
  end
end
