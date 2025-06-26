extends StaticBody3D

@export var interactRadius = 1

@onready var textPrompt: Label3D = $Area3D/Label3D

var canPick = false

@export var apple: item

func apple_get():
	InventoryManager.obtain_item(apple.duplicate())

func _process(_delta: float) -> void:
	if (canPick == true) and Input.is_action_just_pressed("interact"):
		print("Pick Apple!")
		apple_get()

func on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		textPrompt.show()
		canPick = true

func on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		textPrompt.hide()
		canPick = false

#func ActivateCookingMenu() -> void:
	
