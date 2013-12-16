#!/usr/bin/env ruby
#
# Grab random line from file

if ARGV[0].nil? 
  puts "Usage: random_line.rb <file_name>"
  puts "Need to have a file name to pull from. Exiting."
  exit 1
end

random_line = nil
number = 0
begin
  file = File.open(ARGV[0]).read
  #File.foreach(ARGV[0], 'r').each_with_index do |line, number|
  file.each_line do |line|
    number += 1
    if rand < 1.0/(number + 1)
#      puts "Replacing '#{random_line}' with '#{line}'"
      random_line = line.chomp
    end
  end
rescue => err
  puts "Exception: #{err}"
  err
  exit 1
end
puts random_line
