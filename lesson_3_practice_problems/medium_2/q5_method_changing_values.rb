def tricky_method(a_string_param, an_array_param)
  # if we do not want to change the value
  copy_string = a_string_param.clone
  copy_array = an_array_param.clone
  copy_array = copy_array.collect { |value| value.clone }
  p copy_array[0].object_id

  copy_string += "rutabaga"
  copy_array += ["rutabaga"]
  return copy_string, copy_array
end

my_string = "pumpkins"
my_array = ["pumpkins"]
p my_array[0].object_id
my_string, my_array = tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"
