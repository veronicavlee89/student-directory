@width = 160

def input_students
  puts "Please enter the information of the students".center(@width)
  puts "To finish, just hit return when prompted for a student name".center(@width)
  puts ""
  # create an empty array
  students = []
  # get the first name
  puts "Enter student's name".center(@width)
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    height = '0'
    # get height that is numeric digits only and is > 0
    until /\A\d+\z/.match(height) && height.to_i > 0
      puts "Enter #{name}'s height (in cm)".center(@width)
      height = gets.chomp
    end
    # add the student hash to the array
    students << {name: name, height: height, cohort: :november}
    puts "Now we have #{students.count} students".center(@width)
    # get another name from the user
    puts "Enter next student's name".center(@width)
    name = gets.chomp
  end
  # return the array of students
  students
end

def print_header
  puts "The students of Villains Academy".center(@width)
  puts "-------------".center(@width)
end

def print(students)
  i = 0
  until i == students.length do
    if students[i][:name][0].upcase == "V" && students[i][:name].length < 12
      puts "#{i+1}. #{students[i][:name]}, #{students[i][:height]}cm (#{students[i][:cohort]} cohort)".center(@width)
    end
    i += 1
  end
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students".center(@width)
end

students = input_students
print_header
print(students)
print_footer(students)