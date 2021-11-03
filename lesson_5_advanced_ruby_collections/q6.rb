# Given this previously seen family hash, print out the name, age and gender of each family member like this:

# (Name) is a (age)-year-old (male or female).

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

munsters.each do |name, hash_value|
  age = hash_value["age"]
  gender = hash_value["gender"]
  puts "#{name} is a #{age}-year-old #{gender}"
end