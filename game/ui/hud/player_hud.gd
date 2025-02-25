# ui/hud/player_hud.gd  
extends CanvasLayer  
class_name PlayerHUD  

@onready var avatar_sprite: AnimatedSprite2D = $HBoxContainer/AvatarContainer/AvatarBackground/AvatarSprite  
@onready var heart_full1: Sprite2D = $HBoxContainer/StatsContainer/HeartsContainer/HeartFullContainer1/HeartFull1  
@onready var heart_full2: Sprite2D = $HBoxContainer/StatsContainer/HeartsContainer/HeartFullContainer2/HeartFull2  
@onready var heart_half: Sprite2D = $HBoxContainer/StatsContainer/HeartsContainer/HeartHalfContainer/HeartHalf  
@onready var stamina_value: Label = $HBoxContainer/StatsContainer/StaminaValue  
@onready var equipped_tool_icon: TextureRect = $HBoxContainer/StatsContainer/EquippedToolContainer/EquippedToolIcon
@onready var hud_container: Control = $HBoxContainer

# 疲劳状态阈值  
const TIRED_THRESHOLD := 60.0  
const EXHAUSTED_THRESHOLD := 30.0  

func _ready() -> void:  
	await get_tree().process_frame  
	
	# 连接玩家属性信号  
	var player = get_tree().get_first_node_in_group("player")  
	if player:  
		var player_stats = player.get_node("PlayerStats")  
		if player_stats:  
			player_stats.health_changed.connect(_on_health_changed)  
			player_stats.stamina_changed.connect(_on_stamina_changed)  
			
			# 初始化HUD显示  
			_on_health_changed(player_stats.get_health(), player_stats.get_max_health())  
			_on_stamina_changed(player_stats.get_stamina(), player_stats.get_max_stamina())
			
			# 连接工具装备信号
			player.tool_equipped.connect(_on_tool_equipped)
			player.tool_unequipped.connect(_on_tool_unequipped)
			
			# 初始化工具显示
			equipped_tool_icon.texture = null
		else:  
			push_error("PlayerStats node not found in player")  
	else:  
		push_error("Player node not found in scene")
		
	# 连接全局事件
	GameEvents.game_paused.connect(_on_game_paused)
	GameEvents.game_resumed.connect(_on_game_resumed)

func _on_health_changed(current: float, maximum: float) -> void:  
	var health_percentage = (current / maximum) * 100  
	update_hearts(health_percentage)  

func _on_stamina_changed(current: float, maximum: float) -> void:  
	# 更新耐力值显示  
	stamina_value.text = "%d/%d" % [round(current), round(maximum)]  
	# 根据耐力值更新头像状态  
	update_avatar_animation(current)  

func _on_tool_equipped(tool_item: BaseItem) -> void:
	equipped_tool_icon.texture = tool_item.icon

func _on_tool_unequipped(_tool_item: BaseItem) -> void:
	equipped_tool_icon.texture = null

func _on_game_paused() -> void:
	# 游戏暂停时的HUD处理
	hud_container.modulate.a = 0.5  # 降低不透明度

func _on_game_resumed() -> void:
	# 游戏恢复时的HUD处理
	hud_container.modulate.a = 1.0  # 恢复不透明度

func update_hearts(health_percentage: float) -> void:  
	# 计算满心和半心  
	var full_hearts = floor(health_percentage / 50.0)  
	var has_half = (int(health_percentage) % 50) >= 25  

	# 更新心形显示  
	heart_full1.visible = full_hearts >= 1  
	heart_full2.visible = full_hearts >= 2  
	heart_half.visible = (full_hearts == 0 and health_percentage >= 25) or (full_hearts == 1 and has_half)  

func update_avatar_animation(stamina: float) -> void:  
	# 根据耐力值更新头像状态  
	if stamina <= EXHAUSTED_THRESHOLD:  
		avatar_sprite.play("exhausted")  
	elif stamina <= TIRED_THRESHOLD:  
		avatar_sprite.play("tired")  
	else:  
		avatar_sprite.play("normal")
