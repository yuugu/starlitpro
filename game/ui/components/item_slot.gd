# game/ui/components/item_slot.gd
extends Panel

signal item_clicked(item: BaseItem, button: int)
signal item_double_clicked(item: BaseItem)

@export var hover_style: StyleBox
@export var selected_style: StyleBox
@export var normal_style: StyleBox

@onready var icon: TextureRect = $Icon
@onready var item_count: Label = $ItemCount

var item: BaseItem
var is_dragging: bool = false
var _is_selected: bool = false
var _is_mouse_over: bool = false  # 添加鼠标悬停状态跟踪

func _ready() -> void:
	# 保存默认样式
	if not normal_style:
		normal_style = get_theme_stylebox("panel")
	
	# 连接鼠标信号
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func set_item(new_item: BaseItem) -> void:
	item = new_item
	if item:
		icon.texture = item.icon
		
		# 如果物品可堆叠且数量大于1，显示数量
		if item.stackable and item.max_stack > 1:
			item_count.text = str(1) # 这里应该是物品的实际数量，暂时设为1
			item_count.show()
		else:
			item_count.hide()
	else:
		icon.texture = null
		item_count.hide()

func _gui_input(event: InputEvent) -> void:
	if not item:
		return
		
	if event is InputEventMouseButton and event.pressed:
		# 发送点击信号
		item_clicked.emit(item, event.button_index)
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			# 右键使用物品
			var player = get_tree().get_first_node_in_group("player")
			if player:
				item.use(player)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			# 双击物品
			item_double_clicked.emit(item)

func _on_mouse_entered() -> void:
	_is_mouse_over = true  # 设置鼠标悬停状态
	
	if item:
		# 显示物品提示
		var inventory_window = find_parent("InventoryWindow")
		if inventory_window:
			var tooltip = inventory_window.get_node("ItemTooltip")
			if tooltip:
				tooltip.get_node("VBoxContainer/ItemName").text = item.name
				tooltip.get_node("VBoxContainer/ItemType").text = item.get_type_string()
				tooltip.get_node("VBoxContainer/ItemDescription").text = item.description
				
				# 设置提示位置在鼠标附近
				var mouse_pos = get_viewport().get_mouse_position()
				tooltip.position = Vector2(mouse_pos.x + 15, mouse_pos.y + 15)
				
				# 确保提示不超出屏幕
				var viewport_size = get_viewport_rect().size
				if tooltip.position.x + tooltip.size.x > viewport_size.x:
					tooltip.position.x = viewport_size.x - tooltip.size.x
				if tooltip.position.y + tooltip.size.y > viewport_size.y:
					tooltip.position.y = viewport_size.y - tooltip.size.y
					
				tooltip.show()
		
		# 高亮显示
		if not _is_selected and hover_style:
			add_theme_stylebox_override("panel", hover_style)

func _on_mouse_exited() -> void:
	_is_mouse_over = false  # 清除鼠标悬停状态
	
	# 隐藏提示
	var inventory_window = find_parent("InventoryWindow")
	if inventory_window:
		var tooltip = inventory_window.get_node("ItemTooltip")
		if tooltip:
			tooltip.hide()
	
	# 恢复样式
	if not _is_selected:
		add_theme_stylebox_override("panel", normal_style)

# 设置选中状态
func set_selected(selected: bool) -> void:
	_is_selected = selected
	if _is_selected:
		add_theme_stylebox_override("panel", selected_style)
	else:
		add_theme_stylebox_override("panel", normal_style)

# 获取选中状态
func is_selected() -> bool:
	return _is_selected

# 处理鼠标移动，更新提示位置
func _process(_delta: float) -> void:
	if _is_mouse_over and item:  # 使用_is_mouse_over替代is_hovered()
		var inventory_window = find_parent("InventoryWindow")
		if inventory_window:
			var tooltip = inventory_window.get_node("ItemTooltip")
			if tooltip and tooltip.visible:
				var mouse_pos = get_viewport().get_mouse_position()
				tooltip.position = Vector2(mouse_pos.x + 15, mouse_pos.y + 15)
				
				# 确保提示不超出屏幕
				var viewport_size = get_viewport_rect().size
				if tooltip.position.x + tooltip.size.x > viewport_size.x:
					tooltip.position.x = viewport_size.x - tooltip.size.x
				if tooltip.position.y + tooltip.size.y > viewport_size.y:
					tooltip.position.y = viewport_size.y - tooltip.size.y
