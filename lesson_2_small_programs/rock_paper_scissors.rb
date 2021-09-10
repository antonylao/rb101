WIN_CASES = {
  rock: %w(scissors lizard),
  paper: %w(rock spock),
  scissors: %w(paper lizard),
  spock: %w(rock scissors),
  lizard: %w(paper spock)
}

VALID_CHOICES = WIN_CASES.keys.map(&:to_s)

VALID_RESPONSES = %w(yes no)

GRAND_WINNING_NUMBER = 3

def prompt(message)
  puts("=> #{message}")
end

def get_formatted_input
  gets.chomp.downcase.strip
end

def win?(first, second)
  WIN_CASES[first.to_sym].include?(second)
end

def results_number(player, computer)
  num = if win?(player, computer)
          1
        elsif win?(computer, player)
          -1
        else
          0
        end

  num
end

def display_results(integer)
  case integer
  when 1 then prompt("You won!")
  when -1 then prompt("Computer won!")
  when 0 then prompt("It's a tie!")
  else prompt("error in display_results")
  end
end

def max_length_array(array_of_str)
  max = 0
  array_of_str.each { |string| max = string.length if max < string.length }

  max
end

def min(num_a, num_b)
  num_a < num_b ? num_a : num_b
end

def get_list_possible_choices(input, list_choices)
  list_choices_old = list_choices.clone
  iterator_characters = 0

  min(input.length, (max_length_array(list_choices) + 1)).times do
    list_choices_new = []

    list_choices_old.each do |possible_choice|
      if input[iterator_characters] == possible_choice[iterator_characters]
        list_choices_new.append(possible_choice)
      end
    end

    return [] if list_choices_new.length == 0

    list_choices_old = list_choices_new
    iterator_characters += 1
  end

  list_choices_old
end

def valid_choice?(input, valid_list)
  get_list_possible_choices(input, valid_list).length == 1
end

def display_error_wrong_input(list_of_possibles)
  case list_of_possibles.length
  when 0 then prompt("That's not a valid input.")
  when 2 then prompt("That's not a valid input. "\
                     "Did you mean #{list_of_possibles.join(', or ')}?")
  else prompt("error in display_error_wrong_input")
  end
end

def get_valid_input(valid_list, beginning_message = nil)
  loop do
    prompt beginning_message if beginning_message
    input = get_formatted_input
    list_of_possibles = get_list_possible_choices(input, valid_list)
    if valid_choice?(input, valid_list)
      return list_of_possibles[0]
    else
      case valid_list
      when VALID_CHOICES then display_error_wrong_input(list_of_possibles)
      when VALID_RESPONSES then prompt("Please type y/n")
      end
    end
  end
end

def array_new_score(score, results_num)
  case results_num
  when 1 then score[0] += 1
  when -1 then score[1] += 1
  end

  score
end

def get_computer_choice
  VALID_CHOICES.sample
end

def end_match?(score_player, score_computer)
  score_player == GRAND_WINNING_NUMBER ||
    score_computer == GRAND_WINNING_NUMBER
end

def display_grand_winner_message(num_results)
  case num_results
  when 1 then prompt("Congratulations!")
  when -1 then prompt("Better luck next time!")
  end
end

valid_choices_str = VALID_CHOICES.join(', ')

system 'clear'
prompt("Welcome to the #{valid_choices_str} match!")
prompt("Do you want to know the rules?")

response = get_valid_input(VALID_RESPONSES)
rules = <<~MSG
  Rock crushes Lizard / crushes Scissors
     Paper covers Rock / disproves Spock
     Spock smashes Scissors / vaporizes Rock
     Scissors cuts Paper / decapitates Lizard
     Lizard eats Paper / poisons Spock
MSG
prompt(rules) unless response == 'no'

loop do
  puts("------------------------------------------------------------------------")
  prompt("First one to score #{GRAND_WINNING_NUMBER} points is the grand winner!")

  score = { player: 0, computer: 0 }
  loop do
    choice = get_valid_input(VALID_CHOICES, "Choose one: #{valid_choices_str}")

    computer_choice = get_computer_choice
    num_results = results_number(choice, computer_choice)
    score[:player], score[:computer] = array_new_score(score.values,
                                                       num_results)

    system 'clear'
    prompt("You chose: #{choice}; Computer chose: #{computer_choice}")
    display_results(num_results)
    prompt(
      <<~MSG
      The score is: #{score[:player]} for you,
                       #{score[:computer]} for the computer.

      MSG
    )

    if end_match?(score[:player], score[:computer])
      display_grand_winner_message(num_results)
      break
    end
  end

  prompt("Do you want to play again? (y/n)")
  response = get_valid_input(VALID_RESPONSES)
  break if response == 'no'
  system 'clear' if response == 'yes'
end

prompt("Thank you for playing. Good bye!")
