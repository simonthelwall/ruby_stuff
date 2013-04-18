!#/usr/bin/env ruby
require 'open-uri'

# Get a bunch of csv files in one go. 
# http://data.gov.uk/dataset/gp-practice-prescribing-data

# First extract all the urls that mention .csv from the motherpage

f = File.open("data_motherpage.html","r").readlines

a = []
f.each do
	|line|
	a << line.scan(/\"http.*\.csv\"/i)
end

# cleanup links
a = a.uniq
#puts a.class
b = a.collect{
	|link|
	link = link.to_s
	link.gsub!(/\\/,"")
	link.gsub!(/\"/,"")
	link.gsub!(/\[/,"")
	link.gsub!(/\]/,"")
}
b.reject!{|link| link.empty?}
b.each do
	|link|
	puts "Downloading file: #{link}"
	c = link.gsub(/http:.*uk\//,"")
	puts c
	File.open(c,"wb") do |file|
		open(link).read do |uri|
			file.write{uri}
		end
	end
end
