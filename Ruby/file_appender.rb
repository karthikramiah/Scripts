#!/usr/bin/ruby

to_append = File.read("foo.txt")
File.open("bar.txt", "a") do |handle|
  handle.puts to_append
end