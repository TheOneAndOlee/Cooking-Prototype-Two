extends Node

signal inventory_changed

var items = []
var overflow = []

func _init() -> void:
	const INVENTORY_SIZE = 24
	items.resize(INVENTORY_SIZE)
	overflow.resize(1)
	items.fill(null)

func obtain_item(to_set: item):
	for i in range(items.size()):
		if (items[i] != null):
			var current_name = items[i].name.strip_edges().to_lower()
			var new_name = to_set.name.strip_edges().to_lower()
			if (current_name == new_name):
				items[i].count += to_set.count
				to_set.count = 0
				inventory_changed.emit()
				return true
		
	for i in range(items.size()):
		if (items[i] == null):
			items[i] = to_set
			to_set.count = 0
			inventory_changed.emit()
			return true
		
	if overflow[0] == null:
		print("No space in inventory! Adding it to overflow...")
		overflow[0] = to_set
	else: 
		print("Inventory & Overflow are full! Replacing ", overflow[0], " with ", to_set.name)
		overflow[0] = to_set
	return false
	
