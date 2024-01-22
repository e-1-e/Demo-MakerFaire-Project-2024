extends CharacterBody2D

signal death

@export var health = 5

const SPEED = 1200.0
const JUMP_VELOCITY = -900.0

var onWall = is_on_wall()
var anchored = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func check_for_tiles():
	if not get_owner() or not get_owner().get_node('GameMapNode'):
		print('EXCEPTION 9')
		return {
			onWall = false
		}
	
	var tileMap = get_owner().get_node('GameMapNode').get_node('TileMap')
	var tile1 = $WallDetectorAreaTL.get_overlapping_bodies().has(tileMap)
	var tile2 = $WallDetectorAreaTR.get_overlapping_bodies().has(tileMap)
	
	return {
		onWall = (tile1 != false) or (tile2 != false),
		wallDir = null if (tile1 == false) and (tile2 == false) else ('right' if tile1 != true else 'left')
	}

func _physics_process(delta):
	# Add the gravity.
	if health == 0:
		death.emit()
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if onWall and not anchored:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var newSpeed = SPEED / 2 if Input.is_action_pressed("shift") else SPEED
	
	var newGravity = gravity if not is_on_wall() else gravity
	
	if not anchored:
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
					velocity.x *= 0.8
					velocity.y -= -30 * (i+1) + 1125
					move_and_slide()
				onWall = false
				
		if Input.is_action_just_pressed("testKey"): #shift + B
			print("----+++ DEBUG PLAYER INFO +++---- 🏁")
			print("VELOCITY: " + str(velocity))
			print("CURRENT newSpeed: " + str(newSpeed))
			print("CURRENT newGravity: " + str(newGravity))
			print("anchored?: " + str(anchored))
			print("CURRENT newSpeed: " + str(newSpeed))
			print("CURRENT health: " + str(health))
			print("CURRENT collisions: " + str($WallDetectorAreaTL.get_overlapping_bodies()))
		move_and_slide()
	
	if not get_owner().inMenu:
		get_owner().get_node('Camera2D').position = position


func _on_death():
	print('vamp anthem! 2')
	position = Vector2(939, 402)
	get_owner().get_node('Camera2D').position = Vector2(960, 540)
	health = 5
	
	
func arcFunc(startingPoint : Vector2, endPoint : Vector2, delta : float):
	print('DELTA... ' + str(delta))
	var change = (endPoint.x - startingPoint.x) * delta
	return -((endPoint.y - startingPoint.y)/(endPoint.x - startingPoint.x)) * sqrt(-(change**2) + (endPoint.x - startingPoint.x)**2) + (endPoint.y-startingPoint.y)
	
#ik, this is stupid, but i cant do nested funcs for no reason
func impulse(directio : Vector2):
	if anchored:
		return
		
	anchored = true
	var endPos = position + directio
	
	var start = position
	
	for i in 10:
		velocity.x = (endPos.x - position.x)
		velocity.y = arcFunc(start, endPos, float(i+1)/10.0) * 1.35
		print('LOG: ' + str(i))
		print(velocity.y)
		
		velocity *= 3
		
		move_and_slide()
		await get_tree().create_timer(0.01).timeout
	anchored = false
