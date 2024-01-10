extends MarginContainer


@onready var consumer = $VBox/Flows/Consumer
@onready var supplier = $VBox/Flows/Supplier

var vastness = null


func set_attributes(input_: Dictionary) -> void:
	vastness  = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	for organ in Global.arr.organ:
		var input = {}
		input.river = self
		input.kind = organ
		
		var flow = get(organ)
		flow.set_attributes(input)
	
	#skip_shortest_ticks()

 
func get_shortest_stage() -> MarginContainer:
	var datas = []
	
	for kind in Global.arr.organ:
		var flow = get(kind)
		
		if flow.stages.get_child_count() > 0:
			var data = {}
			data.stage = flow.stages.get_child(0)
			data.duration = data.stage.get_upcoming_ticks()
			datas.append(data)
	
	datas.sort_custom(func(a, b): return a.duration < b.duration)
	return datas.front().stage


func skip_shortest_ticks() -> void:
	var stage = get_shortest_stage()
	print(stage.get_upcoming_ticks())
	
	for kind in Global.arr.kind:
		var flow = get(kind)
		flow.ticks.next = stage.get_upcoming_ticks()
		flow.tween_ticks()
