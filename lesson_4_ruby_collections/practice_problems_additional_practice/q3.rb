ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

# remove people with age 100 and greater.
p ages.select! { |key, value| value < 100 }  # or ages.keep_if { |_, age| age < 100 }