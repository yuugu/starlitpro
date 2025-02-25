extends Node2D

func _ready() -> void:
	# 设置为猫爪光标
	MouseManager.set_cursor_type(MouseManager.CursorType.TRIANGLE_SMALL)

func _on_item_grabbed() -> void:
	# 切换到抓取状态
	MouseManager.set_catpaw_state("holding")

func _on_item_released() -> void:
	# 恢复正常状态
	MouseManager.set_catpaw_state("normal")

func _on_button_hovered() -> void:
	# 切换到指向状态
	MouseManager.set_catpaw_state("pointing")

func _on_game_paused() -> void:
	# 恢复默认系统光标
	MouseManager.reset_cursor()
