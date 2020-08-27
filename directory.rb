require 'date'

@width = 50

def log(str)
  # separate center and width to method to easily change in the future
  puts str.center(160)
end

def input_students
  log "Please enter the information of the students"
  log "To finish, just hit return when prompted for a student name"
  log ""
  # create an empty array
  students = []
  # get the first name
  log "Enter student's name"
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    # get height that is numeric digits only and is > 0
    height = '0'
    until /\A\d+\z/.match(height) && height.to_i > 0
      log "Enter #{name}'s height (in cm)"
      height = gets.chomp
    end
    # get cohort. Default to current month if none entered
    cohort = ""
    until Date::MONTHNAMES.include? cohort.capitalize
      log "Enter #{name}'s cohort. Hit return to set to #{Date::MONTHNAMES[Date.today.month]}"
      cohort = gets.chomp
      cohort = Date::MONTHNAMES[Date.today.month] if cohort == ""
    end
    # add the student hash to the array
    students << {name: name, height: height, cohort: cohort.downcase.to_sym}
    log "Now we have #{students.count} #{students.count == 1 ? "student" : "students"}"
    # get another name from the user
    log "Enter next student's name"
    name = gets.chomp
  end
  # return the array of students
  students
end

def print_header
  log "The students of Villains Academy"
  log "-------------"
end

def print(students)
  students.sort_by! { |student| Date::MONTHNAMES.index(student[:cohort].to_s.capitalize) }
  i = 0
  until i == students.length do
    if students[i][:name][0].upcase == "V" && students[i][:name].length < 12
      log "#{i+1}. #{students[i][:name]}, #{students[i][:height]}cm (#{students[i][:cohort].capitalize} cohort)"
    end
    i += 1
  end
end

def print_footer(students)
  log "Overall, we have #{students.count} great #{students.count == 1 ? "student" : "students"}"
end

students = input_students
print_header
print(students)
print_footer(students)