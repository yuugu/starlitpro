extends Node
class_name IUsable

# 可使用接口
# 实现此接口的对象可以被玩家使用

# 使用物品
func use(user: Node) -> void:
	pass

# 检查是否可以使用
func can_use(user: Node) -> bool:
	return true

# 获取使用提示
func get_use_hint() -> String:
	return "Use" 