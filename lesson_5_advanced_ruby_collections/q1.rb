# How would you order this array of number strings by descending numeric value?
arr = ['10', '11', '9', '7', '8']

p arr.sort { |elt_a, elt_b| elt_b.to_i <=> elt_a.to_i }