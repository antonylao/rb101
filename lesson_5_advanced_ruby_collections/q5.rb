require "pry"

# Figure out the total age of just the male members of the family.
munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

p (munsters.each_with_object([0]) do |(_, hash_value), total_male_age|
  # binding.pry
  total_male_age[0] += hash_value["age"] if hash_value["gender"] == "male"
end)[0]         #each_with_object(0) doesn't work because the object 0 is immutable, so the object cannot have a different value, we can only do assignments.

p ((munsters.select do |_, value_hash|
  value_hash["gender"] == "male"
end).map { |_, value_hash| value_hash["age"] }.reduce(:+))

# simple LS solution
total_male_age = 0
munsters.each_value do |details|
  total_male_age += details["age"] if details["gender"] == "male"
end

p total_male_age # => 444