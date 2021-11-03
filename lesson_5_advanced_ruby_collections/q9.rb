# Given this data structure, return a new array of the same structure but with the sub arrays being ordered
# (alphabetically or numerically as appropriate) in descending order.

arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

p (arr.map do |sub_array|
  sub_array.sort {|elt_a, elt_b| elt_b <=> elt_a}
end)