extends Polygon2D


@onready var index = $Index

var sky = null
var grid = null
var neighbors = {}
var cords = {}
var directions = {}


func set_attributes(input_: Dictionary) -> void:
	sky = input_.sky
	grid = input_.grid
	position = input_.position
	
	init_basic_setting()


func init_basic_setting() -> void:
	sky.grids.star[grid] = self
	set_vertexs()
	init_index()


func set_vertexs() -> void:
	var order = "even"
	var corners = 4
	var r = Global.num.star.a
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)
	paint_gold()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.star
	index.set_attributes(input)
	Global.num.index.star += 1


func paint_black() -> void:
	color = Color.BLACK


func paint_gold() -> void:
	color = Color.GOLD
