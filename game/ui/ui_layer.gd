# game/ui/ui_layer.gd  
extends CanvasLayer  

@onready var inventory_window = $InventoryWindow  

func _ready() -> void:  
	# 确保初始状态是隐藏的  
	inventory_window.hide()
