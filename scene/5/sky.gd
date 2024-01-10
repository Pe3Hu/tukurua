extends MarginContainer


@onready var bg = $BG
@onready var stars = $Stars
@onready var cords = $Cords
@onready var blocks = $Blocks

var vastness = null
var center = null
var grids = {}
var rings = {}


func set_attributes(input_: Dictionary) -> void:
	vastness = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.sky)
	center = custom_minimum_size * 0.5
	
	init_stars()
	init_cords()
	init_blocks()
	init_constellations()


func init_stars() -> void:
	grids.star = {}
	stars.position = center
	var input = {}
	input.sky = self
	input.position = Vector2()
	input.grid = Vector3()
	
	var star = Global.scene.star.instantiate()
	stars.add_child(star)
	star.set_attributes(input)
	
	var n = 4
	var angle = 2 * PI / Global.num.size.hex
	var l = Global.num.cord.l
	var start = Vector2()
	var grid = Vector3()
	
	for _i in range(1, n, 1):
		start += Vector2(1, 0).rotated(-angle) * l
		grid += Global.dict.coordinates.cube[0]
		
		for _j in Global.num.size.hex:
			input.position = Vector2(start)
			input.grid = Vector3(grid)
			var step = Global.dict.coordinates.cube[(_j + 2) % Global.num.size.hex]
			
			star = Global.scene.star.instantiate()
			stars.add_child(star)
			star.set_attributes(input)
			
			for _k in _i - 1:
				start += Vector2(1, 0).rotated(angle * (_j + 1)) * l
				grid += step
				
				input.position = Vector2(start)
				input.grid = Vector3(grid)
				star = Global.scene.star.instantiate()
				stars.add_child(star)
				star.set_attributes(input)
			
			start += Vector2(1, 0).rotated(angle * (_j + 1)) * l
			grid += step


func init_cords() -> void:
	cords.position = center
	
	for star in stars.get_children():
		for direction in Global.dict.coordinates.cube:
			var grid = star.grid + direction
			
			if grids.star.has(grid):
				var neighbor = grids.star[grid]
				
				if !star.neighbors.has(neighbor):
					add_cord(star, neighbor, direction)


func add_cord(first_: Polygon2D, second_: Polygon2D, direction_: Vector3) -> void:
	var input = {}
	input.sky = self
	input.stars = [first_, second_]
	
	var cord = Global.scene.cord.instantiate()
	cords.add_child(cord)
	cord.set_attributes(input)
	
	first_.neighbors[second_] = cord
	second_.neighbors[first_] = cord
	first_.cords[cord] = second_
	second_.cords[cord] = first_
	first_.directions[direction_] = cord
	var index = Global.dict.coordinates.cube.find(direction_)
	index = (index + Global.num.size.hex / 2) % Global.num.size.hex
	second_.directions[Global.dict.coordinates.cube[index]] = cord


func init_blocks() -> void:
	grids.block = {}
	blocks.position = center
	rings.block = {}
	rings.block[1] = []
	
	for star in stars.get_children():
		for _i in Global.num.size.hex:
			var _stars = [star]
			
			for _j in range(1, 3, 1):
				var index = (_i + _j - 1 + Global.num.size.hex) % Global.num.size.hex
				var direction = Global.dict.coordinates.cube[index]
				
				if star.directions.has(direction):
					var cord = star.directions[direction]
					var neighbor = cord.get_another_star(star)
					_stars.append(neighbor)
			
			if _stars.size() == 3:
				add_block(_stars)
	
	init_blocks_neighbors()


func add_block(stars_: Array) -> void:
	var input = {}
	input.sky = self
	input.cords = {}
	
	for _i in stars_.size():
		var star = stars_[_i]
		var neighbor = stars_[(_i + 1) % stars_.size()]
		var cord = star.neighbors[neighbor]
		var foundation = stars_[(_i + 2) % stars_.size()]
		
		if !cord.foundations.has(foundation) and cord.foundations.keys().size() < 2:
			input.cords[cord] = star
	
	if input.cords.keys().size() == stars_.size():
		var block = Global.scene.block.instantiate()
		blocks.add_child(block)
		block.set_attributes(input)
		
		var ring = rings.block.keys().back()
		var l = Global.num.size.hex * (ring * 2 - 1)
		rings.block[ring].append(block)
		block.ring = ring
		
		if rings.block[ring].size() == l:
			rings.block[ring + 1] = []


func init_blocks_neighbors() -> void:
	var n = 2
	
	for cord in cords.get_children():
		if cord.blocks.keys().size() == n:
			for _i in n:
				var block = cord.blocks.keys()[_i]
				var neighbor = cord.blocks.keys()[(_i + 1) % n]
				block.neighbors[neighbor] = cord


func init_constellations() -> void:
	for _i in 3:
		var dimensions = 6
		add_constellation(dimensions)


func add_constellation(dimensions_: int) -> void:
	var input = {}
	input.sky = self
	input.blocks = []
	
	for _i in dimensions_:
		var options = fill_block_options(input.blocks)
		var block = Global.get_random_key(options)
		
		if block != null:
			input.blocks.append(block)
	
	var constellation = Global.scene.constellation.instantiate()
	vastness.constellations.add_child(constellation)
	constellation.set_attributes(input)


func fill_block_options(blocks_: Array) -> Dictionary:
	var options = {}
	var neighbors = []
	var weight = rings.block.keys().back() + 1
	
	if !blocks_.is_empty():
		for block in blocks_:
			for neighbor in block.neighbors:
				if neighbor.status == "freely" and !neighbors.has(neighbor) and !blocks_.has(neighbor):
					neighbors.append(neighbor)
	else:
		#neighbors.append_array(blocks.get_children())
		
		for ring in rings.block:
			for block in rings.block[ring]:
				if block.status == "freely":
					neighbors.append(block)
			
			if !neighbors.is_empty():
				break
	
	for neighbor in neighbors:
		options[neighbor] = weight - neighbor.ring
	#for ring in rings.block:
		#for block in rings.block[ring]:
			#if neighbors.has(block):
				#options.append(block)
	
	return options
