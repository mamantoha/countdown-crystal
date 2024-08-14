# A simple Crystal API for producing an accurate, intuitive description of the timespan between two `Time` instances.
class Countdown
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  getter components : NamedTuple(years: Int32, months: Int32, days: Int32, hours: Int32, minutes: Int32, seconds: Int32)

  def initialize(start_time : Time, end_time : Time)
    raise "Start should be before end time" if start_time > end_time

    @components = calculate_difference(start_time, end_time)
  end

  def to_s(*, oxford_comma = false, include_seconds = false) : String
    parts = [] of String

    parts << "#{components[:years]} year#{'s' unless components[:years] == 1}" if components[:years] > 0
    parts << "#{components[:months]} month#{'s' unless components[:months] == 1}" if components[:months] > 0
    parts << "#{components[:days]} day#{'s' unless components[:days] == 1}" if components[:days] > 0
    parts << "#{components[:hours]} hour#{'s' unless components[:hours] == 1}" if components[:hours] > 0
    parts << "#{components[:minutes]} minute#{'s' unless components[:minutes] == 1}" if components[:minutes] > 0
    parts << "#{components[:seconds]} second#{'s' unless components[:seconds] == 1}" if include_seconds && components[:minutes] > 0

    if parts.size > 1
      last = parts.pop

      and_part = oxford_comma ? ", and" : " and"
      "#{parts.join(", ")}#{and_part} #{last}"
    else
      parts.join
    end
  end

  private def calculate_difference(start_time : Time, end_time : Time)
    years = end_time.year - start_time.year
    months = end_time.month - start_time.month
    days = end_time.day - start_time.day
    hours = end_time.hour - start_time.hour
    minutes = end_time.minute - start_time.minute
    seconds = end_time.second - start_time.second

    # Adjust for timezone offset differences
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
end
