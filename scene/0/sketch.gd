extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var continent = $HBox/Continent


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	continent.set_attributes(input)
