require 'date'

@students = []
@default_file = "students.csv"

##
# Loads students from file on program start up, if applicable.

def try_load_students
  filename = (ARGV.first.nil? ? @default_file : ARGV.first)
  if File.exists?(filename)
    load_students(filename)
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

##
# Controls the interactive menu

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

##
# Prints the interactive menu options

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save student list to file"
  puts "4. Load student list from file"
  puts "9. Exit"
end

##
# Processes action based on user's menu selection

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    puts "-- Save student list to file --"
    filename = input_filename
    save_students(filename) if filename.nil? == false
  when "4"
    puts "-- Load student list from file --"
    filename = input_filename
    load_students(filename) if filename.nil? == false
  when "9"
    puts "Exiting program.. bye!"
    exit
  else
    puts "I don't know what you meant, try again"
  end
  puts "----------"
end

##
# Gets a filename input from the user. Validates file exists.
# Defaults if no file entered.

def input_filename
  puts "Enter filename. Hit return to use #{@default_file}"
  filename = STDIN.gets.chomp
  if filename.empty?
    @default_file
  elsif File.exists?(filename)
    filename
  else
    puts "Sorry, #{filename} doesn't exist."
    nil
  end
end

##
# Collects student information from user including name, height and cohort.

def input_students
  print_input_header
  name = input_name
  while name.empty? == false do
    add_student(name, input_height(name), input_cohort(name))
    log "Now we have #{@students.count} #{@students.count == 1 ?
                                           "student" : "students"}"
    name = input_name
  end
end

##
# Prints the student information

def show_students
  print_header
  print_students_list
  print_footer
end

##
# Saves student list to a file

def save_students(filename = @default_file)
  file = File.open(filename, "w") { |f|
    @students.each do |student|
      student_data = [student[:name], student[:height], student[:cohort]]
      f.puts student_data.join(",")
    end
  }
end

##
# Loads students from a file, appending to the existing student list.

def load_students(filename = @default_file)
  file = File.open(filename, "r") { |f|
    f.each_line do |line|
      name, height, cohort = line.chomp.split(',')
      add_student(name, height, cohort)
    end
  }
  puts "Loaded #{@students.count} students from #{filename}"
end

##
# Adds a student to the students list

def add_student(name, height, cohort)
  @students << {name: name, height: height, cohort: cohort.downcase.to_sym}
end

##
# Prints introduction to the student input process

def print_input_header
  log "Please enter the information of the students"
  log "To finish, just hit return when prompted for a student name"
  log "---"
end

##
# Gets student name as input. Can be an empty string.

def input_name
  log "Enter student's name"
  STDIN.gets.chomp
end

##
# Gets student height as input. Must be numeric digits only and > 0

def input_height(student_name)
  height = '0'
  until /\A\d+\z/.match(height) && height.to_i > 0
    log "Enter #{student_name}'s height (in cm)"
    height = STDIN.gets.chomp
  end
  height
end

##
# Gets student cohort as input. Must be a month.
# Defaults cohort to current month if none provided.

def input_cohort(student_name)
  cohort = ""
  default_cohort = Date::MONTHNAMES[Date.today.month]
  until Date::MONTHNAMES.include? cohort.capitalize
    log "Enter #{student_name}'s cohort. Hit return to set to #{default_cohort}"
    cohort = STDIN.gets.chomp
    cohort = default_cohort if cohort == ""
  end
  cohort
end

##
# Prints a header for the Villains Academy student list

def print_header
  log "The students of Villains Academy"
  log "-------------"
end

##
# Prints a list of students of Villains Academy, ordered by cohort month.
# Information includes student name, height and cohort.

def print_students_list
  return if @students.count == 0
  @students.sort_by! { |student| Date::MONTHNAMES.index(student[:cohort].to_s.capitalize) }
  @students.each_with_index { |student, i|
    log "#{i+1}. #{student[:name]}, #{student[:height]}cm "\
        "(#{student[:cohort].capitalize} cohort)"
  }
end

##
# Prints a footer for the Villains Academy student list

def print_footer
  if @students.count == 0
    log "There are no students"
    return
  end
  log "Overall, we have #{@students.count} great #{@students.count == 1 ?
                                                    "student" : "students"}"
end

##
# Puts's the passed in string, centered to a width of 160

def log(str)
  puts str.center(160)
end

try_load_students
interactive_menu