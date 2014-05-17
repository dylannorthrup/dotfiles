#!/usr/bin/ruby
#
# Run to rip dvd using HandBrakeCLI

require 'open3'

# Some variables we'll be using later
dvdpath = 'UNSET'
dvdname = 'UNSET'
outputdir = "/Users/docx/temp/handbrake"
#outputdir = "/Volumes/Media/Movies/handbrake"
#outputdir = "/Volumes/Public/Shared_Videos/handbrake"

# Let's figure out what the actual DVD is.  
drutil_cmd = "drutil status"
Open3.popen3(drutil_cmd) do |stdin, stdout, stderr, wait_thr|
  output = stdout.readlines
  output.each do |line|
    next unless line =~ /^\s+Type: DVD-ROM/
    dvdpath = line.split[-1]
  end
end

# We also want to get the title of the disk for later.
drutil_cmd = "diskutil list #{dvdpath}"
Open3.popen3(drutil_cmd) do |stdin, stdout, stderr, wait_thr|
  output = stdout.readlines
  output.each do |line|
    next unless line =~ /^\s+0:/
    dvdname = line.split[1]
  end
end

# Something to "uniqueify" the DVD name
now = Time.now.strftime("%Y-%m-%d-%H-%M")
dvdname = "#{dvdname}_#{now}"
puts "DVD Path is '#{dvdpath}' and name is '#{dvdname}'"

# Do a quick sanity check before proceeding
if dvdpath =~ /UNSET/ or dvdname =~ /UNSET/
  puts "*** WARNING ***"
  puts "*** WARNING ***"
  puts "*** WARNING ***"
  puts "Either dvd path, dvd name or both are unset. Cannot continue without this information"
  puts "Exiting"
  exit
end

puts "=== Extracting track information ==="
handbrake_info_cmd = "/usr/local/bin/HandBrakeCLI -t 0 --min-duration 30 --input #{dvdpath}"
hb_out = Array.new
Open3.popen3(handbrake_info_cmd) do |stdin, stdout, stderr, wait_thr|
  hb_out = stderr.readlines
end

puts "=== Parsing extracted track information ==="

# Ok, we've got the stderr output listing tracks along with their subtitles and audio tracks
# Let's parse that out
titles = Hash.new
titles['audio'] = Array.new
titles['subtitle'] = Array.new
titles['not_set'] = Array.new

current_title = 0
in_audio = false
in_subtitle = false
hb_out.each do |line| 
  next if line.nil?
  # Added to deal with invalid UTF-8 characters that cause an exception in the following regex
  line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  next unless line =~ /^\s*\+ (.*)/
  match = $1
  if in_audio or in_subtitle
#    puts "*** in_audio is #{in_audio} and in_subtitle is #{in_subtitle}"
    section = 'not_set'
    if in_audio
      section = 'audio'
    elsif in_subtitle
      section = 'subtitle'
    end
#    puts "=== Checking '#{match}' for numeracy"
    if match =~ /^(\d+),/
#      puts "Adding #{$1} to #{section} contents"
      titles[section][current_title] += $1 + ","
    else
      titles[section][current_title].gsub!(/,$/, '')
#      puts "*** Setting in_{audio,subtitle} to false (#{section} - #{current_title})"
      in_audio = false
      in_subtitle = false
    end
  end
  case match
    when /title (\d+)/
      current_title = $1.to_i
      in_audio = false
      in_subtitle = false
    when /audio tracks:/
      titles['audio'][current_title] = ""
      in_audio = true
      in_subtitle = false
    when /subtitle tracks:/
      titles['subtitle'][current_title] = ""
      in_audio = false
      in_subtitle = true
    else
      titles['not_set'][current_title] = ""
  end
#  puts line
end

# Go ahead and print out what we'll be doing (for information's sake)
puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
puts "=-=-= Parsing Complete. Parsed information is as follows  =-=-=-="
titles['audio'].each_index { |index|
  next if titles['audio'][index].nil?
  puts "===== Title #{index} with audio tracks of #{titles['audio'][index]} and subtitle tracks of #{titles['subtitle'][index]}"
}
puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
puts "=-=-= Proceeding to extract the noted tracks              =-=-=-="
puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

# Now, iterate through the audio titles (since every track of interest should have an audio
# title) and start extracting
titles['audio'].each_index { |index|
  next if titles['audio'][index].nil?
  puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
  puts "===== Title #{index} with audio tracks of #{titles['audio'][index]} and subtitle tracks of #{titles['subtitle'][index]}"
  # Only ask for subtitles if they're present
  subtitle_bits = ""
  if titles['subtitle'][index].nil? or titles['subtitle'][index] =~ /^\s*$/
    puts "===== No subtitle bits"
  else
    puts "===== Adding on subtitle bits"
    subtitle_bits = "--subtitle #{titles['subtitle'][index]}"
  end
  handbrake_extract_cmd = "/usr/local/bin/HandBrakeCLI -t #{index} -m --decomb --preset Normal --audio #{titles['audio'][index]} #{subtitle_bits} --input #{dvdpath} --output '#{outputdir}/#{dvdname}-#{index}.m4v'"
  puts "Extracting with the following command: ---> #{handbrake_extract_cmd} <---"
  `#{handbrake_extract_cmd}`
}

# And, finally, eject the DVD
`drutil eject`
