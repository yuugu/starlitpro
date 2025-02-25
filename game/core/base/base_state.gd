# core/base/base_state.gd
extends Node
class_name BaseState

var actor: BaseActor = null

func _ready() -> void:
	await owner.ready

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass