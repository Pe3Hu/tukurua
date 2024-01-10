extends MarginContainer


@onready var bg = $BG
@onready var index = $Index
@onready var up = $Up
@onready var right = $Right
@onready var down = $Down
@onready var left = $Left
@onready var markers = $Markers

var isle = null
var grid = null
var border = null
var status = null
var obstacle = null
var aisles = {}
var neighbors = {}
var scenery = null
var region = null
var tower = null


func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	grid = input_.grid
	status = input_.status
	
	init_basic_setting()


func init_basic_setting() -> void:
	neighbors.next = null
	neighbors.prior = null
	custom_minimum_size = Global.vec.size.location
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	
	if status != "path":
		style.bg_color = Color.GRAY
	
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.location
	index.set_attributes(input)
	#index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.location += 1
	
	init_tower()
	set_frontiers()


func init_tower() -> void:
	if status == "corner":
		var input = {}
		input.isle = isle
		input.location = self
		
		var _tower = Global.scene.tower.instantiate()
		isle.towers.add_child(_tower)
		_tower.set_attributes(input)


func set_frontiers() -> void:
	for direction in Global.arr.direction:
		var frontier = get(direction)
		var input = {}
		input.location = self
		frontier.set_attributes(input)


func add_aisle(aisle_: MarginContainer, side_: String, type_: String) -> void:
	aisles[aisle_] = side_
	var frontier = get(side_)
	frontier.set_aisle(aisle_, type_)


func recolor(color_: String) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color(color_)


func paint(color_: Color) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color_


func rehue(hue_: float) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color.from_hsv(hue_, 1, 1)


func add_member(member_: MarginContainer) -> void:
	if member_.location != self:
		if Global.num.location.limit >= markers.get_child_count():
			if member_.marker == null:
				var input = {}
				input.type = "number"
				input.subtype = member_.index.get_number()
				
				member_.marker = Global.scene.icon.instantiate()
				markers.add_child(member_.marker)
				member_.marker.set_attributes(input)
				member_.marker.custom_minimum_size = Vector2(Global.vec.size.sixteen)
				member_.marker.bg.visible = true
				member_.location = self
			
			member_.location.markers.remove_child(member_.marker)
			markers.add_child(member_.marker)
			member_.location = self
		
		obstacle_impact(member_)
	else:
		neighbors.next.add_member(member_)


func obstacle_impact(member_: MarginContainer) -> void:
	if status == "finish":
		isle.active = false
		return
	
	if obstacle != null:
		var roles = {}
		
		for role in Global.arr.role:
			if role == Global.dict.obstacle.role[obstacle.type]:
				roles[role] = obstacle
			else:
				roles[role] = member_
		
		isle.encounter.set_roles(roles.aggressor, roles.defender)


func set_region(region_: MarginContainer) -> void:
	region = region_
	
	set_underside()


func set_underside() -> void:
	var corners = {}
	corners.x = [0, int(isle.dimensions.x) - 1]
	corners.y = [0, int(isle.dimensions.y) - 1]
	
	var vector = Vector2()
	
	for key in corners:
		var a = corners[key]
		var b = int(grid[key])
		
		if a.has(b):
			vector[key] = a.find(b) * 2 - 1
	
	var side = Global.dict.underside.linear[vector]
	vector = grid - vector
	neighbors.breach = isle.get_location(vector)
	var frontier = get(side)
	frontier.set_underside(neighbors.breach)
	neighbors.breach.choose_tower()


func choose_tower() -> void:
	var datas = []
	
	for _tower in isle.towers.get_children():
		var data = {}
		data.tower = _tower
		data.distance = _tower.location.grid.distance_to(grid)
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.distance < b.distance)
	var options = []
	
	for data in datas:
		if data.distance == datas.front().distance:
			options.append(data.tower)
	
	tower = options.pick_random()
