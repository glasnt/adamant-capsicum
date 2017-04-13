#!/usr/bin/env ruby
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

  # Image as the main attraction
  if type == "@^" then
    content = "<img src=\"pictures/#{content}\" style=\"margin-top: -50px\" />"
    type = ""
  end

  # Image in the center
  if type == "@=" then

    append = " <!-- .slide: class=\"center\" -->"
	content = "<div style='margin: 0 auto;'><p align='center'><img src='pictures/#{content}'></p></div> "
    type = ""
  end

  # Nice Code
  if type.include? "#>" then
    content = "<div style='margin-bottom:0px; font-size: 80px'><pre style='margin-bottom:0px;margin-top:0px'><code style=\"font: 'monospace' 150%\">#{content}</code></pre></div>"
    type.gsub!("#>","")
  end
  

  # Shortcut for images. Assumes assets live in pictures/
  if type == "@" then
    content = "<img src=\"pictures/#{content}\" />"
    type.gsub!("@","")
  end

  if type == '!' then
    append = " <!-- .slide: class=\"center\" -->"
    type.gsub!("!","")
    if content.include? "|" then
	    c = "<div style='width: 100%; margin: 0 auto;'><p align='center'>"
	    l = content.split("|").length
	    a = 800 / l
	    content.split("|").each do |s|
	      t = ( s.include? "png") ? s.strip! : "#{s.strip!}.svg"
	      c += "<img height='#{a}px' src='pictures/#{t}'>"
            end
            c += "</p></div>"
            content = c
    else 
	    content = "<div style='width: 50%; margin: 0 auto;'><p align='center'><img height='400px' src='pictures/#{content}.svg'></p></div>"
    end
  end

  # dasfoot
  if type == "vv" then
	content = "<span class='foot'>#{content}</span>"
    type.gsub!("vv","")
  end

  # Ignore generic line separators
  if type == "---" then
    result << type
    next
  end

  # Fragment
  if type.end_with? "-" then
    append = " <!-- .element: class=\"fragment\" -->"
    type.gsub!("-","")
  end

  # Center
  if type.include? "=" then
    append = " <!-- .slide: class=\"center\" -->"
    type.gsub!("=","")
  end


  
  # h0
  if ["!#","!#="].include? type then
    append += " <!-- .slide: class=\"center\" -->"
    append += " <!-- .element style=\"font-size: 5em\" --> "
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

