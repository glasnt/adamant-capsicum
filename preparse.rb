if ARGV.length == 0 then
  puts "requires an input file"
  exit 1
end

file = File.open(ARGV[0]).read.split("\n")

result = []

file.each do |line|
  append = ""
  type = line.split(" ").first
  if line.length == 0
    result << ""
    next
  end
  content = line.split(" ")[1..-1].join(" ")

  if type.include? "-" then
    append = " <!-- .element: class=\"fragment\" -->"
    type.gsub!("-","")
  end

  if type == "#" then
    append = " <!-- .element: style=\"margin-bottom: 1em\" -->"
  end
  
  if type.include? "=" then
    append = " <!-- .slide: class=\"center\" -->"
    type.gsub!("=","")
  end

  if ["!#","!#="].include? type then
    append += " <!-- .element class=\"h0\" --> "
    type.gsub!("!","")
  end

  r = "#{type} #{content}#{append}"
  result << r
end



puts result.join("\n")

