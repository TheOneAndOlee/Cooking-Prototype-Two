extends StaticBody3D

@export var interactRadius = 1
@export var cookingTime = 1

@onready var textPrompt: Label3D = $Area3D/Label3D

var canCook = false

func on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		textPrompt.show()
		canCook = true

func on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		textPrompt.hide()
		canCook = false
