require 'date'

@students = []

##
# Loads students from file on program start up, if applicable.

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
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
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
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
    save_students
  when "4"
    load_students
  when "9"
    exit
  else
    puts "I don't know what you meant, try again"
  end
end

##
# Collects student information from user including name, height and cohort.

def input_students
  print_input_header
  name = input_name
  while !name.empty? do
    height = input_height(name)
    cohort = input_cohort(name)
    @students << {name: name, height: height, cohort: cohort.downcase.to_sym}
    log "Now we have #{@students.count} #{@students.count == 1 ?
                                           "student" : "students"}"
    name = input_name
  end
end

##
# Saves the inputted student information to a file

##
# Prints the student information

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student|
    student_data = [student[:name], student[:height], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, height, cohort = line.chomp.split(',')
    @students << { name: name, height: height, cohort: cohort.to_sym }
  end
  file.close
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
  STDIN.gets.gsub("\n",'')
end

##
# Gets student height as input. Must be numeric digits only and > 0

def input_height(student_name)
  height = '0'
  until /\A\d+\z/.match(height) && height.to_i > 0
    log "Enter #{student_name}'s height (in cm)"
    height = STDIN.gets.gsub("\n",'')
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
    cohort = STDIN.gets.gsub("\n",'')
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
# Prints a list of students of Villains Academy.
# Students are printed ordered by their cohort.
# Information includes student name, height and cohort.

def print_students_list
  return if @students.count == 0
  @students.sort_by! { |student| Date::MONTHNAMES.index(student[:cohort].to_s.capitalize) }
  @students.each_with_index { |student, i|
    # the below constraint was part of Step 8 Exercises, but since removed
    # if student[:name][0].upcase == "V" && student[:name].length < 12
    log "#{i+1}. #{student[:name]}, #{student[:height]}cm "\
        "(#{student[:cohort].capitalize} cohort)"
    # end
  }
end

##
# Prints a footer for the Villains Academy student list, including a count of
# students.

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