puts "Starting parsing json to CSV"

require 'json'
require 'pry'
file = File.read('dump.json')

data_hash = JSON.parse(file)

props = data_hash[0]["textAnnotations"]

rolling_file_text = ""
header = "x1,y1,x2,y2,x3,y3,x4,y4,extracted_text\n"
rolling_file_text += header

last_x1 = 0
last_y1 = 0
last_x2 = 0
last_y2 = 0
last_x3 = 0
last_y3 = 0
last_x4 = 0
last_y4 = 0
last_desc = ""
last_row = ""


props.each_with_index do |prop, index|
	if index == 0
		next
	end

	desc = prop["description"].tr(',', '')

	#create CSV line
	x1 = prop["boundingPoly"]["vertices"][0]["x"]
	y1 = prop["boundingPoly"]["vertices"][0]["y"]

	x2 = prop["boundingPoly"]["vertices"][1]["x"]
	y2 = prop["boundingPoly"]["vertices"][1]["y"]

	x3 = prop["boundingPoly"]["vertices"][2]["x"]
	y3 = prop["boundingPoly"]["vertices"][2]["y"]

	x4 = prop["boundingPoly"]["vertices"][3]["x"]
	y4 = prop["boundingPoly"]["vertices"][3]["y"]

	# calculate if should merge
	if (x1 <= last_x2 + 5 && ((y2 >= last_y2 - 1) && (y2 <= last_y2 + 1)))
		should_merge = true
	end
	

	#merge props
	if should_merge
		x1 = last_x1
		y1 = last_y1
		x4 = last_x4
		y4 = last_y4
		desc = "#{last_desc} #{desc}"
	end

	last_x1 = x1
	last_y1 = y1
	last_x2 = x2
	last_y2 = y2
	last_x3 = x3
	last_y3 = y3
	last_x4 = x4
	last_y4 = y4
	last_desc = desc

	origin_row = "#{x1},#{y1},#{x2},#{y2},#{x3},#{y3},#{x4},#{y4},#{desc}\n"
	#binding.pry
	if should_merge || index == 1
		last_row = origin_row
	else
		puts "#{last_row}"
		rolling_file_text += last_row
		last_row = origin_row
	end

end

begin
  file = File.open("example3.csv", "w")
  file.write(rolling_file_text) 
rescue IOError => e
  #some error occur, dir not writable etc.
ensure
  file.close unless file.nil?
end
