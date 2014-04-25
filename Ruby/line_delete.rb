#!/usr/bin/ruby

require 'fileutils'
require 'tempfile'

File.open("/home/karthikr/git_repo/test/extract", "w") do |out_file|
  File.foreach("/home/karthikr/git_repo/test/authorized_keys") do |line|
    out_file.puts line unless line.include? 'test'
  end
end

FileUtils.mv('/home/karthikr/git_repo/test/extract', '/home/karthikr/git_repo/test/authorized_keys')

# Open temporary file
#tmp = Tempfile.new("/home/karthikr/git_repo/test/extract")

# Write good lines to temporary file
#open('/home/karthikr/git_repo/test/authorized_keys', 'r').each { |l| tmp << l unless l.chomp == 'ha' }

# Close tmp, or troubles ahead
#tmp.close

# Move temp file to origin
#FileUtils.mv(tmp.path, '/home/karthikr/git_repo/test/authorized_keys')