extends MarginContainer


@onready var bg = $BG
@onready var steps = $HBox/Steps
@onready var left = $HBox/Left
@onready var right = $HBox/Right
@onready var index = $HBox/Index
@onready var difficulty = $HBox/Difficulty
@onready var power = $HBox/Power

var ladder = null
var type = null
var route = null
var step = null
var direction = null
var part = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	type = input_.type
	route = input_.route
	part = "obstacle"
	
	init_icons()
	roll_difficulty()
	roll_power()
	roll_step()
	roll_direction()


func init_icons() -> void:
	for _step in route:
		var input = {}
		input.type = "number"
		input.subtype = _step.index.get_number()
		
		var icon = Global.scene.icon.instantiate()
		steps.add_child(icon)
		icon.set_attributes(input)
		icon.bg.visible = true
		icon.custom_minimum_size = Vector2(Global.vec.size.sixteen)
		step = _step
		recolor("passive")
	
	step = null
	
	var input = {}
	input.type = "number"
	input.subtype = route.front().grid.y
	
	index.set_attributes(input)
	index.custom_minimum_size = Vector2(Global.vec.size.sixteen)
	index.bg.visible = true
	var style = index.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.traveler[type]


func roll_difficulty() -> void:
	var base = 2
	
	if Global.dict.obstacle.role[type] == "aggressor":
		base -= 1
	
	var modifiers = {}
	modifiers[0] = 9
	modifiers[1] = 4
	modifiers[2] = 1
	var modifier = Global.get_random_key(modifiers)
	
	var input = {}
	input.type = "number"
	input.subtype = base + modifier
	difficulty.set_attributes(input)
	difficulty.custom_minimum_size = Vector2(Global.vec.size.sixteen)
	var style = difficulty.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.difficulty
	difficulty.bg.visible = true


func roll_power() -> void:
	var limits = {}
	limits.min = round(ladder.dimensions.y * 3.0 / 4.0)
	limits.max = round(ladder.dimensions.y * 5.0 / 4.0)
	
	var input = {}
	input.type = "number"
	Global.rng.randomize()
	input.subtype = Global.rng.randi_range(limits.min, limits.max)
	power.set_attributes(input)
	power.custom_minimum_size = Vector2(Global.vec.size.sixteen)


func roll_step() -> void:
	step = route.pick_random()
	take_step()


func roll_direction() -> void:
	var directions = ["left", "right"]
	
	for _direction in directions:
		var input = {}
		input.type = "triangle"
		input.subtype = _direction
		
		var _icon = get(_direction)
		_icon.set_attributes(input)
		_icon.custom_minimum_size = Vector2(Global.vec.size.sixteen)
	
	var _index = route.find(step)
	
	if _index == 0:
		directions.erase("left")
	
	if _index == route.size() - 1:
		directions.erase("right")
	
	direction = directions.pick_random()
	var icon = get(direction)
	icon.visible = true


func enroute() -> void:
	step_out()
	var _index = route.find(step)
	
	match direction:
		"left":
			_index -= 1
		"right":
			_index += 1
	
	step = route[_index]
	take_step()
	update_direction()


func update_direction() -> void:
	var _index = route.find(step)
	
	if _index == 0 and direction == "left":
		var icon = get(direction)
		icon.visible = false
		direction = "right"
		icon = get(direction)
		icon.visible = true
	
	if _index == route.size() - 1 and direction == "right":
		var icon = get(direction)
		icon.visible = false
		direction = "left"
		icon = get(direction)
		icon.visible = true


func recolor(status_: String) -> void:
	var _index = route.find(step)
	var icon = steps.get_child(_index)
	
	var style = icon.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.route[status_]


func take_step() -> void:
	step.obstacle = self
	recolor("active")
	
	var side = Global.dict.traveler.trail[type]
	var trail = step.get(side)
	trail.traveler_came(self)


func step_out() -> void:
	step.obstacle = null
	recolor("passive")
	
	var side = Global.dict.traveler.trail[type]
	var trail = step.get(side)
	trail.traveler_gone()


func apply_impact(member_: MarginContainer) -> void:
	var multiplier = 1
	
	if Global.dict.traveler.trail[type] == "up":
		multiplier = -1
	
	var distance = power.get_number() * multiplier
	var end = ladder.get_end_of_advancement(member_.step, distance)
	end.add_member(member_)
