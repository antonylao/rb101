# Deck stays the same after a tournament ends
# Deck re-shuffled when empty, and game continues

YES = %w(y yes)
NO = %w(n no)
VALID_YES_NO = YES + NO
HIT = %w(h hit)
STAY = %w(s stay)
PLAYER_TURN_CHOICES = HIT + STAY

RANKS = (2..10).to_a.map(&:to_s) + %w(J Q K A)
SUITS = %w(hearts diamonds clubs spades)

MAX_VALUE = 31
DEALER_LIMIT_VALUE = 27
WINNING_SCORE = 2

def prompt(message)
  puts("=> #{message}")
end

def input_hit_or_stay
  choice = ''
  loop do
    prompt "Hit or Stay? (h/s)"
    choice = gets.chomp.strip.downcase
    break if PLAYER_TURN_CHOICES.include?(choice)
    prompt "Invalid input. Please try again"
  end

  return :hit if HIT.include?(choice)
  return :stay if STAY.include?(choice)
end

def input_yes_or_no(message = nil)
  puts message + " (y/n)" if message
  response = gets.chomp.strip.downcase

  unless VALID_YES_NO.include?(response)
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

def initialize_deck
  deck = []
  RANKS.each do |rank|
    SUITS.each do |suit|
      deck << { rank: rank, suit: suit, value: initial_value(rank) }
    end
  end
  deck.shuffle
end

def initial_value(rank)
  if rank.to_i != 0
    rank.to_i
  elsif rank == 'A'
    11
  else
    10
  end
end

def deal_initial_cards!(deck, player, dealer)
  system 'clear'
  prompt "Dealing the cards the the participants..."
  2.times do
    deal_single_card!(deck, player)
    deal_single_card!(deck, dealer)
  end

  prompt "Cards left in the deck: #{deck.size}"
  input_enter
  nil
end

def deal_single_card!(deck, participant)
  if deck.empty?
    prompt "The deck is empty. Reshuffling deck for "\
    "#{participant[:id].capitalize}'s card n°#{participant[:hand].size + 1}"
    deck.replace(initialize_deck)
  end
  participant[:hand] << deck.shift
  participant[:total] = total_value!(participant[:hand])
  nil
end

def ace_eleven?(card)
  card[:rank] == 'A' && card[:value] == 11
end

def total_value!(hand)
  total = 0
  hand.each do |card|
    total += card[:value]
  end

  if total > MAX_VALUE
    hand.each do |card|
      if ace_eleven?(card)
        card[:value] = 1
        return total_value!(hand)
      end
    end
  end

  total
end

def display_cards(participant)
  card_names = participant[:hand].map do |card|
    "#{card[:rank]} of #{card[:suit]}"
  end
  card_names_str = card_names.join('; ')
  prompt "#{participant[:id].capitalize} hand: #{card_names_str}"
  prompt "#{participant[:id].capitalize} hand value:  #{participant[:total]}"
end

def display_player_heading(card)
  puts "------------------------------------------"
  prompt "The dealer has a #{card[:rank]} of #{card[:suit]}"
  puts "------------------------------------------"
end

def display_dealer_heading(player_value)
  puts "------------------------------------------"
  prompt "Player hand value: #{player_value}"
  puts "------------------------------------------"
end

def display_card_drawed(participant)
  card_drawed = participant[:hand][-1]

  case participant[:id]
  when :player
    prompt "You chose to hit and drawed "\
    "#{card_drawed[:rank]} of #{card_drawed[:suit]}!"
  when :dealer
    prompt "Dealer drawed: #{card_drawed[:rank]} of #{card_drawed[:suit]}"
  end
end

def first_player_turn_display(player, dealer_card)
  system 'clear'
  display_player_heading(dealer_card)
  prompt "PLAYER TURN"
  display_cards(player)
end

def player_turn_display(player, dealer_card)
  system 'clear'
  display_player_heading(dealer_card)
  display_card_drawed(player)
  display_cards(player)
end

def player_turn!(deck, player, dealer_card)
  first_player_turn_display(player, dealer_card)

  loop do
    choice = input_hit_or_stay

    if choice == :hit
      deal_single_card!(deck, player)
      player_turn_display(player, dealer_card)

    elsif choice == :stay
      system 'clear'
      prompt "You chose to stay!"
    end

    break if choice == :stay || busted?(player[:total])
  end
  nil
