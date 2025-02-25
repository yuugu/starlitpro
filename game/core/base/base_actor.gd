# core/base/base_actor.gd
extends CharacterBody2D
class_name BaseActor

@export var base_speed: float = 100.0

enum Direction { UP, DOWN, LEFT, RIGHT }
var current_direction: Direction = Direction.DOWN

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	pass

func move(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return
		
	velocity = direction * base_speed
	move_and_slide()
	update_direction(direction)

func update_direction(direction: Vector2) -> void:
	var previous_direction = current_direction
	
	if direction.x > 0:
		current_direction = Direction.RIGHT
	elif direction.x < 0:
		current_direction = Direction.LEFT
	elif direction.y < 0:
		current_direction = Direction.UP
	elif direction.y > 0:
		current_direction = Direction.DOWN
		
	if previous_direction != current_direction:
		update_current_animation()

func get_direction_string() -> String:
	match current_direction:
		Direction.UP: return "back"
		Direction.DOWN: return "front"
		Direction.LEFT: return "left"
		Direction.RIGHT: return "right"
	return "front"

func update_animation(animation_name: String) -> void:
	if not sprite:
		return
		
	var direction = get_direction_string()
	var anim_to_play = animation_name + "_" + direction
	
	if sprite.sprite_frames.has_animation(anim_to_play):
		if sprite.animation != anim_to_play:
			sprite.play(anim_to_play)
	else:
		# 如果没有特定方向的动画，尝试播放基础动画
		if sprite.sprite_frames.has_animation(animation_name):
			sprite.play(animation_name)

func update_current_animation() -> void:
	if sprite and sprite.animation:
		var base_anim = sprite.animation.split("_")[0]
		update_animation(base_anim)
