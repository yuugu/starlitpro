# autoload/game_events.gd  
extends Node  

# 游戏事件总线
# 用于在不同系统间传递事件信号

# 物品相关信号
signal toggle_inventory  
signal item_equipped(item: BaseItem)  
signal item_unequipped(item: BaseItem)

# 玩家相关信号
signal player_health_changed(current: float, maximum: float)
signal player_stamina_changed(current: float, maximum: float)

# 工具相关信号
signal tool_used(tool_item: BaseItem, position: Vector2)
signal tool_action_completed(tool_item: BaseItem)

# 游戏状态信号
signal game_paused
signal game_resumed
