require "pry"
require "yaml"

# number validation edge cases
#   if user inputs +[num] : to_i and to_f convert the number,
#                           but the conversion back will be without '+'
#                           ( integer?(num) and float?(num) )
#   if user inputs ( [num] )
#   if user inputs -/+( [num] ), ( -/+ [num] )
#   if user inputs spaces
#   if input == 1.
#   numbers with trailing 0 past the . (ex: 2.00)
#   if input == .4564
#   multiple (), +, - ; +/- combined (ex: -+ [num]) : not valid number

MESSAGES = YAML.load_file("calculator_messages.yml")
LANGUAGE = 'es'

def prompt(message, replacement = 'to_change')
  # if %{var} is not present in the .yml file,
  # Kernel#format does not change the string
  message = format(messages(message, LANGUAGE), var: replacement)
  Kernel.puts("=> #{message}")
end

def messages(key, lang = 'en')
  MESSAGES[lang][key]
end

def string_into_array(string)
  array = []
  index = 0

  while index <= string.length() - 1
    array.push(string[index])
    index += 1
  end

  array
end

def array_into_string(array)
  array.join() # Array#join returns the string
end

# methods for format_string(string)
def remove_beginning_plus_sign(array)
  array.shift() if array[0] == '+'

  array.delete_at(2) if array[0..2] == ['-', '(', '+']

  array
end

def remove_parentheses(array)
  array.shift() if array[0] == '('
  array.pop() if array[-1] == ')'

  # delete '(' character in index 1 (space 2) if input == '-( [num] ...'
  array.delete_at(1) if array[0..1] == ['-', '(']

  array
end

def remove_spaces(array)
  array.delete(' ')
  array
end

def format_float_trailing_zeros(array)
  # remove trailing 0 unless it would result in the last character being '.'
  while (array[-1] == '0') && (array[-2] != '.')
    array.pop()
  end

  # add a 0 at the end if the last character is '.'
  array.push('0') if array[-1] == '.'

  # add a 0 before '.' if the first character is '.', or if it begins with '-.'
  array.unshift('0') if array[0] == '.'
  array.insert(1, '0') if array[0..1] == ['-', '.']

  array
end

def dot?(array)
  has_a_dot = false

  array.each do |character|
    if character == '.'
      has_a_dot = true
      break
    end
  end
  has_a_dot
end
# end of methods for format_string(str)

def format_string(string)
  temp_array = string_into_array(string)
  remove_spaces(temp_array)

  remove_beginning_plus_sign(temp_array)
  remove_parentheses(temp_array)
  remove_beginning_plus_sign(temp_array) # in case input is '(+ ...'

  format_float_trailing_zeros(temp_array) if dot?(temp_array)
  array_into_string(temp_array)
end

def integer?(num)
  num.to_i().to_s() == num
end

def float?(num)
  num.to_f().to_s() == num
end

def number?(num)
  integer?(num) || float?(num)
end

def division_by_zero?(operation_num, second_num)
  operation_num == '4' && second_num.to_f == 0.0
end

def operation_to_message(op)
  string_op = case op
              when '1'
                'Adding'
              when '2'
                'Subtracting'
              when '3'
                'Multiplying'
              when '4'
                'Dividing'
              end
  # we can add some code here
  string_op # the method will still return the string value
end

def calculate(num_a, num_b, num_operation)
  result = case num_operation
           when '1'
             num_a.to_f() + num_b.to_f()
           when '2'
             num_a.to_f() - num_b.to_f()
           when '3'
             num_a.to_f() * num_b.to_f()
           when '4'
             num_a.to_f() / num_b.to_f()
           end

  # remove the '.0' of result if it is an integer
  result = result.to_i if result == result.to_i

  result
end

def get_valid_name
  string = ''

  loop do
    string = Kernel.gets().chomp()

    if string.empty?()
      prompt("valid_name")
    else
      break
    end
  end

  string
end

def get_number(key)
  num = ''

  loop do
    prompt(key)
    num = Kernel.gets().chomp()
    num = format_string(num)

    if number?(num)
      break
    else
      prompt("invalid_number")
    end
  end
  num
end

def get_operation
  number = ''

  loop do
    number = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(number)
      break
    else
      prompt("invalid_operation")
    end
  end

  number
end

def get_response
  answer = ''
  loop do
    answer = Kernel.gets().chomp().downcase()
    if %w(y n).include?(answer)
      break
    else
      prompt("invalid_again_response")
    end
  end

  answer
end

prompt("welcome")
name = get_valid_name()

prompt("hi_name", name)

loop do # main loop
  number1 = get_number("ask_first_number")
  number2 = get_number("ask_second_number")

  prompt("ask_operation")
  operator = get_operation()

  if division_by_zero?(operator, number2)
    prompt("division_by_0")
  else
    prompt("making_operation", operation_to_message(operator))

    prompt("result", calculate(number1, number2, operator))
  end

  prompt("again")
  break if get_response() == 'n'
end

prompt("goodbye")
