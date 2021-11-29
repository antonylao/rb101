# initial marker for player_1 and computer_1 are X and O respectively
# ai with no minimax takes the center square(s) if not taken
# if more than 26 players, markers will be two letters

YES = %w(y yes)
NO = %w(n no)
VALID_RESPONSE = YES + NO
EMPTY_MARKER = ' '
PLAYER_INITIAL_MARKER = 'X'
COMPUTER_INITIAL_MARKER = 'O'
INITIAL_MARKERS = [PLAYER_INITIAL_MARKER, COMPUTER_INITIAL_MARKER]
MINIMAX_VAL_WIN = 1
MINIMAX_VAL_LOSS = -1
MINIMAX_VAL_TIE = 0

ACTIVATE_MINIMAX = true
SQUARES_PER_SIDE = 3
WINNING_SCORE = 2

NB_OF_SQUARES = SQUARES_PER_SIDE**2
CENTER_SQUARE = if SQUARES_PER_SIDE.odd?
                  [(NB_OF_SQUARES / 2) + 1]
                elsif SQUARES_PER_SIDE.even?
                  beginning_index1 = (NB_OF_SQUARES / 2) -
                                     (SQUARES_PER_SIDE / 2)
                  beginning_index2 = (NB_OF_SQUARES / 2) +
                                     (SQUARES_PER_SIDE / 2)
                  [beginning_index1, beginning_index1 + 1,
                   beginning_index2, beginning_index2 + 1]
                end

SQUARE_LENGTH = NB_OF_SQUARES.to_s.length + 3

index_sq = 1
horizontal_lines = []
SQUARES_PER_SIDE.times do
  horizontal_line = []
  SQUARES_PER_SIDE.times do
    horizontal_line << index_sq
    index_sq += 1
  end
  horizontal_lines << horizontal_line
end

vertical_lines = []
index_arr = 0
SQUARES_PER_SIDE.times do
  vertical_line = []
  horizontal_lines.each do |horizontal_line|
    vertical_line << horizontal_line[index_arr]
  end
  vertical_lines << vertical_line
  index_arr += 1
end

index_arr = 0
index_arr_inverted = SQUARES_PER_SIDE - 1
diagonal_line = []
diagonal_line_inverted = []
horizontal_lines.each do |horizontal_line|
  diagonal_line << horizontal_line[index_arr]
  diagonal_line_inverted << horizontal_line[index_arr_inverted]
  index_arr += 1
  index_arr_inverted -= 1
end
diagonal_lines = [diagonal_line, diagonal_line_inverted]

WINNING_LINES = horizontal_lines + vertical_lines + diagonal_lines

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(array, separator = ', ', last_elt_separator = 'or')
  last_separator_full = separator + last_elt_separator
  case array.size
  when 0 then ''
  when 1 then array[0].to_s
  when 2 then array.join(" #{last_elt_separator} ")
  else
    "#{array[0..-2].join(separator)}#{last_separator_full} #{array[-1]}"
  end
end

def display_square_nb_line(index)
  (SQUARES_PER_SIDE - 1).times do
    index_indicator_line = "[#{index}]".ljust(SQUARE_LENGTH)

    print index_indicator_line + '|'
    index += 1
  end
  index_indicator_line = "[#{index}]".ljust(SQUARE_LENGTH)
  puts index_indicator_line
end

def display_empty_line
  puts (''.center(SQUARE_LENGTH) + '|') * (SQUARES_PER_SIDE - 1)
end

def display_line_with_marker(brd, index)
  (SQUARES_PER_SIDE - 1).times do
    marker_line = brd[index].to_s.center(SQUARE_LENGTH)
    print marker_line + '|'
    index += 1
  end
  marker_line = brd[index].to_s.center(SQUARE_LENGTH)
  puts marker_line
end

def display_separating_line
  puts(('-' * SQUARE_LENGTH + "+") *
       (SQUARES_PER_SIDE - 1) +
       ('-' * SQUARE_LENGTH))
end

def display_square_line(brd, index)
  last_square = (index > (NB_OF_SQUARES - SQUARES_PER_SIDE))

  display_square_nb_line(index)
  display_line_with_marker(brd, index)
  display_empty_line
  display_separating_line unless last_square
