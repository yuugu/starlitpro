# systems/player/states/player_tool_use_state.gd
extends BaseState
class_name PlayerToolUseState

func _ready() -> void:
	super._ready()
	name = "tool_use"

func enter() -> void:
	# 根据工具类型选择动画
	if actor is Player and actor.current_tool:
		if actor.current_tool is HoeTool:
			# 确保动画从头开始播放
			actor.sprite.frame = 0
			actor.update_animation("hoe_use")
			# 消耗体力
			var player = actor as Player
			player.stats.consume_stamina_for("tool_use")
			
			# 发出工具使用信号
			actor.current_tool.use_started.emit()
		else:
			# 默认工具使用动画
			actor.update_animation("idle")
	
	# 使用动画完成后返回到普通状态
	await actor.sprite.animation_finished
	
	# 发出工具使用完成信号
	if actor is Player and actor.current_tool:
		actor.current_tool.use_completed.emit()
		GameEvents.tool_action_completed.emit(actor.current_tool)
	
	# 根据是否有输入决定返回到哪个状态
	var input_vector = InputManager.get_input_vector()
	if input_vector == Vector2.ZERO:
		get_parent().transition_to("idle")
	else:
		get_parent().transition_to("walk")
