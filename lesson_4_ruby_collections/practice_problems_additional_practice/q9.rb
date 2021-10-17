require 'pry'

words = "the flintstones rock"

def titleize(string)
  string.each_char.with_index do |char, index|
    if index == 0
      string[index] = char.upcase
    elsif string[index - 1] == ' '
      string[index] = char.upcase
    end

  end
end

titleize(words)
puts words