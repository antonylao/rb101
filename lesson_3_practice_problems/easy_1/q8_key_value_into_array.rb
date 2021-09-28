# Q8) Turn this into an array containing only two elements: Barney's name and Barney's number
flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }

array = flintstones.select { |name, number| name == 'Barney' }
array = array.to_a.flatten
p array

# LS Solution
# flintstones.assoc("Barney")