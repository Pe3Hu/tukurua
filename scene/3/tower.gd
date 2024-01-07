extends MarginContainer


@onready var kind = $Kind

var isle = null
var location = null


func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	location = input_.location
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.type = "tower"
	input.subtype = Global.arr.tower[Global.num.index.tower]
	Global.num.index.tower += 1
	kind.set_attributes(input)
