# data/items/items/tools/hoe.gd
extends BaseItem
class_name HoeTool

func _init() -> void:
	id = "tool_hoe"
	name = "hoe"
	description = "Here are the basic tools for loosening and tilling soil"
	icon = preload("res://game/data/items/items/tools/tools_hoe.tres")
	item_type = ItemType.TOOL

func use(player: Player) -> void:
	# 检查玩家是否有足够的体力
	var player_stats = player.stats
	if not player_stats.has_enough_stamina_for("tool_use"):
		# 体力不足，无法使用
		use_completed.emit()
		return
		
	# 如果玩家当前没有装备此工具，则装备它
	if player.current_tool != self:
		player.equip_tool(self)
		use_completed.emit()
		return
	
	# 已装备，执行使用动作
	player.use_tool()