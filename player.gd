extends CharacterBody3D

#Parameters
var speed = 0.0
@export var walk_speed = 5.0
@export var sprint_speed = 7.5
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002

@export var base_stamina = 100
var stamina = 0

@export var bob_frequency = 2.
@export var bob_amp = 0.08
var t_bob = 0.0

@export var base_FOV = 75.0
@export var FOV_change = 1.5

#Retrive Gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Directly Retrieve Camera Reference
@onready var camera = $Head/Camera3D
@onready var head = $Head

@onready var inventory = $InventoryUI

#Locks Camera and Hides Cursor
func _ready():
	stamina = base_stamina
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inventory.visible = false

#Rotate Body and Cameras
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * mouse_sensitivity) 
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	if inventory.visible == true:
		inventory.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		inventory.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if (Input.is_action_pressed("sprint")):
		speed = sprint_speed
	else:
		speed = walk_speed
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 9.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 9.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 0.5)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 0.5)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	var velocity_clamped = clamp(velocity.length(), 0.5, sprint_speed * 2)
	var target_fov = base_FOV + FOV_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amp
	pos.x = cos(time * bob_frequency / 2) * bob_amp 
	return pos
