extends MarginContainer


@onready var vigorous = $HBox/Vigorous
@onready var tired = $HBox/Tired

var ladder = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	
	fill_vigorous()


func fill_vigorous() -> void:
	var options = []
	
	for squad in ladder.squads.get_children():
		options.append_array(squad.members.get_children())
	
	options.shuffle()
	
	for member in options:
		var input = {}
		input.type = "number"
		input.subtype = member.index.get_number()
		
		var icon = Global.scene.icon.instantiate()
		vigorous.add_child(icon)
		icon.set_attributes(input)
		icon.custom_minimum_size = Vector2(Global.vec.size.sixteen)
		icon.proprietor = member
		member.order = icon


func full_activation() -> void:
	while vigorous.get_child_count() > 0:
		activation()


func activation() -> void:
	if vigorous.get_child_count() > 0:
		var member = vigorous.get_child(0).proprietor
		member.advancement()
		vigorous.remove_child(member.order)
		tired.add_child(member.order)
	else:
		ladder.next_iteration()


func rest() -> void:
	while tired.get_child_count() > 0:
		var icon = tired.get_child(0)
		tired.remove_child(icon)
		vigorous.add_child(icon)
		icon.proprietor.rest()
