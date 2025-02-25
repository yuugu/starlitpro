# core/base/base_item.gd  
extends Resource  
class_name BaseItem  

signal use_started
signal use_completed

@export var id: String  
@export var name: String  
@export var icon: Texture2D  
@export var description: String  
@export var stackable: bool = false  
@export var max_stack: int = 1  

# 物品类型枚举
enum ItemType {
	GENERAL,
	TOOL,
	SEED,
	CROP,
	MATERIAL,
	WEAPON
}

@export var item_type: ItemType = ItemType.GENERAL

# 基础使用方法，子类应该重写此方法
func use(player: Player) -> void:  
	use_started.emit()
	# 默认实现为空
	use_completed.emit()

# 获取物品类型的字符串表示
func get_type_string() -> String:
	match item_type:
		ItemType.GENERAL: return "General"
		ItemType.TOOL: return "tools"
		ItemType.SEED: return "seeds"
		ItemType.CROP: return "crops"
		ItemType.MATERIAL: return "materials"
		ItemType.WEAPON: return "weapons"
		_: return "unknown"
