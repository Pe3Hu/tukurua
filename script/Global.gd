extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.element = ["aqua", "wind", "fire", "earth"]
	arr.rank = [1, 2, 3, 4, 5]#, 6]
	arr.suit = ["aqua", "wind", "fire", "earth"]
	arr.direction = ["up", "right", "down", "left"]
	arr.traveler = ["sage", "guardian"]
	arr.portal = ["frontier", "trap"]
	arr.scenery = ["forest of life", "field of death", "sea of souls"]
	arr.tower = ["harmony", "life", "death", "souls"]
	arr.content = ["decor", "cover"]
	arr.temperature = ["cold", "heat"]


func init_num() -> void:
	num.index = {}
	num.index.card = 0
	num.index.location = 0
	num.index.aisle = 0
	num.index.underside = 0
	num.index.tower = 0
	num.index.region = 0
	num.index.member = 0
	num.index.star = 0
	num.index.cord = 0
	num.index.block = 0
	
	
	num.size = {}
	num.size.isle = 13
	num.size.region = 3
	num.size.hex = 6
	
	num.star = {}
	num.star.a = 5
	
	num.cord = {}
	num.cord.l = 60


func init_dict() -> void:
	init_neighbor()
	init_labyrinth()
	init_card()
	init_corner()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.coordinates = {}
	dict.coordinates.cube = [
		Vector3(1, 0, -1),
		Vector3(1, -1, 0),
		Vector3(0, -1, 1),
		Vector3(-1, 0, 1),
		Vector3(-1, 1, 0),
		Vector3(0, 1, -1)
	]


func init_labyrinth() -> void:
	dict.aisle = {}
	dict.aisle.side = {}
	dict.aisle.side["right"] = {}
	dict.aisle.side["right"]["entry"] = "right"
	dict.aisle.side["right"]["exit"] = "left"
	dict.aisle.side["left"] = {}
	dict.aisle.side["left"]["entry"] = "left"
	dict.aisle.side["left"]["exit"] = "right"
	dict.aisle.side["up"] = {}
	dict.aisle.side["up"]["entry"] = "up"
	dict.aisle.side["up"]["exit"] = "down"
	dict.aisle.side["down"] = {}
	dict.aisle.side["down"]["entry"] = "down"
	dict.aisle.side["down"]["exit"] = "up"
	
	dict.aisle.pair = {}
	dict.aisle.pair["entry"] = "exit"
	dict.aisle.pair["exit"] = "entry"
	
	dict.obstacle = {}
	dict.obstacle.direction = {}
	dict.obstacle.direction["sage"] = "down"
	dict.obstacle.direction["frontier"] = "down"
	dict.obstacle.direction["guardian"] = "up"
	dict.obstacle.direction["trap"] = "up"
	
	dict.traveler = {}
	dict.traveler.frontier = {}
	dict.traveler.frontier["guardian"] = "up"
	dict.traveler.frontier["sage"] = "down"
	dict.traveler.frontier["trap"] = "up"
	dict.traveler.frontier["frontier"] = "down"
	
	dict.obstacle.role = {}
	dict.obstacle.role["sage"] = "defender"
	dict.obstacle.role["frontier"] = "defender"
	dict.obstacle.role["underside"] = "defender"
	dict.obstacle.role["guardian"] = "aggressor"
	dict.obstacle.role["trap"] = "aggressor"
	
	dict.underside = {}
	dict.underside.linear = {}
	dict.underside.linear[Vector2( 0,-1)] = "down"
	dict.underside.linear[Vector2( 1, 0)] = "left"
	dict.underside.linear[Vector2( 0, 1)] = "up"
	dict.underside.linear[Vector2(-1, 0)] = "right"


