extends MarginContainer


@onready var locations = $VBox/HBox/Locations
@onready var aisles = $VBox/HBox/Aisles
@onready var undersides = $VBox/HBox/Undersides
@onready var travelers = $VBox/HBox/Travelers
@onready var squads = $VBox/HBox/Squads
@onready var queue = $VBox/HBox/Queue
@onready var encounter = $VBox/Encounter
@onready var podium = $VBox/Podium
@onready var regions = $VBox/HBox/Regions
@onready var towers = $VBox/HBox/Towers
@onready var timer = $Timer

var continent = null
var dimensions = null
var iteration = 0
var active = true


func set_attributes(input_: Dictionary) -> void:
	continent = input_.continent
	dimensions = input_.dimensions
	
	init_locations()
	init_aisles()
	#init_undersides()
	#init_travelers()
	Engine.time_scale = 3


func init_locations() -> void:
	locations.columns = dimensions.x
	var corners = {}
	corners.x = [0, int(dimensions.x - 1)]
	corners.y = [0, int(dimensions.y - 1)]
	
	for _i in dimensions.y:
		for _j in dimensions.x:
			var input = {}
			input.isle = self
			input.grid = Vector2(_j, _i)
			var x = corners.x.has(int(_j))
			var y = corners.y.has(int(_i))
			
			if x or y:
				if x and y:
					input.status = "corner"
				else:
					input.status = "edge"
			else:
				input.status = "center"
			
			var location = Global.scene.location.instantiate()
			locations.add_child(location)
			location.set_attributes(input)


func init_aisles() -> void:
	var grid = Vector2.ZERO
	var n = Global.dict.neighbor.linear2.size()
	
	for _i in n + 1:
		var _j = _i % n
		var shift = Global.dict.neighbor.linear2[_j]
		var input = {}
		input.isle = self
		input.direction = Global.arr.direction[_j]
		input.measure = "location"
		
		while get_location(grid + shift) != null:
			input.locations = []
			var location = get_location(grid)
			input.locations.append(location)
			
			grid += shift
			location = get_location(grid)
			input.locations.append(location)
			
			var aisle = Global.scene.aisle.instantiate()
			aisles.add_child(aisle)
			aisle.set_attributes(input)
			aisle.visible = false
	
	init_regions()
	init_sceneries()


func init_regions() -> void:
	var grid = Vector2.ZERO
	var location = get_location(grid)
	
	while location.grid != Vector2() or Global.num.index.region == 0:
		var input = {}
		input.isle = self
		input.locations = []
		
		for _i in Global.num.size.region:
			location = location.neighbors.next
			input.locations.append(location)
		
		var region = Global.scene.region.instantiate()
		regions.add_child(region)
		region.set_attributes(input)
		location = location.neighbors.next
	
	for region in regions.get_children():
		region.recolor_location_based_on_index()


func init_sceneries() -> void:
	for region in regions.get_children():
		for location in region.locations:
			var neighbor = location.neighbors.breach
			var kind = neighbor.tower.kind.subtype
			neighbor.paint(Global.color.tower[kind])


func init_undersides() -> void:
	var options = []
	
	for location in locations.get_children():
		if location.status == "path" and location.border: 
			options.append(location)
	
	var n = 5
	
	for _i in n:
		var location = options.pick_random()
		options.erase(location)
		
		var input = {}
		input.isle = self
		input.location = location
		
		var breach = Global.scene.breach.instantiate()
		undersides.add_child(breach)
		breach.set_attributes(input)


func init_travelers() -> void:
	var routes = {}
	routes["down to up"] = []
	routes["up to down"] = []
	
	for direction in routes:
		var words = direction.split(" ")
		var side = words[2]
		var grid = Vector2(1, 0)
		var location = get_location(grid)
		var route = [location]
		
		while location.status != "finish":
			location = location.neighbors.next
			
			if !location.get(side).visible:
				route.append(location)
			else:
				if route.size() > 2:
					routes[direction].append(route)
				
				route = []
		
		route.pop_back()
		
		if route.size() > 2:
			routes[direction].append(route)
		
		match direction:
			"down to up":
				route = routes[direction].front()
				
				while route.front().grid.y == 0:
					routes[direction].pop_front()
					route = routes[direction].front()
			"up to down":
				route = routes[direction].back()
				
				while route.front().grid.y == dimensions.y - 1:
					routes[direction].pop_back()
					route = routes[direction].back()
	
	var stairwells = {}
	var types = {}
	
	for type in Global.arr.traveler:
		types[type] = []
	
	for _i in dimensions.y:
		stairwells[_i] = {}
	
	for direction in routes:
		for route in routes[direction]:
			var stairwell = route.front().grid.y
			stairwells[stairwell][direction] = route
	
	for stairwell in stairwells:
		if stairwells[stairwell].keys().size() == 1:
			var direction = stairwells[stairwell].keys().front()
			
			for obstacle in Global.dict.obstacle.direction:
				if Global.dict.obstacle.direction[obstacle] == direction and types.has(obstacle):
					var route = stairwells[stairwell][direction]
					types[obstacle].append(route)
	
	for stairwell in stairwells:
		if stairwells[stairwell].keys().size() == 2:
			var direction = stairwells[stairwell].keys().pick_random()
			
			if types.guardian.size() > types.sage.size():
				direction = "up to down"
				
			if types.guardian.size() < types.sage.size():
				direction = "down to up"
			
			for obstacle in Global.dict.obstacle.direction:
				if Global.dict.obstacle.direction[obstacle] == direction and types.has(obstacle):
					var route = stairwells[stairwell][direction]
					types[obstacle].append(route)
	
	var colors = {}
	colors["guardian"] = "red"
	colors["sage"] = "blue"
	
	for type in types:
		for route in types[type]:
			var input = {}
			input.isle = self
			input.type = type
			input.route = route
			
			var traveler = Global.scene.traveler.instantiate()
			travelers.add_child(traveler)
			traveler.set_attributes(input)


func check_grid(grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and dimensions.y > grid_.y and dimensions.x >  grid_.x


func get_location(grid_: Vector2) -> Variant:
	if check_grid(grid_):
		var index = grid_.y * dimensions.x + grid_.x
		return locations.get_child(index)
	
	return null


func next_iteration() -> void:
	timer.paused = true
	
	for traveler in travelers.get_children():
		traveler.enroute()
	
	queue.rest()
	timer.paused = false 


func _on_timer_timeout():
	if active:
		queue.activation()
	else:
		timer.paused = true
		awarding()


func add_squad(squad_: MarginContainer) -> void:
	squad_.isle = self
	squads.add_child(squad_)


func commence() -> void:
	var input = {}
	input.isle = self
	queue.set_attributes(input)
	encounter.set_attributes(input)
	timer.start()


func get_end_of_advancement(start_: MarginContainer, distance_: int) -> MarginContainer:
	var end = start_
	var key = null
	
	match sign(distance_):
		1:
			key = "next"
		-1:
			key = "prior"
	
	for _i in abs(distance_):
		if end.neighbors[key] != null:
			end = end.neighbors[key]
		else:
			break
	
	return end


func awarding() -> void:
	var members = []
	
	for squad in squads.get_children():
		for member in squad.members.get_children():
			members.append(member)
	
	members.sort_custom(func(a, b): return a.location.index.get_number() > b.location.index.get_number())
	
	var input = {}
	input.isle = self
	input.winners = []
	
	for _i in 3:
		input.winners.append(members[_i])
	
	podium.set_attributes(input)
