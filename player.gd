extends CharacterBody3D

#Parameters
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002

#Retrive Gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Directly Retrieve Camera Reference
@onready var camera = $Camera3D

#Locks Camera and Hides Cursor
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Rotate Body and Cameras
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
