extends Control

@onready var gridContainer = $MarginContainer/AspectRatioContainer/GridContainer

func _ready() -> void:
	InventoryManager.inventory_changed.connect(redraw_inventory)
	redraw_inventory()

func redraw_inventory():
	var slots = gridContainer.get_children()
	
	for i in range(slots.size()):
		var item_to_add = InventoryManager.items[i]
		slots[i].set_item(item_to_add)
		slots[i].update_slot()
