#!/usr/bin/ruby

if File.exist?('/home/karthikr/git_repo/test/authorized_keys.bak')
	puts "File exists"
else
	puts "File is missing"
end
	