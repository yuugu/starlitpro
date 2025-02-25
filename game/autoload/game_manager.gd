extends Node

# 游戏管理器
# 负责管理游戏的全局状态和流程

signal game_started
signal game_saved
signal game_loaded
signal day_changed(day: int)
signal time_changed(hour: int, minute: int)

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	DIALOG,
	CUTSCENE
}

var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU

# 游戏时间系统
var current_day: int = 1
var current_hour: int = 6  # 游戏从早上6点开始
var current_minute: int = 0
var time_scale: float = 1.0  # 时间流逝速度倍率
var day_length_minutes: int = 24  # 游戏内一天有多少分钟

# 游戏设置
var settings: Dictionary = {
	"music_volume": 0.8,
	"sfx_volume": 1.0,
	"fullscreen": false,
	"language": "zh_CN"
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_settings()

func _process(delta: float) -> void:
	if current_state == GameState.PLAYING:
		update_game_time(delta)

# 更新游戏内时间
func update_game_time(delta: float) -> void:
	var real_minutes_per_game_day = 24.0  # 现实中24分钟对应游戏内一天
	var game_minutes_per_real_second = (24.0 * 60.0) / (real_minutes_per_game_day * 60.0)
	
	# 计算这一帧经过的游戏内分钟数
	var minutes_passed = game_minutes_per_real_second * delta * time_scale
	
	# 累加分钟
	current_minute += minutes_passed
	
	# 处理分钟溢出
	while current_minute >= 60:
		current_minute -= 60
		current_hour += 1
		
		# 处理小时溢出
		if current_hour >= 24:
			current_hour = 0
			current_day += 1
			day_changed.emit(current_day)
	
	# 每分钟整点发出时间变化信号
	if floor(current_minute) != floor(current_minute - minutes_passed):
		time_changed.emit(current_hour, int(current_minute))

# 游戏状态管理
func change_state(new_state: GameState) -> void:
	previous_state = current_state
	current_state = new_state
	
	match new_state:
		GameState.PLAYING:
			get_tree().paused = false
			if previous_state == GameState.PAUSED:
				GameEvents.game_resumed.emit()
		GameState.PAUSED:
			get_tree().paused = true
			GameEvents.game_paused.emit()
		GameState.DIALOG, GameState.CUTSCENE:
			# 这些状态下不暂停游戏，但可能需要禁用某些输入
			InputManager.disable_input()
		_:
			pass

func pause_game() -> void:
	if current_state == GameState.PLAYING:
		change_state(GameState.PAUSED)

func resume_game() -> void:
	if current_state == GameState.PAUSED:
		change_state(GameState.PLAYING)

func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		pause_game()
	elif current_state == GameState.PAUSED:
		resume_game()

# 保存/加载游戏设置
func save_settings() -> void:
	var config = ConfigFile.new()
	
	for key in settings.keys():
		config.set_value("settings", key, settings[key])
	
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load("user://settings.cfg")
	
	if error == OK:
		for key in settings.keys():
			if config.has_section_key("settings", key):
				settings[key] = config.get_value("settings", key)
	
	apply_settings()

func apply_settings() -> void:
	# 应用音量设置
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(settings.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(settings.sfx_volume))
	
	# 应用全屏设置
	if settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# 应用语言设置
	TranslationServer.set_locale(settings.language) 
