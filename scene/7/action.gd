extends MarginContainer


var flow = null
var frequency = null


func set_attributes(input_: Dictionary) -> void:
	flow  = input_.flow
	frequency  = input_.frequency
	
	for type in Global.dict.stage.frequency[frequency]:
		var input = {}
		input.action = self
		input.duration = Global.dict.stage.frequency[frequency][type]
		input.type = type
		
		var stage = Global.scene.stage.instantiate()
		flow.stages.add_child(stage)
		stage.set_attributes(input)


func apply_effect() -> void:
	Global.rng.randomize()
	var damage = Global.rng.randi_range(6, 14)
