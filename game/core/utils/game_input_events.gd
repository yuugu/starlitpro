extends Node

# 单例访问
static var instance: Node

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
	MOVE_RIGHT
}

# 存储动作名称的映射
var action_names: Dictionary = {
	GameAction.MOVE_UP: "move_up",
	GameAction.MOVE_DOWN: "move_down",
	GameAction.MOVE_LEFT: "move_left",
	GameAction.MOVE_RIGHT: "move_right"
}

func _ready() -> void:
	# 设置单例
	instance = self
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
static func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	# 只允许单一方向移动
	if Input.is_action_pressed("move_right"):
		input_vector.x = 1
	elif Input.is_action_pressed("move_left"):
		input_vector.x = -1
	elif Input.is_action_pressed("move_down"):
		input_vector.y = 1
	elif Input.is_action_pressed("move_up"):
		input_vector.y = -1
		
	return input_vector

# 检查动作是否被按下
static func is_action_pressed(action: GameAction) -> bool:
	return Input.is_action_pressed(instance.action_names[action])

# 检查动作是否刚刚被按下
static func is_action_just_pressed(action: GameAction) -> bool:
	return Input.is_action_just_pressed(instance.action_names[action])

# 检查动作是否刚刚被释放
static func is_action_just_released(action: GameAction) -> bool:
	return Input.is_action_just_released(instance.action_names[action])

# 禁用所有输入
static func disable_input() -> void:
	instance.process_mode = Node.PROCESS_MODE_DISABLED

# 启用输入
static func enable_input() -> void:
	instance.process_mode = Node.PROCESS_MODE_ALWAYS
