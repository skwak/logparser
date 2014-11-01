require 'open-uri'
require 'time'
require 'date'

class LogParser
  attr_accessor :file, :times, :parsed_times, :request_hash

  def initialize(file)
    @file = file
    @dates= []
    @parsed_times = []
    @log_file = open(@file) {|f| f.read }
    @request_hash = {}
  end

  def count_words
    @log_file.scan(/\w+/).count("Started")
  end

  def get_dates
    @dates = @log_file.scan(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\s-\d{4}/)
  end

  def parse_dates
    @dates.each do |date|
      @parsed_times << DateTime.parse(date).strftime("%s")
    end
  end

  def make_hash
    @parsed_times.each do |time|
      @request_hash[time] = @parsed_times.grep(time).count
    end

  end

end

new_parse = LogParser.new('https://raw.githubusercontent.com/Ada-Developers-Academy/daily-curriculum/master/moar_work/log-parser/sample.log')
# puts new_parse.count_words 1200, bronze complete
new_parse.get_dates
new_parse.parse_dates
new_parse.make_hash
# puts new_parse.request_hash, silver complete
