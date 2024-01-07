extends MarginContainer


@onready var isles = $Isles

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_isles()


func init_isles() -> void:
	for _i in 1:
		var input = {}
		input.continent = self
		input.dimensions = Vector2.ONE * Global.num.size.isle
	
		var isle = Global.scene.isle.instantiate()
		isles.add_child(isle)
		isle.set_attributes(input)
