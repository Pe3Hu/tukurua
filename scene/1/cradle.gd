extends MarginContainer


@onready var tamers = $Tamers

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_tamers()


func init_tamers() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var tamer = Global.scene.tamer.instantiate()
		tamers.add_child(tamer)
		tamer.set_attributes(input)
