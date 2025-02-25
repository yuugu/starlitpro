extends Node
class_name ObjectPool

# 对象池
# 用于重用对象，减少实例化和销毁的开销

var scene_path: String
var pool: Array[Node] = []
var active_objects: Array[Node] = []
var parent_node: Node

func _init(p_scene_path: String, p_parent_node: Node, initial_size: int = 10) -> void:
	scene_path = p_scene_path
	parent_node = p_parent_node
	
	# 预先创建对象
	for i in range(initial_size):
		var obj = _create_object()
		pool.append(obj)
		obj.visible = false

# 创建新对象
func _create_object() -> Node:
	var scene = load(scene_path)
	var obj = scene.instantiate()
	parent_node.add_child(obj)
	return obj

# 从池中获取对象
func get_object() -> Node:
	var obj: Node
	
	if pool.size() > 0:
		# 从池中取出一个对象
		obj = pool.pop_back()
	else:
		# 池为空，创建新对象
		obj = _create_object()
	
	# 激活对象
	obj.visible = true
	active_objects.append(obj)
	
	return obj

# 回收对象到池中
func release_object(obj: Node) -> void:
	if obj == null:
		return
	
	# 从活动对象列表中移除
	var index = active_objects.find(obj)
	if index != -1:
		active_objects.remove_at(index)
	
	# 重置对象状态
	obj.visible = false
	
	# 如果对象有reset方法，调用它
	if obj.has_method("reset"):
		obj.reset()
	
	# 放回池中
	pool.append(obj)

# 回收所有活动对象
func release_all() -> void:
	while active_objects.size() > 0:
		release_object(active_objects[0])

# 清空池
func clear() -> void:
	# 回收所有活动对象
	release_all()
	
	# 销毁池中所有对象
	for obj in pool:
		obj.queue_free()
	
	pool.clear() 