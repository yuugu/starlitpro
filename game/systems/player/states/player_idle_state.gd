# systems/player/states/player_idle_state.gd
extends BaseState
class_name PlayerIdleState

func _ready() -> void:
	super._ready()
	name = "idle"

func enter() -> void:
	actor.update_animation("idle")

func physics_update(_delta: float) -> void:
	var input_vector = InputManager.get_input_vector()
	
	if input_vector != Vector2.ZERO:
		get_parent().transition_to("walk")