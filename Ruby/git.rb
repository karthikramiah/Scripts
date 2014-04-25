#!/usr/bin/ruby

require 'fileutils'
require 'tempfile'

master_file = "/home/karthikr/git_repo/test/authorized_keys"

print "Do you want to add or delete SSH keys [Add/Delete]: "

input = gets.chomp

if "#{input}" == 'Add'
	
	puts "Enter the path of the pub key file"
	
	key_file = gets.chomp 
	
	to_append = File.read("#{key_file}")
	
	File.open("#{master_file}", "a") do |handle|
	
	  handle.puts to_append
	
	end	

else
	
	print "Enter the username for which the key has to be deleted:"

	$user_key = gets.chomp

	tmp_file = "/home/karthikr/git_repo/test/extract"

	File.open("#{tmp_file}", "w") do |out_file|
  
  		File.foreach("#{master_file}") do |line|
    
    		out_file.puts line unless line.include? $user_key
  		
  		end
	end

FileUtils.mv("#{tmp_file}", "#{master_file}")

end

#FileUtils::mkdir_p '/home/karthikr/git_repo'
#Dir.chdir "/home/karthikr/git_repo"
##FileUtils::cd '/home/karthikr/git_repo/test'
#system('git clone git@github.com:karthikramiah/test.git')
#puts exec('pwd')
##system('git add -A')
##system('git commit -m "mymessage"')
##system('git push --all')
#puts exec('git version')