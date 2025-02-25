# core/utils/state_machine.gd
extends Node
class_name StateMachine

signal state_changed(state_name)

var states: Dictionary = {}
var current_state: BaseState = null
var active: bool = true

func _ready() -> void:
	for child in get_children():
		if child is BaseState:
			states[child.name] = child
			child.actor = get_parent()

func _process(delta: float) -> void:
	if current_state and active:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state and active:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state and active:
		current_state.handle_input(event)

func transition_to(state_name: String) -> void:
	if not active:
		return
		
	if not states.has(state_name):
		push_error("状态 " + state_name + " 不存在")
		return
		
	if current_state:
		current_state.exit()
		
	current_state = states[state_name]
	current_state.enter()
	emit_signal("state_changed", state_name)

func get_current_state() -> String:
	if current_state:
		return current_state.name
	return ""