end

def display_board(brd)
  index_beginning_square = 1
  puts
  system 'clear'
  (SQUARES_PER_SIDE).times do
    display_square_line(brd, index_beginning_square)
    index_beginning_square += SQUARES_PER_SIDE
  end
end

def initialize_board
  new_board = {}

  (1..NB_OF_SQUARES).each { |num| new_board[num] = EMPTY_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == EMPTY_MARKER }
end

def player?(participant)
  participant[:id].to_s.include? "player"
end

def computer?(participant)
  participant[:id].to_s.include? "computer"
end

def place_piece!(brd, participant, participants_data)
  prompt "#{participant[:name]}'s turn (#{participant[:marker]})"
  if player?(participant)
    player_places_piece!(brd, participant[:marker])
  elsif computer?(participant)
    computer_places_piece!(brd, participant, participants_data)
  else
    puts 'place_piece! error'
  end
end

def player_places_piece!(brd, marker)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.strip
    break if empty_squares(brd).include?(square.to_i) && integer?(square)
    prompt "Sorry, that's not a valid choice."
  end
  square = square.to_i
  brd[square] = marker
end

def computer_places_piece!(brd, participant, participants_data)
  square = if ACTIVATE_MINIMAX == false
             ai_square_suggestion(brd, participant, participants_data)
           elsif ACTIVATE_MINIMAX == true
             minimax_square_suggestion(brd, participant, participants_data)
           end
  brd[square] = participant[:marker]
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def round_won?(brd, participants_data)
  !!detect_round_winner(brd, participants_data)
end

def detect_round_winner(brd, participants_data)
  participants_data.each_value do |participant|
    WINNING_LINES.each do |line|
      if brd.values_at(*line).count(participant[:marker]) == SQUARES_PER_SIDE
        return participant
      end
    end
  end
  nil
end

def empty_center_squares?(brd)
  CENTER_SQUARE.any? do |center_square|
    empty_squares(brd).include?(center_square)
  end
end

def change_first_elt(array, first_elt)
  array.sort_by { |elt| elt == first_elt ? 0 : 1 }
end

def almost_winning_line?(brd, markers, line)
  markers.each.any? do |marker|
    brd.values_at(*line).count(marker) == SQUARES_PER_SIDE - 1
  end
end

def ai_square_suggestion(brd, participant, participants_data)
  list_markers = participants_data.each_value.map do |participant_hash|
    participant_hash[:marker]
  end
  list_markers = change_first_elt(list_markers, participant[:marker])

  WINNING_LINES.each do |line|
    if almost_winning_line?(brd, list_markers, line)
      line.each { |square| return square if square == EMPTY_MARKER }
    end
  end

  if empty_center_squares?(brd)
    (empty_squares(brd) & CENTER_SQUARE).sample
  else
    empty_squares(brd).sample
  end
end

def minimax_square_suggestion(brd, participant, participants_data)
  first_empty_square = empty_squares(brd).first
  choices = []
  square_value = minimax(brd, first_empty_square,
                         participant, participants_data, participant)

  empty_squares(brd).each do |test_square|
    test_square_val = minimax(brd, test_square,
                              participant, participants_data, participant)
    if test_square_val > square_value
      choices = [test_square]
      square_value = test_square_val
    elsif test_square_val == square_value
      choices << test_square
    end
  end
  choices.sample
end

def last_position(participants_data)
  positions_arr = participants_data.each_value.map do |participant_info|
    participant_info[:position]
  end

  positions_arr.max
end

def alternate_player(participants_data, current_player)
  last_place_int = last_position(participants_data)

  if current_player[:position] == last_place_int
    participants_data.each_value do |participant_info|
      return participant_info if participant_info[:position] == 1
    end
  else
    participants_data.each_value do |participant_info|
      if participant_info[:position] == current_player[:position] + 1
        return participant_info
      end
    end
  end
end

def minimax_value_endgame(winner, maximizer)
  case winner
  when maximizer then MINIMAX_VAL_WIN
  when nil then MINIMAX_VAL_TIE
  else MINIMAX_VAL_LOSS
  end
