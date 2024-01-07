extends MarginContainer


@onready var icons = $Icons

var ladder = null
var winners = []


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	winners = input_.winners
	
	init_icons()
	medalize()


func init_icons() -> void:
	for _i in icons.columns:
		for _j in icons.columns:
			var input = {}
			input.type = "number"
			input.subtype = 0
			
			var icon = Global.scene.icon.instantiate()
			icons.add_child(icon)
			icon.set_attributes(input)
			icon.custom_minimum_size = Global.vec.size.place
			icon.number.visible = false


func medalize() -> void:
	visible = true
	var places = [1, 3, 8]
	
	for _i in winners.size():
		var member = winners[_i]
		var place = places[_i]
		var icon = icons.get_child(place)
		icon.set_number(member.index.get_number())
		icon.number.visible = true
		
		var style = icon.bg.get("theme_override_styles/panel")
		style.bg_color = Global.color.place[_i]
		icon.bg.visible = true
