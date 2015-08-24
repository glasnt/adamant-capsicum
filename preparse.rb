if ARGV.length == 0 then
  puts "requires an input file"
  exit 1
end

file = File.open(ARGV[0]).read.split("\n")

output = ARGV[1] if ARGV.length > 1

result = []

file.each do |line|
  append = ""
  type = line.split(" ").first
  if line.strip.length == 0
    result << ""
    next
  end

  content = line.split(" ")[1..-1].join(" ")

  # Ignore generic line separators
  if type == "---" then
    result << type
    next
  end

  # Fragment
  if type.include? "-" then
    append = " <!-- .element: class=\"fragment\" -->"
    type.gsub!("-","")
  end

  # h1 defaulting to top with padding
  if type == "#" then
    append = " <!-- .element: style=\"margin-bottom: 1em\" -->"
  end
  
  # Center
  if type.include? "=" then
    append = " <!-- .slide: class=\"center\" -->"
    type.gsub!("=","")
  end

  # h0
  if ["!#","!#="].include? type then
    append += " <!-- .element style=\"font-size: 4em\" --> "
    type.gsub!("!","")
  end

  r = "#{type} #{content}#{append}"
  result << r
end

if output
  File.open(output, "w") { |f| f.write result.join("\n") }
  puts "Outputted parsed markdown to #{output}"
else 
  puts result.join("\n")
end

