# Break down each minutes requests by path.
#
# Example:
#
# {"2014-10-13-9:03"=> {"/posts" => 1, "/posts/new" => 5},
# "2014-10-13-9:04"=> {"/posts" => 1, "/posts/9/edit" => 5},
# "2014-10-13-9:05"=> {"/posts/new" => 1, "" => 5}}

require 'open-uri'
require 'time'
require 'date'

class LogParser
  attr_accessor :file, :parsed_times, :request_hash, :paths, :dates, :log_file

  def initialize(file)
    @file = file
    @dates= []
    @parsed_times = []
    @log_file = open(@file) {|f| f.read }
    @request_hash = {}
    @paths = []
  end

  def count_words
    @log_file.scan(/\w+/).count("Started")
  end

  def get_dates
    @dates = @log_file.scan(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\s-\d{4}/)
  end

  def parse_dates
    @dates.each do |date|
      @parsed_times << DateTime.parse(date).strftime("%Y-%m-%d-%H:%M")
    end
  end

  def make_hash
    @parsed_times.each do |time|
      @request_hash[time] = @parsed_times.grep(time).count
    end
  end

  def get_paths
    @paths = @log_file.scan(/GET\s"\/.*"/)
  end

  def format_paths
    @paths.each do |path|
      path.delete! "GET "
    end
  end

end

new_parse = LogParser.new('https://raw.githubusercontent.com/Ada-Developers-Academy/daily-curriculum/master/moar_work/log-parser/sample.log')
new_parse.get_dates
new_parse.parse_dates
new_parse.make_hash
new_parse.request_hash
new_parse.get_paths
new_parse.format_paths
puts new_parse.paths

#gold complete
