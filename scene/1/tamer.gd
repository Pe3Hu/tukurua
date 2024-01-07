extends MarginContainer


@onready var gameboard = $VBox/Gameboard

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	var input = {}
	input.gambler = self
	gameboard.set_attributes(input)
