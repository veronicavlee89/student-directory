require 'date'

@width = 50

##
# Puts's the passed in string, centered to a width of 160

def log(str)
  puts str.center(160)
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
  log ""
  # create an empty array
  students = []
  # get the first name
  log "Enter student's name"
  name = gets.gsub("\n",'')
  # while the name is not empty, repeat this code
  while !name.empty? do
    # get height that is numeric digits only and is > 0
    height = '0'
    until /\A\d+\z/.match(height) && height.to_i > 0
      log "Enter #{name}'s height (in cm)"
      height = gets.gsub("\n",'')
    end
    cohort = ""
    # validate that cohort entered is a month
    until Date::MONTHNAMES.include? cohort.capitalize
      log "Enter #{name}'s cohort. Hit return to set to "\
          "#{Date::MONTHNAMES[Date.today.month]}"
      cohort = gets.gsub("\n",'')
      # default cohort to current month if none provided
      cohort = Date::MONTHNAMES[Date.today.month] if cohort == ""
    end
    students << {name: name, height: height, cohort: cohort.downcase.to_sym}
    log "Now we have #{students.count} #{students.count == 1 ?
                                           "student" : "students"}"
    log "Enter next student's name"
    name = gets.gsub("\n",'')
  end
  students
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

students = input_students
print_header
print(students)
print_footer(students)