string = "The Flintstones Rock!"

10.times do
  puts string.prepend(" ")
end

# LS: 10.times { |number| puts (" " * number) + "The Flintstones Rock!" }