extends Polygon2D


@onready var indexBlock = $IndexBlock
@onready var indexOrgan = $IndexOrgan

var sky = null
var stars = []
var cords = {}
var neighbors = {}
var grid = Vector3()
var kind = null
var status = null
var ring = null
var organ = null


func set_attributes(input_: Dictionary) -> void:
	sky = input_.sky
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	for cord in input_.cords:
		cords[cord] = null
		
		var star = input_.cords[cord]
		stars.append(star)
		star.blocks.append(self)
		grid += star.grid
		
		cord.foundations[star] = self
		cord.blocks[self] = star
	
	sky.grids.block[grid] = self
	
	init_indexs()
	set_vertexs()
	set_status("freely")


func init_indexs() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.block
	indexBlock.set_attributes(input)
	Global.num.index.block += 1
	
	input.subtype = 0
	indexOrgan.set_attributes(input)


func set_vertexs() -> void:
	var vertexs = []
	
	for star in stars:
		var vertex = star.position
		vertexs.append(vertex)
		indexBlock.position += vertex
	
	set_polygon(vertexs)
	
	indexBlock.position /= stars.size()
	indexBlock.position.x -= indexBlock.custom_minimum_size.x * 0.5
	indexBlock.position.y -= indexBlock.custom_minimum_size.y * 0.75
	indexOrgan.position = indexBlock.position


func set_status(status_: String) -> void:
	status = status_
	
	paint_to_match()


func set_kind(kind_: String) -> void:
	kind = kind_
	
	paint_to_match()


func paint_to_match() -> void:
	if kind == null:
		color = Global.color.block[status]
	else:
		color = Global.color.block[kind]


func update_kind() -> void:
	status = "occupied"
	var kinds = {}
	
	for cord in cords:
		if !kinds.has(cord.kind):
			kinds[cord.kind] = 1
		else:
			kinds[cord.kind] += 1
	
	var _kind = "cover"
	
	if kinds.decor >= 2:
		_kind = "decor"
	
	set_kind(_kind)


func switch_indexs() -> void:
	indexBlock.visible = !indexBlock.visible
	indexOrgan.visible = !indexOrgan.visible


func set_organ(organ_: MarginContainer) -> void:
	organ = organ_
	indexOrgan.visible = true
	indexOrgan.set_number(organ.index.get_number())
