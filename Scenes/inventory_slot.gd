extends Panel

@onready var count = $ItemCount
@onready var texture = $ItemTexture
@onready var outline = self

@export var item: item_data

func _ready():
	update_slot()
	var apple = load("res://resources/red_apple.tres")
	set_item(apple)

func update_slot() -> void:
	if !item:
		print("Item not found! Is this a bug?")
	else:
		print("Works!")
		texture = item.texture
		count = str(item.count)
		texture.visible = true
		count.visible = true


func set_item(new_item: Resource):
	self.item = new_item
	update_slot()

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if item:
			print("Clicked on item ", item.name)
