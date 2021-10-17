require 'pry'

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}
# add 'age_group' for each member of the munsters family
# a kid is in the age range 0 - 17, an adult is in the range 18 - 64 and a senior is aged 65+.

# result:
# { "Herman" => { "age" => 32, "gender" => "male", "age_group" => "adult" },
#   "Lily" => {"age" => 30, "gender" => "female", "age_group" => "adult" },
#   "Grandpa" => { "age" => 402, "gender" => "male", "age_group" => "senior" },
#   "Eddie" => { "age" => 10, "gender" => "male", "age_group" => "kid" },
#   "Marilyn" => { "age" => 23, "gender" => "female", "age_group" => "adult" } }

def age_group_str(age)
  string = case age
           when (0..17) then "kid"
           when (18..64) then "adult"
           when (65..) then "senior"
           end

  string
end

munsters.each_key do |name|
  infos = munsters[name]
  infos['age_group'] = age_group_str(infos['age'])
end

# LS Solution

# munsters.each do |name, details|
#   case details["age"]
#   when 0...18
#     details["age_group"] = "kid"
#   when 18...65
#     details["age_group"] = "adult"
#   else
#     details["age_group"] = "senior"
#   end
# end


p munsters