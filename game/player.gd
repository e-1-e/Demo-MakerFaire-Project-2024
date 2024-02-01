extends CharacterBody2D

signal death

@export var health = 5
@export var freezeCam = true
@export var lastDmgReason = ''

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
	
	var newGravity = gravity if not (check_for_tiles().onWall and not is_on_floor()) else gravity * 0.5
	
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
				
				#Handle wall-jump.
				if not $StompDetector.has_overlapping_bodies():
					velocity.x += newSpeed * (-1.5 if check_for_tiles().wallDir == 'right' else 1.5)
					for i in range(25):
						await get_tree().create_timer(0.01).timeout
						velocity.x *= 0.87
						velocity.y -= -25 * (i+1) + 937.5
						move_and_slide()
				else:
					print("slatt! slatt! slatt! slatt!")
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
	
	if not get_owner().inMenu and not freezeCam:
		get_owner().get_node('Camera2D').position = position
		for i in get_tree().get_nodes_in_group('gui'):
			i.position = position - get_viewport_rect().size/2


func _on_death():
	print('vamp anthem! 2')
	position = Vector2(939, 402)
	get_owner().get_node('Camera2D').position = Vector2(960, 540)
	health = 5
	changeHealth(0)
	
func changeHealth(change, reason = ''):
	health -= change
	print(health)
	
	if reason: lastDmgReason = reason
	
	for i in range(1, 6):
		print(health >= i)
		print(i)
		print('YEAH I TOLD U UH BOUT THAT MONEY')
		get_owner().get_node('GuiContainer').get_node('HeartGrid').get_node('TextureRect' + str(i)).visible = health >= i
	
	
func arcFunc(delta : float, v : float = 150):
	#y/(v) = -((x-(h/2))**2)/((h/2)**2) + 1
	
	var h = 100
	
	var x = delta * h if delta < 0.51 else fmod((delta * h),float(h/2))
	
	print('arcFunc logs')
	print(x)
	return v * (-(((x - (h/2))**2)/(h/2)**2) + 1) * (1 if delta > 0.5 else -1)
	
	
#ik, this is stupid, but i cant do nested funcs for no reason
func impulse(power: float, invertX : bool = false, speed : int = 1):
	if anchored or health <= 0:
		return
		
	anchored = true

	for i in 50/speed:
		velocity.x = power * (1 if invertX == true else -1)
		velocity.y = -power + (power * i/(50)/(2 * speed)) #1
		print('HARDCORE IM GOIN')
		print(velocity.y)
		
		velocity *= 3
		
		move_and_slide()
		await get_tree().create_timer(0.0025).timeout
	anchored = false


'''
func _on_stomp_detector_body_entered(body):
	print('tell me....')
	print(body)
	print(get_tree().get_nodes_in_group('enemy'))
	
	if body in get_tree().get_nodes_in_group('enemy') and not anchored and to_global($StompDetector.position).y < body.position.y:
		body.change_health(1)
'''


func _on_ready():
	while true:
		await get_tree().create_timer(0.01).timeout
		var bodyList = $StompDetector.get_overlapping_bodies()
		
		for body in bodyList:
			print('i already told you that its overrrrrrrrrrr')
			print('is the boy an enemy: ' + str(body in get_tree().get_nodes_in_group('enemy')))
			print('AHUWAHHHHHHH' + body.name)
			if body in get_tree().get_nodes_in_group('enemy') and not anchored and to_global($StompDetector.position).y < body.position.y:
				body.change_health(1)
				print('VLONEEEEEEEEEEEE VLONE THUGGGGGGGGG')
