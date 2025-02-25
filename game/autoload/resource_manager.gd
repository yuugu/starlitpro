extends Node

# 资源管理器
# 负责加载和缓存游戏资源，避免重复加载

# 缓存字典
var _texture_cache: Dictionary = {}
var _scene_cache: Dictionary = {}
var _resource_cache: Dictionary = {}

# 加载纹理并缓存
func load_texture(path: String) -> Texture2D:
	if _texture_cache.has(path):
		return _texture_cache[path]
	
	var texture = load(path) as Texture2D
	if texture:
		_texture_cache[path] = texture
	else:
		push_error("无法加载纹理: " + path)
	
	return texture

# 加载场景并缓存
func load_scene(path: String) -> PackedScene:
	if _scene_cache.has(path):
		return _scene_cache[path]
	
	var scene = load(path) as PackedScene
	if scene:
		_scene_cache[path] = scene
	else:
		push_error("无法加载场景: " + path)
	
	return scene

# 加载资源并缓存
func load_resource(path: String) -> Resource:
	if _resource_cache.has(path):
		return _resource_cache[path]
	
	var resource = load(path)
	if resource:
		_resource_cache[path] = resource
	else:
		push_error("无法加载资源: " + path)
	
	return resource

# 实例化场景
func instantiate_scene(path: String) -> Node:
	var scene = load_scene(path)
	if scene:
		return scene.instantiate()
	return null

# 清除特定类型的缓存
func clear_texture_cache() -> void:
	_texture_cache.clear()

func clear_scene_cache() -> void:
	_scene_cache.clear()

func clear_resource_cache() -> void:
	_resource_cache.clear()

# 清除所有缓存
func clear_all_caches() -> void:
	clear_texture_cache()
	clear_scene_cache()
	clear_resource_cache()

# 预加载资源列表
func preload_resources(paths: Array) -> void:
	for path in paths:
		var extension = path.get_extension().to_lower()
		if extension == "png" or extension == "jpg" or extension == "webp":
			load_texture(path)
		elif extension == "tscn":
			load_scene(path)
		else:
			load_resource(path) 
