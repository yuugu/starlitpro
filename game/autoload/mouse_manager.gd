# autoload/mouse_manager.gd
extends Node

# 鼠标光标管理器
# 负责管理游戏中所有鼠标光标的显示和切换

# 预加载所有鼠标光标资源
var arrow_cursors = [
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Arrow Mouse icon 1.png"),
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Arrow Mouse icon 2.png"),
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Arrow Mouse icon 3.png")
]

var catpaw_cursors = {
	"normal": preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Catpaw Mouse icon.png"),
	"holding": preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Catpaw holding Mouse icon.png"),
	"pointing": preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Catpaw pointing Mouse icon.png")
}

var triangle_cursors = [
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Triangle Mouse icon 1.png"),
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Triangle Mouse icon 2.png"),
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Triangle Mouse icon 3.png")
]

var triangle_small_cursors = [
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Triangle small Mouse icon 1.png"),
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Triangle small Mouse icon 2.png"),
	preload("res://assets/Sprout Lands - UI Pack - Premium pack/UI Sprites/Mouse sprites/Triangle small Mouse icon 3.png")
]

enum CursorType {
	ARROW,
	CATPAW,
	TRIANGLE,
	TRIANGLE_SMALL
}

var current_cursor_type = CursorType.ARROW
var current_catpaw_state = "normal"

func _ready() -> void:
	# 默认设置箭头光标
	set_cursor_type(CursorType.ARROW)

func set_cursor_type(type: CursorType) -> void:
	current_cursor_type = type
	match type:
		CursorType.ARROW:
			Input.set_custom_mouse_cursor(arrow_cursors[0])
		CursorType.CATPAW:
			Input.set_custom_mouse_cursor(catpaw_cursors["normal"])
		CursorType.TRIANGLE:
			Input.set_custom_mouse_cursor(triangle_cursors[0])
		CursorType.TRIANGLE_SMALL:
			Input.set_custom_mouse_cursor(triangle_small_cursors[0])

# 特别为猫爪光标提供状态切换
func set_catpaw_state(state: String) -> void:
	if current_cursor_type != CursorType.CATPAW:
		return
		
	if catpaw_cursors.has(state):
		current_catpaw_state = state
		Input.set_custom_mouse_cursor(catpaw_cursors[state])

# 重置为默认光标
func reset_cursor() -> void:
	Input.set_custom_mouse_cursor(null)
