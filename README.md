# Countdown

[![Crystal CI](https://github.com/mamantoha/countdown-crystal/actions/workflows/crystal.yml/badge.svg?branch=main)](https://github.com/mamantoha/countdown-crystal/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/mamantoha/countdown-crystal.svg)](https://github.com/mamantoha/countdown-crystal/releases)
[![License](https://img.shields.io/github/license/mamantoha/countdown-crystal.svg)](https://github.com/mamantoha/countdown-crystal/blob/master/LICENSE)

A simple Crystal library for calculating and producing an accurate, intuitive description of the timespan between two `Time` instances.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     countdown:
       github: mamantoha/countdown-crystal
   ```

2. Run `shards install`

## Features

- Handles leap years, varying month lengths, timezone differences.
- Generates human-readable strings representing the timespan.
- Provides easy access to individual components (years, months, days, hours, minutes, seconds) of the timespan.

## Usage

```crystal
require "countdown"

start_time = Time.local(2023, 12, 31, 23, 59)
end_time = Time.local(2024, 2, 29, 12, 30)

countdown = Countdown.new(start_time, end_time)
puts countdown.components  # => {years: 0, months: 1, days: 28, hours: 12, minutes: 31, seconds: 0}
puts countdown.to_s        # => "1 month, 28 days, 12 hours and 31 minutes"
```

```crystal
require "countdown"

Time::Location.local = Time::Location.load("Europe/Kyiv")

start_time = Time.local(2022, 3, 27, 2, 59)
# => 2022-03-27 02:59:00.0 +02:00 Local

end_time = Time.local(2022, 3, 28, 3, 0)
# => 2022-03-28 03:00:00.0 +03:00 Local

countdown = Countdown.new(start_time, end_time)

countdown.components
# => {years: 0, months: 0, days: 1, hours: 1, minutes: 1, seconds: 0}

countdown.to_s
# => "1 day, 1 hour and 1 minute"

countdown.to_s(oxford_comma: true)
# => "1 day, 1 hour, and 1 minute"
```

## The Algorithm

The `Countdown` library calculates the difference between two dates in a way that feels natural and consistent. It treats "a month from now" as "the same date next month," ensuring smooth, predictable countdowns without sudden jumps.

The library works like basic subtraction, adjusting for time units (seconds, minutes, hours, days, months, years) as needed. Since months have different numbers of days, `Countdown` carefully tracks each month to provide accurate results.

## Time Zones & Daylight Saving Time

`Countdown` also handles time zone differences and daylight saving time changes, ensuring that your countdowns are accurate regardless of the time zone or DST shifts between the start and end dates.

## Inspiration

This library was inspired by Countdown.js. While the idea was taken from [Countdown.js](https://countdownjs.org/), no code was reused, and this implementation was developed entirely from scratch.

## Contributing

1. Fork it (<https://github.com/mamantoha/countdown-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
