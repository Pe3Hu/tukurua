extends MarginContainer


@onready var bg = $BG
@onready var index = $HBox/Index
@onready var indexs = $HBox/Indexs

var isle = null
var locations = null


func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	locations = input_.locations
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.region
	Global.num.index.region += 1
	index.set_attributes(input)
	
	for location in locations:
		input.subtype = location.index.get_number()
		
		var icon = Global.scene.icon.instantiate()
		indexs.add_child(icon)
		icon.set_attributes(input)
		location.set_region(self)


func recolor_location_based_on_index() -> void:
	for location in locations:
		var hue = float(index.get_number()) / Global.num.index.region
		location.rehue(hue)
