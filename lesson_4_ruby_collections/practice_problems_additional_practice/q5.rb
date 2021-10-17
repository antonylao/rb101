flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# Find the index of the first name that starts with "Be"
index_name = 0

flintstones.each_with_index do |name, index|
  if name[0..1] == 'Be'
    index_name = index
  end
end

p index_name

#LS : flintstones.index { |name| name[0, 2] == "Be" }