# game/ui/windows/inventory_window.gd
extends Control

@onready var tabs: TabContainer = $Panel/TabContainer
@onready var all_grid: GridContainer = $Panel/TabContainer/All/GridContainer
@onready var tools_grid: GridContainer = $Panel/TabContainer/Tools/GridContainer
@onready var resources_grid: GridContainer = $Panel/TabContainer/Res/GridContainer
@onready var weapons_grid: GridContainer = $Panel/TabContainer/Weapons/GridContainer
@onready var item_slot_scene = preload("res://game/ui/components/item_slot.tscn")
@onready var title_label: Label = $Panel/TitleBar/Title
@onready var tooltip: Panel = $ItemTooltip

var player_inventory: PlayerInventory
var selected_slot: Control = null

func _ready() -> void:
	# 初始化时隐藏窗口
	hide()
	tooltip.hide()
	
	# 连接背包开关信号
	GameEvents.toggle_inventory.connect(_on_toggle_inventory)
	
	# 获取玩家背包引用
	await get_tree().process_frame
	_find_player_inventory()
	
	# 设置窗口标题
	title_label.text = "Bag"

func _find_player_inventory() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player_inventory = player.inventory
		if player_inventory:
			player_inventory.inventory_changed.connect(refresh_inventory)
			refresh_inventory()
		else:
			push_error("无法找到玩家背包组件")
	else:
		push_error("场景中没有玩家对象")

func _on_toggle_inventory() -> void:
	visible = !visible
	if visible:
		refresh_inventory()
	else:
		# 关闭背包时隐藏提示
		tooltip.hide()
		# 取消选中状态
		if selected_slot:
			selected_slot.set_selected(false)
			selected_slot = null

func _on_close_button_pressed() -> void:
	visible = false

func refresh_inventory() -> void:
	# 清除所有分类中的物品
	_clear_grid(all_grid)
	_clear_grid(tools_grid)
	_clear_grid(resources_grid)
	_clear_grid(weapons_grid)
	
	if not player_inventory:
		return
	
	# 计算每个分类应该有多少格子（固定数量）
	var slots_per_tab = 25  # 5x5网格
	
	# 为每个物品创建槽位并放入对应分类
	for item in player_inventory.items:
		# 添加到"全部"分类
		var all_slot = item_slot_scene.instantiate()
		all_grid.add_child(all_slot)
		all_slot.set_item(item)
		all_slot.item_clicked.connect(_on_item_clicked)
		
		# 根据物品类型添加到对应分类
		match item.item_type:
			BaseItem.ItemType.TOOL:
				var tool_slot = item_slot_scene.instantiate()
				tools_grid.add_child(tool_slot)
				tool_slot.set_item(item)
				tool_slot.item_clicked.connect(_on_item_clicked)
			BaseItem.ItemType.MATERIAL:
				var resource_slot = item_slot_scene.instantiate()
				resources_grid.add_child(resource_slot)
				resource_slot.set_item(item)
				resource_slot.item_clicked.connect(_on_item_clicked)
			BaseItem.ItemType.WEAPON:
				var weapon_slot = item_slot_scene.instantiate()
				weapons_grid.add_child(weapon_slot)
				weapon_slot.set_item(item)
				weapon_slot.item_clicked.connect(_on_item_clicked)
	
	# 添加空槽位，确保每个Tab都有相同数量的格子
	_add_empty_slots(all_grid, slots_per_tab - all_grid.get_child_count())
	_add_empty_slots(tools_grid, slots_per_tab - tools_grid.get_child_count())
	_add_empty_slots(resources_grid, slots_per_tab - resources_grid.get_child_count())
	_add_empty_slots(weapons_grid, slots_per_tab - weapons_grid.get_child_count())

func _on_item_clicked(item: BaseItem, button: int) -> void:
	# 获取被点击的槽位
	var slot = get_viewport().gui_get_focus_owner()
	if not slot or not slot is Control or not slot.has_method("set_selected"):
		return
	
	# 左键点击选中物品
	if button == MOUSE_BUTTON_LEFT:
		# 如果有之前选中的槽位，取消选中
		if selected_slot and selected_slot != slot:
			selected_slot.set_selected(false)
		
		# 切换当前槽位的选中状态
		var is_selected = !slot.is_selected()
		slot.set_selected(is_selected)
		
		if is_selected:
			selected_slot = slot
		else:
			selected_slot = null

func _clear_grid(grid: GridContainer) -> void:
	for child in grid.get_children():
		child.queue_free()

func _add_empty_slots(grid: GridContainer, count: int) -> void:
	for i in range(count):
		var empty_slot = item_slot_scene.instantiate()
		grid.add_child(empty_slot)
		empty_slot.set_item(null)

func _input(event: InputEvent) -> void:
	# 按ESC键关闭背包
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE and visible:
		_on_close_button_pressed()
