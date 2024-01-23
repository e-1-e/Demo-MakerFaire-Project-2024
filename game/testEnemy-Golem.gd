extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var health = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


'''
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
'''

'''
agenda:
	- knockback player on touch
	- add additional positional check to player attack
'''

var prev_rotation

func _physics_process(delta):
	if get_owner() == null or health == 0:
		return null
		
	
	position = get_owner().get_node('enemyPath1').get_node('PathFollow2D').position
	#print(position)
	get_owner().get_node('enemyPath1').get_node('PathFollow2D').progress_ratio += 0.001
	
	if get_owner().get_node('enemyPath1').get_node('PathFollow2D').rotation != prev_rotation:
		position -= (Vector2(90, 0) if scale.x != 2 else Vector2(-90, 0))
	
	scale = Vector2(2, 2) if get_owner().get_node('enemyPath1').get_node('PathFollow2D').rotation != 0 else Vector2(-2, 2)
	
	prev_rotation = get_owner().get_node('enemyPath1').get_node('PathFollow2D').rotation

func change_health(change):
	if attackDebounce: return null
	
	health -= change
	if health <= 0:
		queue_free()

func _on_ready():
	$AnimatedSprite2D.play("new_animation")

var attackDebounce = false

func _on_hitbox_body_entered(body):
	if body.name == 'Player' and not attackDebounce:
		print(body.position.y > position.y)
		print("TELL ME LIL UZI VERT WHY YOU SO DOPE")
		
		if health <= 0:
			return null
		
		attackDebounce = true
		body.health -= 1
		body.impulse(Vector2(150 * (-1 if scale.x > 0 else 1), -150))
		await get_tree().create_timer(2).timeout
		attackDebounce = false


'''
func _on_fatal_hitbox_body_entered(body):
	if body.name == 'Player' and not attackDebounce:
		print(body.get_node('StompDetector').get_overlapping_bodies())
		if not body.get_node('StompDetector').get_overlapping_bodies().has(self):
			return
		
		attackDebounce = true
		change_health(1)
		if health > 0:
			attackDebounce = false
'''
