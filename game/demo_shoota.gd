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

var prev_rotation = 0

@export var myPathFollow : PathFollow2D
@export var projecty : PackedScene

func inverseScale():
	$LegSprite.scale *= Vector2(-1, 1)
	$BodySprite.scale *= Vector2(-1, 1)

func _physics_process(delta):
	if get_parent() == null or health == 0:
		return null
		
	
	position = myPathFollow.position
	#print(position)
	myPathFollow.progress_ratio += 0.001
	print(myPathFollow.progress_ratio)
	print(int(myPathFollow.progress_ratio * 10))
	
	'''
	if get_parent().get_node('enemyPath1').get_node('PathFollow2D').rotation != prev_rotation:
		position -= (Vector2(90, 0) if $AnimatedSprite2D.scale.x != 0.184 else Vector2(-90, 0))
	'''
	
	#scale = Vector2(2, 2) if get_parent().get_node('enemyPath1').get_node('PathFollow2D').rotation != 0 else Vector2(-2, 2)
	if (int(myPathFollow.progress_ratio * 10) == 5 and prev_rotation != 5) or (int(myPathFollow.progress_ratio * 10) == 0 and prev_rotation != 0):
		inverseScale()
		prev_rotation = int(myPathFollow.progress_ratio * 10)

func change_health(change):
	if attackDebounce: return null
	attackDebounce = true
	
	health -= change
	if health <= 0:
		queue_free()

func _on_ready():
	$LegSprite.play("walk")
	prev_rotation = myPathFollow.rotation
	inverseScale()
	
	while true:
		await get_tree().create_timer(1.85).timeout
		print('U TELLIN ME U FALLIN OUTTA LUV W ME')
		print((get_owner().get_parent().get_node('Player').position - position).length())
		if (get_owner().get_parent().get_node('Player').position - position).length() > 800:
			continue
		
		var newProject = projecty.instantiate()
		get_parent().add_child(newProject)
		newProject.position = position - Vector2(0, 10)
		newProject.testProp = true
		newProject.scale *= 0.8
		newProject.constantTravel((get_owner().get_parent().get_node('Player').position - position).normalized() * 5)
		$BodySprite.play("spit")
		$BodySprite.animation_finished.connect(func():
			$BodySprite.play("idle")
		, 4)

var attackDebounce = false


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
