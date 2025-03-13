#!/usr/bin/env ruby
#
# Grab random line from file

if ARGV[0].nil?
  puts "Usage: random_line.rb <file_name>"
  puts "Need to have a file name to pull from. Exiting."
  exit 1
end

random_line = ""
random_num = 0
number = 0
begin
  file = File.open(ARGV[0]).read
  # File.foreach(ARGV[0], 'r').each_with_index do |line, number|
  file.each_line do |line|
    line.chomp!
    # puts "Testing line for comments: '#{line}' (number: #{number})"
    next if line =~ %r{^#}  # Skip comments
    # puts "No comments found"
    random_num = rand
    #puts "Random number is #{random_num}"
    if random_num < 1.0/(number + 1)
      #puts "Replacing '#{random_line}' with '#{line}'"
      random_line = line.chomp
    else
      #puts "#{random_num} is supposedly < #{1.0/(number + 1)}"
    end
    number += 1
  end
rescue => err
  puts "Exception: #{err}"
  raise err
  exit 1
end
puts random_line