end

def minimax(brd, square_played, participant, participants_data, maximizer)
  brd_dup = brd.dup
  brd_dup.transform_values!(&:dup)

  brd_dup[square_played] = participant[:marker]

  participant = alternate_player(participants_data, participant)

  if round_won?(brd_dup, participants_data) || board_full?(brd_dup)
    winner = detect_round_winner(brd_dup, participants_data)
    minimax_value_endgame(winner, maximizer)
  else
    values = []
    empty_squares(brd_dup).each do |empty_square|
      values << minimax(brd_dup, empty_square,
                        participant, participants_data, maximizer)
    end

    participant[:id] == maximizer[:id] ? values.max : values.min
  end
end

def cycle_participants_order!(participants_data)
  last_place_int = last_position(participants_data)

  participants_data.each_value do |participant_info|
    if participant_info[:position] == 1
      participant_info[:position] = last_place_int
    else
      participant_info[:position] -= 1
    end
  end
end

def integer?(num_str)
  num_str.to_i.to_s == num_str
end

def positive_integer?(num_str)
  (num_str.to_i.to_s == num_str) && num_str.to_i >= 0
end

def input_positive_integer(message = nil)
  input = ''
  loop do
    prompt(message) if message
    input = gets.chomp.strip
    break if positive_integer?(input)
    prompt("This doesn't seem to be valid. Please put a positive integer.")
  end
  input.to_i
end

def input_yes_or_no(message = nil)
  puts message if message
  response = gets.chomp.strip.downcase

  unless VALID_RESPONSE.include?(response)
    prompt("Invalid input. Please put yes/no or y/n.")
    response = input_yes_or_no(message)
  end

  response
end

def yes_no_to_boolean(response)
  YES.include?(response)
end

def input_yes_or_no_boolean(message = nil)
  yes_no_to_boolean(input_yes_or_no(message))
end

def input_player_name(player_id, list_all_names)
  name = ''
  puts "Choose a name for #{player_id}"
  loop do
    name = gets.chomp.strip
    break unless (list_all_names.include?(name)) || name.size == 0
    puts "This name is already taken. Please choose another name"
  end
  name
end

def default_name(participant_id)
  participant_id.to_s.gsub('_', ' n°')
end

def input_order_choice
  order_choice_message = <<~MSG
    What do you want the initial order to be?
       1: Player(s) first
       2: Computer(s) first
       3: Random
       4: Alternate
  MSG

  choice = ''
  loop do
    prompt order_choice_message
    choice = gets.chomp.strip
    break if integer?(choice) && (1..4).include?(choice.to_i)
    prompt "Invalid choice. Please try again"
  end
  choice.to_i
end

def participant_names(player_ids, computer_ids, choose_names_bool)
  names = {}
  computer_ids.each { |cpu_id| names[cpu_id] = default_name(cpu_id) }

  if choose_names_bool
    player_ids.each do |player_id|
      current_names_used = names.values
      player_name = input_player_name(player_id, current_names_used)
      names[player_id] = player_name
    end
  else
    player_ids.each do |player_id|
      names[player_id] = default_name(player_id)
    end
  end
  names
end

def participant_positions(participant_ids, choice_int)
  case choice_int
  when 1 then list_ids_ordered = participant_ids
  when 2 then list_ids_ordered = participant_ids.sort
  when 3 then list_ids_ordered = participant_ids.shuffle
  when 4
    list_ids_ordered = participant_ids.sort_by do |id|
      id.to_s.dup.delete('player').delete('computer')
    end
  end
  positions = {}
  list_ids_ordered.each_with_index do |id, index|
    positions[id] = index + 1
  end

  positions
end

# rubocop:disable Metrics/MethodLength
def participant_markers(participant_ids)
  markers = {}
  marker_iterated = 'A'
  participant_ids.each do |participant_id|
    if participant_id == :player_1
      markers[participant_id] = PLAYER_INITIAL_MARKER
    elsif participant_id == :computer_1
      markers[participant_id] = COMPUTER_INITIAL_MARKER
    else
      markers[participant_id] = marker_iterated
      loop do
        marker_iterated = marker_iterated.next
        break unless INITIAL_MARKERS.include?(marker_iterated)
      end
    end
  end
  markers
