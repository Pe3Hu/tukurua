extends MarginContainer


@onready var bg = $BG
@onready var sky = $VBox/HBox/Sky
@onready var constellations = $VBox/HBox/Constellations
@onready var river = $VBox/River

var isle = null


func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.vastness = self
	sky.set_attributes(input)
	river.set_attributes(input)