end

def first_dealer_turn_display(dealer, player_total)
  display_dealer_heading(player_total)
  prompt "DEALER TURN"
  display_cards(dealer)
end

def dealer_turn_display(dealer, player_total)
  system 'clear'
  display_dealer_heading(player_total)
  display_card_drawed(dealer)
  display_cards(dealer)
end

def dealer_turn!(deck, dealer, player_total)
  first_dealer_turn_display(dealer, player_total)

  while dealer[:total] < DEALER_LIMIT_VALUE
    input_enter

    deal_single_card!(deck, dealer)
    dealer_turn_display(dealer, player_total)
  end
end

def busted?(total)
  total > MAX_VALUE
end

def round_results(player_total, dealer_total)
  if player_total > MAX_VALUE
    :player_busted
  elsif dealer_total > MAX_VALUE
    :dealer_busted
  else
    diff = player_total - dealer_total
    # rubocop:disable Style/EmptyCaseCondition
    case
    when diff > 0 then :player
    when diff < 0 then :dealer
    else :tie
    end
    # rubocop:enable Style/EmptyCaseCondition
  end
end

def play_again?(message = nil)
  input_yes_or_no_boolean(message)
end

def display_winner(results_round)
  puts "========================================"
  case results_round
  when :player_busted then prompt "Player busted! Dealer wins!"
  when :dealer_busted then prompt "Dealer busted! Player wins!"
  when :player then prompt "Player wins!"
  when :dealer then prompt "Dealer wins!"
  else prompt "It's a tie!"
  end
  puts "========================================"
end

def display_welcome_message
  prompt "Welcome to #{MAX_VALUE}! Dealer will hit until #{DEALER_LIMIT_VALUE}."
  prompt "First one to win #{WINNING_SCORE} round(s) is the grand winner!"
end

def round_winner(result)
  if [:dealer_busted, :player].include?(result)
    :player
  elsif [:player_busted, :dealer].include?(result)
    :dealer
  elsif result == :tie
    :tie
  end
end

def grand_winner?(player_score, dealer_score)
  player_score == WINNING_SCORE || dealer_score == WINNING_SCORE
end

def update_score(winner, player, dealer)
  case winner
  when :player
    player[:score] += 1
  when :dealer
    dealer[:score] += 1
  end
  nil
end

def display_score(player_score, dealer_score)
  prompt "Player score: #{player_score}"
  prompt "Dealer score: #{dealer_score}"
end

def display_grand_winner(participant)
  puts
  prompt "#{participant.capitalize} won the tournament!"
end

def reset_round!(player, dealer)
  player[:total] = 0
  dealer[:total] = 0
  player[:hand] = []
  dealer[:hand] = []
end

def input_enter(message = nil)
  if message
    prompt message
  else
    prompt "Press enter to continue"
  end
  gets
  nil
end

def reset_score!(player, dealer)
  player[:score] = 0
  dealer[:score] = 0
end

def initialize_participants_data
  player = { id: :player, hand: [], total: 0, score: 0 }
  dealer = { id: :dealer, hand: [], total: 0, score: 0 }
  [player, dealer]
end

system 'clear'
display_welcome_message
input_enter

deck = initialize_deck
player, dealer = initialize_participants_data

loop do
  reset_score!(player, dealer)
  grand_winner = :undefined
  loop do
    reset_round!(player, dealer)
    deal_initial_cards!(deck, player, dealer)
    dealer_card_face_up = dealer[:hand][0]

    player_turn!(deck, player, dealer_card_face_up)
    dealer_turn!(deck, dealer, player[:total]) unless busted?(player[:total])

    result = round_results(player[:total], dealer[:total])
    winner = round_winner(result)

    display_winner(result)
    update_score(winner, player, dealer)
    display_score(player[:score], dealer[:score])

    if grand_winner?(player[:score], dealer[:score])
      grand_winner = winner
      break
    end

    input_enter("Press enter to play the next round")
  end
  display_grand_winner(grand_winner)

  continue = play_again?("Player another tournament?")
  break unless continue
end
