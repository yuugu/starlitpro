extends Node
class_name IEquippable

# 可装备接口
# 实现此接口的对象可以被玩家装备

# 装备物品
func equip(user: Node) -> void:
	pass

# 卸下物品
func unequip(user: Node) -> void:
	pass

# 检查是否可以装备
func can_equip(user: Node) -> bool:
	return true

# 获取装备类型
func get_equip_slot() -> String:
	return "hand" 