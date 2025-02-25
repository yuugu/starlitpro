extends Node

# 输入管理器
# 集中处理所有游戏输入，提供统一的接口

# 信号定义
signal action_pressed(action_name: String)
signal action_released(action_name: String)
signal action_just_pressed(action_name: String)
signal action_just_released(action_name: String)

# 定义游戏中使用的所有输入动作
enum GameAction {
	MOVE_UP,
	MOVE_DOWN,
	MOVE_LEFT,
	MOVE_RIGHT,
	USE_TOOL,
	OPEN_INVENTORY
}

# 存储动作名称的映射
var action_names: Dictionary = {
	GameAction.MOVE_UP: "move_up",
	GameAction.MOVE_DOWN: "move_down",
	GameAction.MOVE_LEFT: "move_left",
	GameAction.MOVE_RIGHT: "move_right",
	GameAction.USE_TOOL: "use_tool",
	GameAction.OPEN_INVENTORY: "open_inventory"
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	# 处理所有注册的输入动作
	for action in action_names.values():
		if event.is_action(action):
			if event.is_action_pressed(action):
				action_pressed.emit(action)
				action_just_pressed.emit(action)
			elif event.is_action_released(action):
				action_released.emit(action)
				action_just_released.emit(action)

# 获取输入向量（用于移动）
func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	# 允许对角线移动，但归一化向量
	if Input.is_action_pressed(action_names[GameAction.MOVE_RIGHT]):
		input_vector.x += 1
	if Input.is_action_pressed(action_names[GameAction.MOVE_LEFT]):
		input_vector.x -= 1
	if Input.is_action_pressed(action_names[GameAction.MOVE_DOWN]):
		input_vector.y += 1
	if Input.is_action_pressed(action_names[GameAction.MOVE_UP]):
		input_vector.y -= 1
		
	return input_vector.normalized() if input_vector.length() > 0 else input_vector

# 检查动作是否被按下
func is_action_pressed(action: GameAction) -> bool:
	return Input.is_action_pressed(action_names[action])

# 检查动作是否刚刚被按下
func is_action_just_pressed(action: GameAction) -> bool:
	return Input.is_action_just_pressed(action_names[action])

# 检查动作是否刚刚被释放
func is_action_just_released(action: GameAction) -> bool:
	return Input.is_action_just_released(action_names[action])

# 禁用所有输入
func disable_input() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

# 启用输入
func enable_input() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
