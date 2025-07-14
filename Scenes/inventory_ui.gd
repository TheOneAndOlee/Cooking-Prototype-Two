extends Control

@onready var gridContainer = $MarginContainer/AspectRatioContainer/GridContainer

func _ready() -> void:
	InventoryManager.inventory_changed.connect(redraw_inventory)
	redraw_inventory()

func redraw_inventory():
	var slots = gridContainer.get_children()
	
	for i in range(InventoryManager.items.size()):
		if (InventoryManager.items[i] != null):
			slots[i].set_item(InventoryManager.items[i])
			slots[i].update_slot()
			
