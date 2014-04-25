#!/usr/bin/ruby

require 'fileutils'

master_file = "/home/karthikr/git_repo/test/authorized_keys" ##Customizable

print "Do you want to add or delete SSH keys [Add/Delete]: "

input = gets.chomp

## Add pub keys to the authorized keys file

if "#{input}" == 'Add' || "#{input}" == 'add'
	
	print "Enter the path of the pub key file:"
	
	key_file = gets.chomp 

	if File.exist?("#{key_file}")

			to_append = File.read("#{key_file}")
	
			File.open("#{master_file}", "a") do |handle|
	
	  			handle.puts to_append
	
			end

	else

		puts "Key File is missing.Exiting the script..."

		exit

	end	

else
	
	## Deleting ssh keys from the master file

	print "Enter the username for which the key has to be deleted:"

	$user_key = gets.chomp

	tmp_file = "/home/karthikr/git_repo/test/extract" ##Customizable

	File.open("#{tmp_file}", "w") do |out_file|
  
  		File.foreach("#{master_file}") do |line|
    
    		out_file.puts line unless line.include? $user_key
  		
  		end
	end

	FileUtils.mv("#{tmp_file}", "#{master_file}")

end

## Commiting changes to git repo

FileUtils::cd '/home/karthikr/git_repo/test' ##Customizable

print "Enter the message for commiting the change:"

message = gets.chomp

system('git add -A')

`git commit -m ""#{message}""`

system('git push --all')