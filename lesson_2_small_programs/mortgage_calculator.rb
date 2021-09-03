require "pry"

YES = %w(y yes)
NO = %w(n no)
VALID_RESPONSE = YES + NO

def prompt(message)
  puts("=> #{message}")
end

def integer?(num_str)
  num_str.to_i().to_s() == num_str
end

def float?(num_str)
  num_str.to_f().to_s() == num_str
end

def positive?(num_str)
  num_str.to_f >= 0
end

def number?(string)
  integer?(string) || float?(string)
end

def positive_number?(string)
  number?(string) && positive?(string)
end

def positive_integer?(string)
  integer?(string) && positive?(string)
end

def format_spaces(string)
  string.gsub(' ', '')
end

def format_beginning_ending_spaces(string)
  string.strip
end

def format_float_trailing_zeros(array)
  while (array[-1] == '0') && (array[-2] != '.')
    array.pop
  end

  if array[-2..-1] == ['.', '0']
    2.times { array.pop }
  end

  array.push('0') if array[-1] == '.'

  array.unshift('0') if array[0] == '.'
  array.insert(1, '0') if array[0..1] == ['-', '.']

  array
end

def string_into_array(string)
  string.chars
end

def array_into_string(array)
  array.join
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
  format_float_trailing_zeros(temp_array) if dot?(temp_array)
  array_into_string(temp_array)
end

def get_formatted_number
  string = gets.chomp
  format_number(string)
end

def get_loan_amount
  num = ''

  prompt("What is the loan amount?")
  loop do
    num = get_formatted_number

    break if positive_number?(num)
    prompt("This loan amount doesn't seem to be valid.
Please put a positive number")
  end

  num.to_f
end

def get_positive_integer(message = nil)
  num = ''
  loop do
    prompt message if message
    num = get_formatted_number
    break if positive_integer?(num)
    prompt("This doesn't seem to be valid. Please put a positive integer")
  end

  num
end

def get_loan_duration
  num_years = ''
  num_months = ''
  loop do
    num_years = get_positive_integer("What is the loan duration (years)?")
    num_months = get_positive_integer("What is the loan duration (months)?")

    break if num_years.to_i + num_months.to_i > 0
    prompt("This doesn't seem to be valid. "\
    "The total loan duration cannot be 0")
  end

  [num_years.to_f, num_months.to_f]
end

def get_loan_apr
  num = ''
  prompt("What is the APR?")
  prompt("(Example: 5 for 5% or 2.5 for 2.5%)")
  loop do
    num = get_formatted_number

    break if positive_number?(num)
    prompt("This APR doesn't seem to be valid. Please put a positive number")
  end

  (num.to_f) / 100
end

def calculate_duration_month(years, months)
  years * 12 + months
end

def calculate_monthly_interest_rate(apr)
  apr / 12.0
end

def calculate_monthly_payment(loan_amount, monthly_interest_rate,
                              duration_in_months)
  if monthly_interest_rate == 0
    payment = loan_amount / duration_in_months
  else
    payment = loan_amount *
              (monthly_interest_rate /
              (1 - (1 + monthly_interest_rate)**(-duration_in_months)))
  end

  format_currency_number(payment)
end

def format_currency_number(float)
  float = float.round(2)
  number_string = float.to_s
  temp_array = string_into_array(number_string)
  temp_array.push('0') if temp_array[-2] == '.'
  array_into_string(temp_array)
end

def get_response
  response = gets.chomp.downcase
  response = format_beginning_ending_spaces(response)

  unless VALID_RESPONSE.include?(response)
    prompt("Invalid input. Please try again.")
    response = get_response
  end

  response
end

loop do
  system 'clear'
  prompt("Welcome to the mortgage calculator!")

  loan_duration = { years: nil, months: nil }

  loan_amount = get_loan_amount
  loan_duration[:years], loan_duration[:months] = get_loan_duration
  loan_apr = get_loan_apr

  # rubocop:disable Layout/FirstArgumentIndentation
  total_loan_duration_in_months = calculate_duration_month(
                                    loan_duration[:years],
                                    loan_duration[:months]
                                  )
  # rubocop:enable Layout/FirstArgumentIndentation

  monthly_interest_rate = calculate_monthly_interest_rate(loan_apr)
  monthly_payment = calculate_monthly_payment(loan_amount,
                                              monthly_interest_rate,
                                              total_loan_duration_in_months)

  prompt("The monthly payment would be #{monthly_payment} €.")
  # LS solution
  # prompt("Your monthly payment is: $#{format('%.2f', monthly_payment)}")

  prompt("Would you like to perform another mortgage calculation?")
  continue = get_response
  break if NO.include?(continue)
end

prompt("Thanks for using the mortgage calculator. Good bye!")
