extends Control

@onready var gridContainer = $MarginContainer/AspectRatioContainer/GridContainer
const INVENTORY_SIZE = 24

func _ready() -> void:
	InventoryManager.inventory_changed.connect(redraw_inventory)
	redraw_inventory()

func redraw_inventory():
	var slots = gridContainer.get_children()
	
	for i in range(INVENTORY_SIZE):
		var slot = slots[i]
		var inventory_item = InventoryManager.items[i]
		
		if (slot.item == null and inventory_item != null):
			slot.set_item(inventory_item)
			
		elif (slot.item != null and inventory_item != null):
			if (slot.item != inventory_item or slot.item.count != inventory_item.count):
				slot.set_item(inventory_item)
		
		elif (slots[i].item != null and InventoryManager.items[i] == null):
			slots[i].item.i = 0
			
		slots[i].update_slot()
			
			
