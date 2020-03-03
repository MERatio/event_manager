# frozen_string_literal: true

# Time targeting for advertisement
module TimeTargeting
  require 'csv'

  def self.most_dates(dates)
    dates.select { |_key, value| value == dates.values.max }
  end

  def self.hours_or_days(unit)
    contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
    hours_or_days = Hash.new(0)
    contents.each do |row|
      reg_date = row[:regdate]
      date = DateTime.strptime(reg_date, '%m/%d/%y %k:%M')
      hour_or_day = unit == 'hours' ? date.hour : date.wday
      hours_or_days[hour_or_day] += 1
    end
    hours_or_days
  end

  def self.target_hours
    most_dates(hours_or_days('hours')).keys.join(', ')
  end

  def self.target_week_days
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    most_dates(hours_or_days('week days')).keys.map { |day| days[day] }.join(', ')
  end

  def self.report
    "Target hours: #{target_hours}\nTarget week days: #{target_week_days}"
  end
end
