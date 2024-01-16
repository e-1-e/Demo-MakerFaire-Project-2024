extends CharacterBody2D

signal death

const SPEED = 300.0
const JUMP_VELOCITY = -1100.0

var onWall = is_on_wall()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func check_for_tiles():
	if not get_owner() or not get_owner().get_node('GameMapNode'):
		print('EXCEPTION 9')
		return {
			onWall = false
		}
	
	var tileMap = get_owner().get_node('GameMapNode').get_node('TileMap')
	var tile1 = tileMap.get_cell_tile_data(0, tileMap.local_to_map(tileMap.to_local(position)) + Vector2i(1, 0))
	var tile2 = tileMap.get_cell_tile_data(0, tileMap.local_to_map(tileMap.to_local(position)) - Vector2i(1, 0))
	
	return {
		onWall = (tile1 != null) or (tile2 != null),
		wallDir = null if not (tile1 != null) or (tile2 != null) else ('right' if tile1 != null else 'left')
	}

func _physics_process(delta):
	# Add the gravity.
	
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if onWall:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var newSpeed = SPEED * 2 if Input.is_action_pressed("shift") else SPEED
	
	var newGravity = gravity if not is_on_wall() else gravity / 3
	
	if not is_on_floor():
		velocity.y += newGravity * delta
	
	if direction and not onWall:
		velocity.x = direction * newSpeed
	elif not onWall:
		velocity.x = move_toward(velocity.x, 0, newSpeed)
		
	#velocity *= (0 if (is_on_wall() and check_for_tiles().onWall and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"))) else 1)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and check_for_tiles().onWall:
			print('dis RES')
			onWall = true
			velocity.x += newSpeed * (-6.5 if check_for_tiles().wallDir == 'right' else 6.5)
			for i in range(25):
				await get_tree().create_timer(0.01).timeout
				velocity.x *= 0.9
				velocity.y += -36 * (i+1) + 1350
				move_and_slide()
			onWall = false

	move_and_slide()
	
	if not get_owner().inMenu:
		get_owner().get_node('Camera2D').position = position


func _on_death():
	print('vamp anthem! 2')
	position = Vector2(939, 402)
	get_owner().get_node('Camera2D').position = Vector2(960, 540)
