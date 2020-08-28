my_file = File.basename(__FILE__)

File.foreach(my_file) do |line|
  puts line
end