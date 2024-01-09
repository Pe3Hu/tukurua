extends Line2D


@onready var index = $Index

var sky = null
var stars = {}
var blocks = {}
var foundations = {}
var kind = null
var status = null


func set_attributes(input_: Dictionary) -> void:
	sky = input_.sky
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	for star in input_.stars:
		stars[star] = null
	
	init_index()
	set_vertexs()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.cord
	index.set_attributes(input)
	Global.num.index.cord += 1


func set_vertexs() -> void:
	for star in stars:
		var vertex = star.position
		add_point(vertex)
		index.position += vertex
	
	index.position /= stars.keys().size()
	index.position.x -= index.custom_minimum_size.x * 0.5
	index.position.y -= index.custom_minimum_size.y * 0.5


func get_another_star(star_: Polygon2D) -> Variant:
	if stars.has(star_):
		for star in stars:
			if star != star_:
				return star
	
	return null


func set_kind(kind_: String) -> void:
	kind = kind_
	status = "cold"
	
	paint_to_match()


func paint_to_match() -> void:
	match status:
		"cold":
			default_color = Global.color.cord[kind]
		"heat":
			default_color = Global.color.cord[status]
