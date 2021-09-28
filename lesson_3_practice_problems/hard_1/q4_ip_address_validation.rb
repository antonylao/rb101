def is_an_ip_number?(string)
  number = string.to_i
  (number >= 0) && (number <= 255)
end

# puts(
# is_an_ip_number?('0'),
# is_an_ip_number?('255'),
# is_an_ip_number?('256'),
# is_an_ip_number?('0.5'),
# is_an_ip_number?('-0'),
# is_an_ip_number?('-1'))

def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false unless dot_separated_words.size == 4
  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    return false unless is_an_ip_number?(word)
  end
  return true
end

puts(dot_separated_ip_address?("4.5.5"),
dot_separated_ip_address?("1.2.3.4.5"),
dot_separated_ip_address?("0.2.3.4"),
dot_separated_ip_address?("0.2.3.255"),
dot_separated_ip_address?("0.2.3.256"),
dot_separated_ip_address?("0.-5.3.4"),
dot_separated_ip_address?("0.-5.3.4"),
)