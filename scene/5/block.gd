extends Polygon2D


@onready var index = $Index

var sky = null
var stars = []
var cords = {}
var neighbors = {}
var grid = Vector3()


func set_attributes(input_: Dictionary) -> void:
	sky = input_.sky
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	for cord in input_.cords:
		cords[cord] = null
		
		var star = input_.cords[cord]
		stars.append(star)
		grid += star.grid
		
		cord.foundations[star] = self
		cord.blocks[self] = star
	
	sky.grids.block[grid] = self
	init_index()
	set_vertexs()
	paint_white()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.block
	index.set_attributes(input)
	Global.num.index.block += 1


func set_vertexs() -> void:
	var vertexs = []
	
	for star in stars:
		var vertex = star.position
		vertexs.append(vertex)
		index.position += vertex
	
	set_polygon(vertexs)
	
	index.position /= stars.size()
	index.position.x -= index.custom_minimum_size.x * 0.5
	index.position.y -= index.custom_minimum_size.y * 0.75



func paint_black() -> void:
	color = Color.BLACK


func paint_white() -> void:
	color = Color.WHITE


