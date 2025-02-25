# systems/player/player.gd
extends BaseActor
class_name Player

signal tool_equipped(tool_item: BaseItem)
signal tool_unequipped(tool_item: BaseItem)

@onready var stats: PlayerStats = $PlayerStats
@onready var inventory: PlayerInventory = $PlayerInventory

var current_tool: BaseItem

func _ready() -> void:
	super._ready()
	add_to_group("player")
	
	# 连接信号
	GameEvents.item_equipped.connect(_on_item_equipped)
	GameEvents.item_unequipped.connect(_on_item_unequipped)
	
	# 设置初始状态
	state_machine.transition_to("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		GameEvents.toggle_inventory.emit()
	
	# 使用工具（左键）
	if event.is_action_pressed("use_tool") and current_tool:
		use_tool()

func equip_tool(tool_item: BaseItem) -> void:
	if current_tool != tool_item:
		current_tool = tool_item
		tool_equipped.emit(tool_item)

func unequip_tool() -> void:
	if current_tool:
		var old_tool = current_tool
		current_tool = null
		tool_unequipped.emit(old_tool)

func use_tool() -> void:
	if current_tool and state_machine.get_current_state() != "tool_use":
		state_machine.transition_to("tool_use")

func _on_item_equipped(item: BaseItem) -> void:
	if item.item_type == BaseItem.ItemType.TOOL:
		equip_tool(item)

func _on_item_unequipped(item: BaseItem) -> void:
	if current_tool == item:
		unequip_tool()
