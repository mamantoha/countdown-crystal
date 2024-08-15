# A simple Crystal API for producing an accurate, intuitive description of the timespan between two `Time` instances.
class Countdown
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  # :nodoc
  class Exception < Exception
  end

  getter components : NamedTuple(years: Int32, months: Int32, days: Int32, hours: Int32, minutes: Int32, seconds: Int32)

  def initialize(start_time : Time, end_time : Time)
    raise Exception.new("Start and end time must have the same Time::Location") if start_time.location != end_time.location
    raise Exception.new("Start should be before end time") if start_time > end_time

    @components = calculate_difference(start_time, end_time)
  end

  {% for component in ["years", "months", "days", "hours", "minutes", "seconds"] %}
    private def {{ component.id }}
      components[:{{ component.id }}]
    end
  {% end %}

  private def calculate_difference(start_time : Time, end_time : Time)
    years = end_time.year - start_time.year
    months = end_time.month - start_time.month
    days = end_time.day - start_time.day
    hours = end_time.hour - start_time.hour
    minutes = end_time.minute - start_time.minute
    seconds = end_time.second - start_time.second

    timezone_difference = (end_time.offset - start_time.offset) // 3600
    hours += timezone_difference

    if seconds < 0
      seconds += 60
      minutes -= 1
    end

    if minutes < 0
      minutes += 60
      hours -= 1
    end

    if hours < 0
      hours += 24
      days -= 1
    end

    if days < 0
      days += Time.days_in_month(start_time.year, start_time.month)
      months -= 1
    end

    if months < 0
      months += 12
      years -= 1
    end

    {years: years, months: months, days: days, hours: hours, minutes: minutes, seconds: seconds}
  end

  def to_s(*, oxford_comma = false, include_seconds = false) : String
    parts = [] of String

    parts << "#{years} year#{'s' unless years == 1}" if years > 0
    parts << "#{months} month#{'s' unless months == 1}" if months > 0
    parts << "#{days} day#{'s' unless days == 1}" if days > 0
    parts << "#{hours} hour#{'s' unless hours == 1}" if hours > 0
    parts << "#{minutes} minute#{'s' unless minutes == 1}" if minutes > 0
    parts << "#{seconds} second#{'s' unless seconds == 1}" if include_seconds && minutes > 0

    if parts.size > 1
      last = parts.pop

      and_part = oxford_comma ? ", and" : " and"

      "#{parts.join(", ")}#{and_part} #{last}"
    else
      parts.join
    end
  end
end