func init_card() -> void:
	dict.card = {}
	dict.card.count = {}
	
	for rank in arr.rank:
		dict.card.count[rank] = arr.rank.front() + arr.rank.back() - rank


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [3,4,6]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2 * PI * _i / corners_ - PI / 2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_emptyjson() -> void:
	dict.emptyjson = {}
	dict.emptyjson.title = {}
	
	var path = "res://asset/json/.json"
	var array = load_data(path)
	
	for emptyjson in array:
		var data = {}
		
		for key in emptyjson:
			if key != "title":
				data[key] = emptyjson[key]
		
		dict.emptyjson.title[emptyjson.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.tamer = load("res://scene/1/tamer.tscn")
	
	scene.card = load("res://scene/2/card.tscn")
	
	scene.isle = load("res://scene/3/isle.tscn")
	scene.location = load("res://scene/3/location.tscn")
	scene.aisle = load("res://scene/3/aisle.tscn")
	scene.underside = load("res://scene/3/underside.tscn")
	scene.traveler = load("res://scene/3/traveler.tscn")
	scene.region = load("res://scene/3/region.tscn")
	scene.tower = load("res://scene/3/tower.tscn")
	
	scene.star = load("res://scene/5/star.tscn")
	scene.cord = load("res://scene/5/cord.tscn")
	scene.block = load("res://scene/5/block.tscn")
	
	scene.constellation = load("res://scene/6/constellation.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(24, 16)
	
	vec.size.suit = Vector2(32, 32)
	vec.size.rank = Vector2(vec.size.sixteen)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(120, 12)
	
	vec.size.location = Vector2(60, 60)
	vec.size.scheme = Vector2(900, 700)
	vec.size.encounter = Vector2(128, 200)
	vec.size.facet = Vector2(64, 64) * 0.5
	vec.size.tattoo = Vector2(16, 16) * 3
	vec.size.essence = Vector2(16, 16) * 2
	vec.size.trigger = Vector2(16, 16) * 2
	vec.size.place = Vector2(16, 16) * 1.5
	
	vec.size.sky = Vector2(400, 400)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.card = {}
	color.card.selected = Color.from_hsv(160 / h, 0.6, 0.7)
	color.card.unselected = Color.from_hsv(0 / h, 0.4, 0.9)
	
	color.frontier = {}
	color.frontier.entry = Color.from_hsv(60 / h, 0.6, 0.7)
	color.frontier.exit = Color.from_hsv(30 / h, 0.6, 0.7)
	color.frontier.underside = Color.from_hsv(90 / h, 0.6, 0.7)
	#color.location.aisle = Color.from_hsv(60 / h, 0.6, 0.7)
	
	color.route = {}
	color.route.active = Color.from_hsv(330 / h, 0.6, 0.7)
	color.route.passive = Color.from_hsv(30 / h, 0.6, 0.7)
	
	color.traveler = {}
	color.traveler.guardian = Color.from_hsv(0 / h, 0.6, 0.7)
	color.traveler.sage = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.difficulty = Color.from_hsv(150 / h, 0.6, 0.7)
	
	color.scenery = {}
	color.scenery["forest of life"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.scenery["field of death"] = Color.from_hsv(270 / h, 0.6, 0.7)
	color.scenery["sea of souls"] = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.tower = {}
	color.tower["life"] = Color.from_hsv(0 / h, 0.6, 0.7)
	color.tower["death"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.tower["souls"] = Color.from_hsv(60 / h, 0.6, 0.7)
	color.tower["harmony"] = Color.from_hsv(270 / h, 0.6, 0.7)
	
	color.cord = {}
	color.cord.decor = Color.from_hsv(120 / h, 0.9, 0.7)
	color.cord.cover = Color.from_hsv(210 / h, 0.9, 0.7)
	color.cord.heat = Color.from_hsv(0 / h, 0.9, 0.7)
	
	color.block = {}
	color.block.decor = Color.from_hsv(120 / h, 0.8, 0.4)
	color.block.cover = Color.from_hsv(210 / h, 0.8, 0.4)
	color.block.insulation = Color.from_hsv(270 / h, 0.8, 0.4)
	color.block.freely = Color.from_hsv(0 / h, 0.0, 0.9)
	
	color.star = {}
	color.star.occupied = Color.from_hsv(60 / h, 0.9, 0.9)
	color.star.freely = Color.from_hsv(30 / h, 0.9, 0.9)
	color.star.insulation = Color.from_hsv(270 / h, 0.9, 0.9)
	
	color.star.cold = Color.from_hsv(150 / h, 0.9, 0.7)
	color.star.heat = Color.from_hsv(0 / h, 0.9, 0.7)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
