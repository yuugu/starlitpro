# systems/player/player_inventory.gd  
extends Node  
class_name PlayerInventory  

signal inventory_changed  
signal item_added(item: BaseItem)
signal item_removed(item: BaseItem)

var items: Array[BaseItem] = []  
var equipped_item: BaseItem  
var max_items: int = 20  # 背包最大容量

func _ready() -> void:  
	# 初始道具  
	var hoe = HoeTool.new()  
	add_item(hoe)  

func add_item(item: BaseItem) -> bool:  
	# 检查背包是否已满
	if items.size() >= max_items:
		return false
		
	items.append(item)  
	item_added.emit(item)
	inventory_changed.emit()
	return true

func remove_item(item: BaseItem) -> bool:
	var index = items.find(item)
	if index == -1:
		return false
		
	items.remove_at(index)
	item_removed.emit(item)
	inventory_changed.emit()
	return true

func equip_item(item: BaseItem) -> void:  
	if equipped_item:  
		unequip_item()  
	
	equipped_item = item  
	GameEvents.item_equipped.emit(item)  

func unequip_item() -> void:  
	if equipped_item:  
		var old_item = equipped_item  
		equipped_item = null  
		GameEvents.item_unequipped.emit(old_item)

# 查找指定ID的物品
func find_item_by_id(item_id: String) -> BaseItem:
	for item in items:
		if item.id == item_id:
			return item
	return null
