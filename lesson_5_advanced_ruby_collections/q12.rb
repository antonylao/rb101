#Transform into a hash without using Array#to_h method

arr = [[:a, 1], ['b', 'two'], ['sea', {c: 3}], [{a: 1, b: 2, c: 3, d: 4}, 'D']]
# expected return value: {:a=>1, "b"=>"two", "sea"=>{:c=>3}, {:a=>1, :b=>2, :c=>3, :d=>4}=>"D"}

hash = {}

arr.each do |sub_array|
  key = sub_array[0]
  value = sub_array[1]

  hash[key] = value
end

p hash