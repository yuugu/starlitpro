# systems/player/player_stats.gd
extends BaseStats
class_name PlayerStats

signal health_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)

const STAT_HEALTH := "health"
const STAT_MAX_HEALTH := "max_health"
const STAT_STAMINA := "stamina"
const STAT_MAX_STAMINA := "max_stamina"

# 体力消耗配置
const STAMINA_COST_WALK := 0.05
const STAMINA_COST_RUN := 0.2
const STAMINA_COST_TOOL_USE := 5.0
const STAMINA_REGEN_RATE := 0.5

# 疲劳状态阈值
const TIRED_THRESHOLD := 60.0
const EXHAUSTED_THRESHOLD := 30.0

func _ready() -> void:
	initialize_stats()
	# 初始化完成后发送初始状态
	emit_signal("health_changed", get_health(), get_max_health())
	emit_signal("stamina_changed", get_stamina(), get_max_stamina())

func _process(delta: float) -> void:
	# 自动恢复体力
	if get_stamina() < get_max_stamina():
		modify_stamina(STAMINA_REGEN_RATE * delta)

func initialize_stats() -> void:
	stats = {
		STAT_HEALTH: 100.0,
		STAT_MAX_HEALTH: 100.0,
		STAT_STAMINA: 100.0,
		STAT_MAX_STAMINA: 100.0
	}

func get_health() -> float:
	return get_stat(STAT_HEALTH)

func get_max_health() -> float:
	return get_stat(STAT_MAX_HEALTH)

func get_stamina() -> float:
	return get_stat(STAT_STAMINA)

func get_max_stamina() -> float:
	return get_stat(STAT_MAX_STAMINA)

func modify_health(amount: float) -> void:
	var new_health = clamp(get_health() + amount, 0, get_max_health())
	set_stat(STAT_HEALTH, new_health)
	emit_signal("health_changed", new_health, get_max_health())
	GameEvents.player_health_changed.emit(new_health, get_max_health())

func modify_stamina(amount: float) -> void:
	var new_stamina = clamp(get_stamina() + amount, 0, get_max_stamina())
	set_stat(STAT_STAMINA, new_stamina)
	emit_signal("stamina_changed", new_stamina, get_max_stamina())
	GameEvents.player_stamina_changed.emit(new_stamina, get_max_stamina())

# 检查是否有足够的体力执行动作
func has_enough_stamina_for(action: String) -> bool:
	var cost = 0.0
	match action:
		"walk": cost = STAMINA_COST_WALK
		"run": cost = STAMINA_COST_RUN
		"tool_use": cost = STAMINA_COST_TOOL_USE
	
	return get_stamina() >= cost

# 消耗体力
func consume_stamina_for(action: String) -> void:
	var cost = 0.0
	match action:
		"walk": cost = STAMINA_COST_WALK
		"run": cost = STAMINA_COST_RUN
		"tool_use": cost = STAMINA_COST_TOOL_USE
	
	if get_stamina() >= cost:
		modify_stamina(-cost)
