require 'pry'

statement = "The Flintstones Rock"

# Create a hash that expresses the frequency with which each letter occurs in this string:
# { "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }

letters = Hash.new(0)


statement.each_char do |char|
  if ('a'..'z').include?(char.downcase)
    letters[char] += 1
  end
end

p letters

#LS: use of String#count

# result = {}
# letters = ('A'..'Z').to_a + ('a'..'z').to_a

# letters.each do |letter|
#   letter_frequency = statement.count(letter)
#   result[letter] = letter_frequency if letter_frequency > 0
# end