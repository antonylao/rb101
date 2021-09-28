ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

puts ages.keys.include?("Spot")

# Bonus: What are two other hash methods that would work just as well for this solution?

# Response: member?, has_key?, key?
puts ages.has_key?("Spot")
