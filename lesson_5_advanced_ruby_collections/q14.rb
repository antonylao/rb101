# Given this data structure write some code to return an array
# containing the colors of the fruits and the sizes of the vegetables.
# The sizes should be uppercase and the colors should be capitalized.


require 'pry'

hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}


p (hsh.each_value.with_object([]) do |sub_hash, colors_and_sizes|
  # binding.pry
  if sub_hash[:type] == 'fruit'
    color_array = []
    sub_hash[:colors].each do |color|
      color_array << color.capitalize
    end
    colors_and_sizes << color_array

  elsif sub_hash[:type] == 'vegetable'
    colors_and_sizes << sub_hash[:size].upcase
  end
end)

# LS Solution
hsh.map do |_, value|
  if value[:type] == 'fruit'
    value[:colors].map do |color|
      color.capitalize
    end
  elsif value[:type] == 'vegetable'
    value[:size].upcase
  end
end
# => [["Red", "Green"], "MEDIUM", ["Red", "Green"], ["Orange"], "LARGE"]