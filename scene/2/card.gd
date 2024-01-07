extends MarginContainer


@onready var bg = $BG
@onready var suit = $Suit
@onready var rank = $Rank

var area = null
var gameboard = null


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.type = "suit"
	input.subtype = input_.suit
	suit.set_attributes(input)
	custom_minimum_size = Global.vec.size.suit
	
	input.type = "number"
	input.subtype = input_.rank
	rank.set_attributes(input)
	rank.custom_minimum_size = Global.vec.size.rank
	
	#suit.set("theme_override_constants/margin_left", 4)
	#suit.set("theme_override_constants/margin_top", 4)
	custom_minimum_size = suit.custom_minimum_size + rank.custom_minimum_size * 0.5

	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func set_selected(selected_: bool) -> void:
	var style = bg.get("theme_override_styles/panel")
	
	match selected_:
		true:
			style.bg_color = Global.color.card.selected
			pass
		false:
			style.bg_color = Global.color.card.unselected
