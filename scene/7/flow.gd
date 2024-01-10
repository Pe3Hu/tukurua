extends MarginContainer


@onready var bg = $HBox/BG
@onready var stages = $HBox/BG/Stages
@onready var marker = $HBox/Marker
@onready var timer = $Timer

var river = null
var kind = null
var ticks = {}
var tween = null
var pace = null
var time = null
var anchor = null
var organs = []


func set_attributes(input_: Dictionary) -> void:
	river = input_.river
	kind = input_.kind
	
	init_basic_setting()


func init_basic_setting() -> void:
	set_marker_and_bg_color()
	reset_vars()
	update_bg_size()


func reset_vars() -> void:
	time = Time.get_unix_time_from_system()
	ticks.current = 0
	ticks.next = 0
	ticks.max = 120
	pace = 2


func set_marker_and_bg_color() -> void:
	var input = {}
	input.type = "organ"
	input.subtype = kind
	marker.set_attributes(input)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Global.color.flow[kind]
	bg.set("theme_override_styles/panel", style)


func update_bg_size() -> void:
	bg.custom_minimum_size = Global.vec.size.tick
	bg.custom_minimum_size.x *= ticks.max
	#custom_minimum_size = Global.vec.size.tick
	#custom_minimum_size.x *= ticks.max
	anchor = Vector2(0, 24)


func add_action(frequency_: int) -> void:
	var input = {}
	input.timeline = self
	input.frequency = frequency_
	
	var action = Global.scene.action.instantiate()
	#actions.add_child(action)
	action.set_attributes(input)


func tween_ticks() -> void:
	if stages.get_child_count() > 0:
		var stage = stages.get_child(0)
		var gap = Vector2(Global.vec.size.tick.x, 0)
		gap.x *= -ticks.next
		gap += anchor
		var value = stage.get_upcoming_ticks()-ticks.current-ticks.next
		
		var _time = 1.0 / pace
		tween = create_tween()
		tween.tween_property(stages, "position", gap, _time).from_current()
		tween.tween_property(stage.bar, "value", value, _time)
		#print([descendant.index, -ticks.current, stages.get_child(0).type, stages.position.x])
		tween.tween_callback(stage.collapse_check)


func tween_ticks_old() -> void:
	if stages.get_child_count() > 0:
		var gap = Vector2(Global.vec.size.tick.x, 0)
		gap.x *= -ticks.current
		var _time = 1.0 / pace
		tween = create_tween()
		tween.tween_property(stages, "position", gap, _time).from(Vector2(0, 0))
		tween.tween_callback(add_elapsed_ticks)


func add_elapsed_ticks() -> void:
	if stages.get_child_count() > 0:
		var stage = stages.get_child(0)
		stage.add_elapsed_ticks(ticks.current)
