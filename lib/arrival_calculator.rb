require 'time'

module ArrivalCalculator
  TWELVE_HOURS = 12 * 60 * 60
  TWENTY_FOUR_HOURS = 24 * 60 * 60

  # Average time of day expects array such as ['11:00am', '1:00pm'] => '12:00pm'
  def average_time_of_day(times)
    times_in_seconds = times.map do | time |
      raise ArgumentError, "Unexpected time format " + time unless time.strip =~ /^[01]?\d:\d\d(am|pm)$/
      Time.parse(time + " UTC", Time.at(0).utc).to_i # "12:00am" => 0 seconds
    end
    avg = average(coerce_split_day_times(times_in_seconds))
    Time.at(avg).utc.strftime('%l:%M%p').downcase.strip
  end

  # Coerce AM times to next day for split day arrivals
  def coerce_split_day_times(times_in_seconds)
    am_times, pm_times = [], []
    times_in_seconds.each { | time | ((time < TWELVE_HOURS)? am_times : pm_times) << time }
    if am_times.any? && pm_times.any? && average(pm_times) - average(am_times) > TWELVE_HOURS
      am_times.map! { | time | time + TWENTY_FOUR_HOURS }
    end
    am_times + pm_times
  end

  # Returns the arithmetic mean of the contents of the array
  def average(numbers)
    numbers.inject(0.0) { | sum, seconds | sum + seconds } / numbers.size
  end
end