require "yaml"

MESSAGES = YAML.load_file("calculator_messages.yml")
LANGUAGE = 'es'
VALID_OPERATOR = %w(1 2 3 4)

YES = %w(y yes)
NO = %w(n no)
VALID_RESPONSE = YES + NO

def prompt(message, replacement = 'to_change')
  message = format(messages(message, LANGUAGE), var: replacement)
  puts("=> #{message}")
end

def messages(key, lang = 'en')
  MESSAGES[lang][key]
end

def string_into_array(string)
  string.chars
end

def array_into_string(array)
  array.join
end

def remove_beginning_plus_sign(array)
  array.shift if array[0] == '+'

  array.delete_at(2) if array[0..2] == ['-', '(', '+']

  array
end

def remove_parentheses(array)
  array.shift if array[0] == '('
  array.pop if array[-1] == ')'

  array.delete_at(1) if array[0..1] == ['-', '(']

  array
end

def format_float_trailing_zeros(array)
  while (array[-1] == '0') && (array[-2] != '.')
    array.pop
  end

  array.push('0') if array[-1] == '.'

  array.unshift('0') if array[0] == '.'
  array.insert(1, '0') if array[0..1] == ['-', '.']

  array
end
def minus_zero_case(string)
  string = '0' if string.to_f == - string.to_f

  return string
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

def format_number(string)
  string = format_spaces(string)
  temp_array = string_into_array(string)

  remove_beginning_plus_sign(temp_array)
  remove_parentheses(temp_array)
  remove_beginning_plus_sign(temp_array)

  format_float_trailing_zeros(temp_array) if dot?(temp_array)
  array_into_string(temp_array)
  string = minus_zero_case(string)
end

def format_spaces(string)
  string.gsub(' ', '')
end

def format_beginning_ending_spaces(string)
  string.strip
end

def integer?(num)
  num.to_i.to_s == num
end

def float?(num)
  num.to_f.to_s == num
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

  string_op
end

def calculate(num_a, num_b, num_operation)
  result = case num_operation
           when '1'
             num_a.to_f + num_b.to_f
           when '2'
             num_a.to_f - num_b.to_f
           when '3'
             num_a.to_f * num_b.to_f
           when '4'
             num_a.to_f / num_b.to_f
           end

  result = result.to_i if result == result.to_i

  result
end

def get_valid_name
  string = ''

  loop do
    string = gets.chomp
    string = format_beginning_ending_spaces(string)

    break unless string.empty?

    prompt("valid_name")
  end

  string
end

def get_number(key)
  num = ''

  loop do
    prompt(key)
    num = gets.chomp
    num = format_number(num)

    break if number?(num)

    prompt("invalid_number")
  end
  num
end

def get_operation
  number = ''

  loop do
    number = gets.chomp
    number = format_beginning_ending_spaces(number)

    break if VALID_OPERATOR.include?(number)

    prompt("invalid_operation")
  end

  number
end

def get_response
  answer = ''

  loop do
    answer = gets.chomp.downcase
    answer = format_beginning_ending_spaces(answer)

    break if VALID_RESPONSE.include?(answer)

    prompt("invalid_again_response")
  end

  answer
end

def bool_response(string)
  bool = if YES.include?(string)
           true
         elsif NO.include?(string)
           false
         else
           puts "error in bool_response"
         end
  bool
end

def perform_operation(num_a, num_b, num_operation)
  if division_by_zero?(num_operation, num_b)
    prompt("division_by_0")
  else
    prompt("making_operation", operation_to_message(num_operation))

    prompt("result", calculate(num_a, num_b, num_operation))
  end
end

system 'clear'
prompt("welcome")
name = get_valid_name

prompt("hi_name", name)

loop do
  number1 = get_number("ask_first_number")
  number2 = get_number("ask_second_number")

  prompt("ask_operation")
  operator = get_operation

  perform_operation(number1, number2, operator)

  prompt("again")
  continue = bool_response(get_response)
  break unless continue

  system 'clear'
end

prompt("goodbye")
