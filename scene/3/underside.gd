extends MarginContainer


@onready var bg = $BG
@onready var index = $HBox/Index
@onready var difficulty = $HBox/Difficulty
@onready var reward = $HBox/Reward

var ladder = null
var step = null
var type = null
var part = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	step = input_.step
	
	init_basic_setting()
	step.set_stash(self)


func init_basic_setting() -> void:
	part = "obstacle"
	type = "stash"
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.stash
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.stash += 1
	
	var style = index.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.doorway.stash
	index.bg.visible = true
	
	input.subtype = 1
	difficulty.set_attributes(input)
	difficulty.custom_minimum_size = Global.vec.size.sixteen
	roll_difficulty()
	
	input.subtype = difficulty.get_number()
	reward.set_attributes(input)
	reward.custom_minimum_size = Global.vec.size.sixteen
	
	style = difficulty.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.difficulty
	difficulty.bg.visible = true


func roll_difficulty() -> void:
	var base = 1
	var modifiers = {}
	modifiers[0] = 9
	modifiers[1] = 4
	modifiers[2] = 1
	var modifier = Global.get_random_key(modifiers)
	var value = base + modifier
	difficulty.set_number(value)


func apply_impact(member_: MarginContainer) -> void:
	pass
