extends Node

signal inventory_changed

var items = []
var overflow = []

func _init() -> void:
	var inventory_size = 24
	items.resize(inventory_size)
	overflow.resize(1)
	items.fill(null)

func obtain_item(to_set: item):
	for i in range(items.size()):
		if items[i] == null:
			items[i] = to_set
			inventory_changed.emit()
			return true
	if overflow[0] == null:
		print("No space in inventory! Adding it to overflow...")
		overflow[0] = to_set
	else: 
		print("Inventory & Overflow are full! Replacing ", overflow[0], " with ", to_set.name)
		overflow[0] = to_set
	return false
	
