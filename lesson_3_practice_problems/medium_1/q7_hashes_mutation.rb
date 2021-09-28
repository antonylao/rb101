require "pry"
munsters = {
  "Herman": { "age" => 32, "gender" => "male" },
  "Lily": { "age" => 30, "gender" => "female" },
  "Grandpa": { "age" => 402, "gender" => "male" },
  "Eddie": { "age" => 10, "gender" => "male" },
  "Marilyn": { "age" => 23, "gender" => "female"}
}

def mess_with_demographics(demo_hash)
  # p demo_hash["Herman"].object_id            # => I added this.
  # p demo_hash.values[0].object_id                # => and this, to print/inspect the elements.
  demo_hash.values.each do |family_member|
    family_member["age"] += 42
    family_member["gender"] = "other"
  end
end

def mess_with_demographics(demo_hash)
  new_hash = {}
  demo_hash.each do |outside_key, inside_hash|
    inside_new_hash =  {}
    inside_hash.each do |inside_key, inside_value|
      case inside_key
      when "age" then inside_new_hash[inside_key] = inside_value + 42
      when "gender" then inside_new_hash[inside_key] = "other"
      end
    end
    new_hash[outside_key] = inside_new_hash
  end
  new_hash
end


def mess_with_demographics(demo_hash)
  new_hash = {}
  unless hash_of_hashes?(demo_hash)
    demo_hash.each do |key, value|
      case key
      when "age" then new_hash[key] = value + 42
      when "gender" then new_hash[key] = "other"
      end
    end
  else
    demo_hash.each do |key, inside_hash|
      new_hash[key] = mess_with_demographics(inside_hash)
    end
  end

  new_hash
end

def hash_of_hashes?(demo_hash)
  bool = true
  demo_hash.each_key do |key|
    bool = false unless demo_hash[key].is_a?(Hash)
  end
  bool
end



p mess_with_demographics(munsters)
p munsters
