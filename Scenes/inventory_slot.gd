extends Control

@onready var count = $ContentContainer/ItemCount
@onready var texture = $ContentContainer/ItemTexture
@onready var outline = $Outline

@export var item: item

var tween_hover: Tween
var tween_rot: Tween
@export var transition_type : Tween.TransitionType
@export var transition_duration: float

func _ready():
	pivot_offset = size/2.0
	
	update_slot()
	var apple = load("res://resources/red_apple.tres")
	set_item(apple)

func update_slot() -> void:
	if (!item):
		print("Item not found! Is this a bug?")
	else:
		print("Item found!")
		texture.texture = item.texture
		count.text = str(item.count)
		
		set_visibility(true)

func set_visibility(visibility : bool):
	count.visible = visibility
	texture.visible = visibility

func set_item(to_set: Resource):
	self.item = to_set
	update_slot()

func click_interaction(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if item:
			return

func start_hover_animation() -> void:
	#print("Hovering on item: ", item.name)
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(transition_type)
	tween_hover.tween_property(self, "scale", Vector2(1.1, 1.1), transition_duration)
	

func end_hovering_animation() -> void:
	#print("Not hovering on item: ", item.name)
	
	#Rotation Tweening, not required as of right now, so it'll be left commented
	#if tween_rot and tween_rot.is_running():
		#tween_rot.kill()
	#tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	
	#Reset Tween Scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(transition_type)
	tween_hover.tween_property(self, "scale", Vector2.ONE, transition_duration)

func _get_drag_data(at_position: Vector2):
	if not item:
		return null
	
	var payload = {
		"item": item,
		"root_slot": self
	}
	
	var preview_root = Control.new()
	
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture.texture
	preview_texture.size = texture.size
	
	var preview_count = count.duplicate()
	preview_count.size = preview_texture.size / 2.0
	preview_count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	preview_count.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	
	preview_root.add_child(preview_texture)
	preview_root.add_child(preview_count)
	
	preview_texture.position = -preview_texture.size / 2.0
	preview_count.position = Vector2(0, -preview_texture.size.y / 2.0)
	
	set_drag_preview(preview_root)
	
	print("Dragging item: ", item.name)
	
	return payload

func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item")

func _drop_data(at_position: Vector2, data):
	print("Dropped ", item.name, " onto ", self.name)
	var root_slot = data.root_slot
	var dropped_item = data.item
	
	if root_slot == self:
		return
	
	var current_item = self.item
	set_item(dropped_item)
	
	root_slot.set_item(current_item)