end
# rubocop:enable Metrics/MethodLength

def initialize_participants_data(participant_ids, names, markers)
  participants_data = {}

  participant_ids.each do |participant_id|
    participants_data[participant_id] = {
      id: participant_id,
      name: names[participant_id],
      marker: markers[participant_id],
      score: 0,
      position: 'undefined'
    }
  end

  participants_data
end

def update_participant_positions!(participants_data)
  participant_ids = participants_data.keys

  choice = input_order_choice
  positions = participant_positions(participant_ids, choice)

  participants_data.each_value do |participant|
    participant[:position] = positions[participant[:id]]
  end
end

def beginning_player(participants_data)
  first_player = nil
  participants_data.each_value do |participant_info|
    if participant_info[:position] == 1
      first_player = participant_info
      break
    end
  end

  first_player
end

def display_score(participants_data)
  participants_data.each_value do |participant_info|
    prompt "#{participant_info[:name]}: #{participant_info[:score]}"
  end
end

def tournament_winner(participants_data)
  winner = nil
  participants_data.each_value do |participant_info|
    if participant_info[:score] >= WINNING_SCORE
      winner = participant_info
      break
    end
  end
  winner
end

def play_whole_round!(brd, participants)
  current_player = beginning_player(participants)
  loop do
    display_board(brd)
    place_piece!(brd, current_player, participants)
    current_player = alternate_player(participants, current_player)
    break if round_won?(brd, participants) || board_full?(brd)
  end
  display_board(brd)
end

def display_round_winner(brd, participants)
  if round_won?(brd, participants)
    round_winner = detect_round_winner(brd, participants)
    prompt "#{round_winner[:name]} won this round!"
  else
    prompt "It's a tie!"
  end
end

def update_score!(brd, participants)
  if round_won?(brd, participants)
    winner = detect_round_winner(brd, participants)
    participants[winner[:id]][:score] += 1
  end
end

def play_again?
  prompt "Play again? (y or n)"
  input_yes_or_no_boolean
end

def name_choice_bool(nb_humans)
  if nb_humans != 0
    puts "Do you want to choose the participants names? (y/n)"
    input_yes_or_no_boolean
  else
    false
  end
end

def build_participants_data
  humans_number = input_positive_integer("How many human players?")
  computers_number = input_positive_integer("How many computer players?")
  participants_number = humans_number + computers_number
  if participants_number > NB_OF_SQUARES
    prompt "Warning: Too many participants for the board size".upcase
  end

  choose_names = name_choice_bool(humans_number)

  player_ids = (:player_1.."player_#{humans_number}".to_sym).to_a
  computer_ids = (:computer_1.."computer_#{computers_number}".to_sym).to_a
  participant_ids = player_ids + computer_ids

  names = participant_names(player_ids, computer_ids, choose_names)
  markers = participant_markers(participant_ids)
  initialize_participants_data(participant_ids, names, markers)
end

def display_welcome_message
  prompt "Welcome to the Tic Tac Toe tournament! "\
         "First one to get to #{WINNING_SCORE} points win."
end

def display_tournament_winner(participant_info)
  prompt "#{participant_info[:name]} won the tournament!"
end

def reset_participants_score!(participants_data)
  participants_data.each_value do |participant_info|
    participant_info[:score] = 0
  end
end

if ACTIVATE_MINIMAX && SQUARES_PER_SIDE > 3
  prompt "Warning: computer will take too long to play".upcase
end

display_welcome_message
participants = build_participants_data
p participants
loop do
  update_participant_positions!(participants)

  winner = nil
  loop do
    board = initialize_board
    play_whole_round!(board, participants)
    display_round_winner(board, participants)

    update_score!(board, participants)
    display_score(participants)
    winner = tournament_winner(participants)
    break if winner

    prompt "Press enter to begin the next round"
    gets
    cycle_participants_order!(participants)
  end

  display_tournament_winner(winner)
  continue = play_again?
  break unless continue
  reset_participants_score!(participants)
end
prompt "Thanks for playing Tic Tac Toe! Good bye!"
