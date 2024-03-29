require 'pry'

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

def results_sym(player, computer)
  num = if win?(player, computer)
          :player_won
        elsif win?(computer, player)
          :computer_won
        else
          :tie
        end

  num
end

def display_results(choice_player, choice_computer, result_symbol, score_hash)
  prompt("You chose: #{choice_player}; Computer chose: #{choice_computer}")

  case result_symbol
  when :player_won then prompt("You won!")
  when :computer_won then prompt("Computer won!")
  when :tie then prompt("It's a tie!")
  else prompt("error in display_results")
  end

  prompt(
    <<~MSG
    The score is: #{score_hash[:player]} for you,
                     #{score_hash[:computer]} for the computer.

    MSG
  )
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

def array_new_score(score, result_symbol)
  case result_symbol
  when :player_won then score[0] += 1
  when :computer_won then score[1] += 1
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

def display_grand_winner_message(result_symbol)
  case result_symbol
  when :player_won then prompt("Congratulations!")
  when :computer_won then prompt("Better luck next time!")
  end
end

def display_rules
  rules = <<~MSG
  Rock crushes Lizard / crushes Scissors
     Paper covers Rock / disproves Spock
     Spock smashes Scissors / vaporizes Rock
     Scissors cuts Paper / decapitates Lizard
     Lizard eats Paper / poisons Spock
  MSG
  prompt(rules)
end

def ask_to_display_rules
  prompt("Do you want to know the rules? (y/n)")

  response = get_valid_input(VALID_RESPONSES)

  system 'clear'
  display_rules if response == 'yes'
end

def play_again?
  prompt("Do you want to play again? (y/n)")
  response = get_valid_input(VALID_RESPONSES)
  response == 'yes'
end

valid_choices_str = VALID_CHOICES.join(', ')

system 'clear'
prompt("Welcome to the #{valid_choices_str} match!")

ask_to_display_rules

loop do
  puts("-----------------------------------------------------")
  prompt("First one to score "\
         "#{GRAND_WINNING_NUMBER} points is the grand winner!")

  score = { player: 0, computer: 0 }

  loop do
    choice_message = <<~MSG
    Choose one: #{valid_choices_str} (input the full name or an abbreviation).
       For scissors and spock, please input the first two letters at least ("sp" or "sc")
    MSG

    choice = get_valid_input(VALID_CHOICES, choice_message)

    computer_choice = get_computer_choice
    results_symbol = results_sym(choice, computer_choice)
    score[:player], score[:computer] = array_new_score(score.values,
                                                       results_symbol)

    system 'clear'
    display_results(choice, computer_choice, results_symbol, score)

    if end_match?(score[:player], score[:computer])
      display_grand_winner_message(results_symbol)
      break
    end
  end

  break unless play_again?
  system 'clear'
end

prompt("Thank you for playing. Good bye!")
