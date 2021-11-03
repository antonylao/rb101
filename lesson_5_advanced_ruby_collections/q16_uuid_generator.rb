# ruby has SecureRandom#uuid to generate a uuid

HEXA_CHARS = ('a'..'f').to_a + (0..9).to_a
NB_OF_HEXA_CHARS = HEXA_CHARS.size
#method with random section lengths
def valid_position?(array, index)
  beginning_index = 0
  ending_index = array.size - 1
  if [beginning_index, ending_index].include?(index) ||
    !((beginning_index..ending_index).include?(index))
    false
  elsif array[index - 1] != '-' && array[index] != '-'
    true
  else
    false
  end
end

def initialize_uuid
  hexa_chars = []
  32.times do
    hexa_chars << HEXA_CHARS[rand(NB_OF_HEXA_CHARS)]
  end

  loop do
    index = rand(hexa_chars.size)
    hexa_chars.insert(index, '-') if valid_position?(hexa_chars, index)
    break if hexa_chars.count('-') == 4
  end

  hexa_chars.join
end


# LS solution: with 8-4-4-4-12 sections
def generate_UUID
  characters = []
  (0..9).each { |digit| characters << digit.to_s }
  ('a'..'f').each { |digit| characters << digit }

  uuid = ""
  sections = [8, 4, 4, 4, 12]
  sections.each_with_index do |section, index|
    section.times { uuid += characters.sample }
    uuid += '-' unless index >= sections.size - 1
  end

  uuid
end

p generate_UUID
