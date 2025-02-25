# systems/player/states/player_walk_state.gd
extends BaseState
class_name PlayerWalkState

func _ready() -> void:
	super._ready()
	name = "walk"

func enter() -> void:
	actor.update_animation("walk")

func physics_update(_delta: float) -> void:
	var input_vector = InputManager.get_input_vector()
	
	if input_vector == Vector2.ZERO:
		get_parent().transition_to("idle")
	else:
		actor.move(input_vector)