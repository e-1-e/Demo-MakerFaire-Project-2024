extends CharacterBody2D

signal death

const SPEED = 300.0
const JUMP_VELOCITY = -1100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	var newGravity = gravity if not is_on_wall() else gravity / 2
	
	if not is_on_floor():
		velocity.y += newGravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			velocity.y = 0
			print($WallDetectorArea.get_overlapping_bodies())
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	var newSpeed = SPEED * 2 if Input.is_action_pressed("shift") else SPEED
	
	if direction:
		velocity.x = direction * newSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, newSpeed)
		
	velocity *= (0 if is_on_wall() else 1)

	move_and_slide()
	
	if not get_owner().inMenu:
		get_owner().get_node('Camera2D').position = position


func _on_death():
	print('vamp anthem! 2')
	position = Vector2(939, 402)
	get_owner().get_node('Camera2D').position = Vector2(960, 540)
