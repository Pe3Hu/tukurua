extends MarginContainer


@onready var index = $HBox/Index
@onready var impact = $HBox/Impact
@onready var health = $HBox/Health
@onready var energy = $HBox/Energy

var constellation = null
var block = null
var kind = null
var role = null
var suppliers = []
var consumers = []


func set_attributes(input_: Dictionary) -> void:
	constellation = input_.constellation
	block = input_.block
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()
	identify_adjacent_blocks()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.organ
	index.set_attributes(input)
	Global.num.index.organ += 1
	block.set_organ(self)


func identify_adjacent_blocks() -> void:
	if Global.dict.block.organ[block.kind] == "supplier":
		var kinds = {}
		
		for organ in Global.arr.organ:
			kinds[organ] = 0
		
		for neighbor in block.neighbors:
			if neighbor.kind != null:
				var organ = Global.dict.block.organ[neighbor.kind]
				kinds[organ] += 1
				
				var organs = get(organ+"s")
				organs.append(neighbor)
		
		var _index = Global.dict.supplier.neighbors[kinds.supplier][kinds.consumer]
		var description = Global.dict.supplier.index[_index]
		
		init_impact(description)
		init_indicators(description)
	else:
		for neighbor in block.neighbors:
			if neighbor.kind != null:
				suppliers.append(neighbor)
				break
		
		roll_description()


func roll_description() -> void:
	var supplier = suppliers.front().organ
	var _size = supplier.consumers.size()
	var _index = Global.get_random_key(Global.dict.supplier.consumer[_size])
	var description = Global.dict.consumer.index[_index]
	
	init_impact(description)
	init_indicators(description)


func init_impact(description_: Dictionary) -> void:
	var input = {}
	input.type = "number"
	input.subtype = round(description_.impact)
	impact.set_attributes(input)


func init_indicators(description_: Dictionary) -> void:
	for key in Global.arr.indicator:
		var input = {}
		input.proprietor = self
		input.type = key
		input.max = description_[key]
		
		var indicator = get(key)
		indicator.set_attributes(input)


func organs_oversubscribe() -> void:
	for organ in Global.arr.organ:
		var organs = get(organ+"s")
		
		for _i in range(organs.size()-1,-1-1):
			var block = organs[_i]
			organs.erase(block)
			organs.append(block.organ)
