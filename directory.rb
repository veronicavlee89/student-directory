require 'date'

##
# Puts's the passed in string, centered to a width of 160

def log(str)
  puts str.center(160)
end

def interactive_menu
  students = []
  loop do
    # 1. print the menu and ask the user what to do
    puts "1. Input the students"
    puts "2. Show the students"
    puts "9. Exit"
    # 2. read the input and save it into a variable
    selection = gets.chomp
    # 3. do what the user has asked
    case selection
    when "1"
      students = input_students
    when "2"
      print_header
      print(students)
      print_footer(students)
    when "9"
      exit # terminate program
    else
      puts "I don't know what you meant, try again"
    end
  end
end

##
# Collects student information from user input.
#
# Prompts user to enter required student information, including name, height
# and cohort.
# Validates input and re-prompts if input is not acceptable.

def input_students
  log "Please enter the information of the students"
  log "To finish, just hit return when prompted for a student name"
  log "---"
  students = []
  name = input_name
  while !name.empty? do
    height = input_height(name)
    cohort = input_cohort(name)
    students << {name: name, height: height, cohort: cohort.downcase.to_sym}
    log "Now we have #{students.count} #{students.count == 1 ?
                                           "student" : "students"}"
    name = input_name
  end
  students
end

##
# Gets student name as input. Can be an empty string.

def input_name
  log "Enter student's name"
  gets.gsub("\n",'')
end

##
# Gets student height as input. Must be numeric digits only and > 0

def input_height(student_name)
  height = '0'
  until /\A\d+\z/.match(height) && height.to_i > 0
    log "Enter #{student_name}'s height (in cm)"
    height = gets.gsub("\n",'')
  end
  height
end

##
# Gets student cohort as input. Must be a month.
# Defaults cohort to current month if none provided.

def input_cohort(student_name)
  cohort = ""
  until Date::MONTHNAMES.include? cohort.capitalize
    log "Enter #{student_name}'s cohort. Hit return to set to "\
          "#{Date::MONTHNAMES[Date.today.month]}"
    cohort = gets.gsub("\n",'')
    cohort = Date::MONTHNAMES[Date.today.month] if cohort == ""
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
# Prints a list of students of Villains Academy whose name starts with 'V' and
# is less than 12 characters long.
# Students are printed ordered by their cohort.
# Information includes student name, height and cohort.

def print(students)
  return if students.count == 0
  students.sort_by! { |student| Date::MONTHNAMES.index(student[:cohort].to_s.capitalize) }
  students.each_with_index { |student, i|
    if student[:name][0].upcase == "V" && student[:name].length < 12
      log "#{i+1}. #{student[:name]}, #{student[:height]}cm "\
          "(#{student[:cohort].capitalize} cohort)"
    end
  }
end

##
# Prints a footer for the Villains Academy student list, including a count of
# students.

def print_footer(students)
  if students.count == 0
    log "There are no students"
    return
  end
  log "Overall, we have #{students.count} great #{students.count == 1 ?
                                                    "student" : "students"}"
end

interactive_menu