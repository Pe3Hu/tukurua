extends Polygon2D


@onready var index = $Index

var sky = null
var blocks = {}
var cords = {}


func set_attributes(input_: Dictionary) -> void:
	sky = input_.sky
	blocks.total = input_.blocks
	
	init_basic_setting()


func init_basic_setting() -> void:
	update_cords_kind()
	update_blocks_kind()
	update_stars_status()
	update_stars_insulation()
	update_blocks_insulation()
	init_index()


func update_cords_kind() -> void:
	cords.cover = []
	cords.decor = []
	
	cords.cold = []
	cords.heat = []
	
	for block in blocks.total:
		for cord in block.cords:
			if cords.cover.has(cord):
				cords.decor.append(cord)
				cords.cover.erase(cord)
			else:
				cords.cover.append(cord)
			
			if !cords.cold.has(cord):
				cords.cold.append(cord)
	
	for kind in Global.arr.content:
		for cord in cords[kind]:
			cord.set_kind(kind)


func update_blocks_kind() -> void:
	blocks.cover = []
	blocks.decor = []
	
	for block in blocks.total:
		block.update_kind()


func update_stars_status() -> void:
	for block in blocks.total:
		for star in block.stars:
			if star.status == "freely":
				star.add_constellation(self)


func update_stars_insulation() -> void:
	for block in blocks.total:
		for star in block.stars:
			for neighbor in star.neighbors:
				if neighbor.status == "freely":
					neighbor.set_status("insulation")


func update_blocks_insulation() -> void:
	for block in blocks.total:
		for star in block.stars:
			for _block in star.blocks:
				if _block.status == "freely":
					_block.set_status("insulation")


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.star
	index.set_attributes(input)
	Global.num.index.star += 1


