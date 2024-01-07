extends MarginContainer


@onready var bg = $BG
@onready var index = $HBox/Index
@onready var difficulty = $HBox/Difficulty
@onready var entry = $HBox/Entry
@onready var exit = $HBox/Exit

var isle = null
var locations = null
var direction = null
var measure = null
var type = null
var part = null


func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	locations = input_.locations
	direction = input_.direction
	measure = input_.measure
	part = "obstacle"
	
	if measure == "stairwell":
		type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.aisle
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.aisle += 1
	var style = index.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.frontier.entry
	index.bg.visible = true
	
	input.subtype = 0
	difficulty.set_attributes(input)
	difficulty.custom_minimum_size = Global.vec.size.sixteen
	style = difficulty.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.difficulty
	difficulty.bg.visible = true
	
	match measure:
		"location":
			locations.front().neighbors.next = locations.back()
			locations.back().neighbors.prior = locations.front()
		"stairwell":
			roll_difficulty()
	
	for _i in locations.size():
		var location = locations[_i]
		var _type = null
		
		match _i:
			0:
				_type = "entry"
			1:
				_type = "exit"
		
		set_frontier(location, _type)


func set_frontier(location_: MarginContainer, type_: String) -> void:
	var icon = get(type_)
	var input = {}
	input.type = "number"
	input.subtype = location_.index.get_number()
	icon.set_attributes(input)
	icon.custom_minimum_size = Global.vec.size.sixteen
	
	var style = StyleBoxFlat.new()
	style.bg_color = Global.color.frontier[type_]
	icon.bg.set("theme_override_styles/panel", style)
	#var style = icon.bg.get("theme_override_styles/panel")
	#style.bg_color = Global.color.frontier[type_]
	
	var side = Global.dict.aisle.side[direction][type_]
	location_.add_aisle(self, side, type_)


func roll_difficulty() -> void:
	var base = 2
	
	if Global.dict.obstacle.role[type] == "aggressor":
		base -= 1
	
	var modifiers = {}
	modifiers[0] = 9
	modifiers[1] = 4
	modifiers[2] = 1
	var modifier = Global.get_random_key(modifiers)
	var value = base + modifier
	difficulty.set_number(value)


func apply_impact(member_: MarginContainer) -> void:
	var end = isle.locations.get_child(exit.get_number())
	end.add_member(member_)
