extends MarginContainer


@onready var hbox = $HBox
@onready var aggressorMarker = $HBox/Aggressor/HBox/Marker
@onready var aggressorMax = $HBox/Aggressor/HBox/Max
@onready var aggressorPool = $HBox/Aggressor/Pool
@onready var aggressorWinner = $HBox/Aggressor/Winner
@onready var defenderMarker = $HBox/Defender/HBox/Marker
@onready var defenderMax = $HBox/Defender/HBox/Max
@onready var defenderPool = $HBox/Defender/Pool
@onready var defenderWinner = $HBox/Defender/Winner
@onready var middleInitiation = $HBox/Middle/Initiation

var ladder = null
var aggressor = null
var defender = null
var winner = null
var loser = null
var results = []
var fixed = []
var hides = []
var kind = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	
	custom_minimum_size = Global.vec.size.encounter


func set_roles(aggressor_: MarginContainer, defender_: MarginContainer) -> void:
	hbox.visible = true
	aggressor = aggressor_
	defender = defender_
	
	for role in Global.arr.role:
		update_role_icons(role)
	
	roll_pools()


func update_role_icons(role_: String) -> void:
	var object = get(role_)
	var input = {}
	input.type = "number"
	input.subtype = object.index.get_number()
	
	var icon = get(role_+"Marker")
	icon.set_attributes(input)
	icon.visible = true
	
	input.type = "prize"
	input.subtype = "2"
	icon = get(role_+"Winner")
	icon.set_attributes(input)
	icon.visible = true
	
	input.encounter = self
	input.role = role_
	var pool = get(role_+"Pool")
	pool.set_attributes(input)
	pool.visible = true


func roll_pools() -> void:
	var root = "strength"
	
	for role in Global.arr.role:
		var pool = get(role+"Pool")
		
		if !fixed.has(role):
			var object = get(role)
			var input = {}
			input.type = "number"
			
			match object.part:
				"obstacle":
					input.subtype = object.difficulty.get_number()
			match object.part:
				"member":
					var aspect = null
					
					match role:
						"aggressor":
							aspect = object.rundown.get_aspect_based_on_root_and_branch(root, "tension")
						"defender":
							aspect = object.rundown.get_aspect_based_on_root_and_branch(root, "resistance")
					
					input.subtype = aspect.get_base_of_quadratic_degree()
			
			var icon = get(role+"Max")
			icon.set_attributes(input)
		
			pool.init_dices(1, input.subtype + 1)
			pool.roll_dices()


func check_results() -> void:
	results.sort_custom(func(a, b): return a.value > b.value)
	
	winner = get(results.front().role)
	loser = get(results.back().role)
	
	var input = {}
	input.type = "prize"
	input.subtype = "1"
	
	var icon = get(results.front().role+"Winner")
	icon.set_attributes(input)
	icon.visible = true
	
	icon = get(results.back().role+"Winner")
	icon.visible = false
	apply_result()


func apply_result() -> void:
	if winner == aggressor:
		match aggressor.part:
			"obstacle":
				aggressor.apply_impact(defender)
			"member":
				match defender.part:
					"obstacle":
						defender.apply_impact(aggressor)
	
	end_of_encounter()


func end_of_encounter() -> void:
	reset()


func reset() -> void:
	winner = null
	loser = null
	results = []
	fixed = []
	aggressorPool.reset()
	defenderPool.reset()
	#hbox.visible = false
