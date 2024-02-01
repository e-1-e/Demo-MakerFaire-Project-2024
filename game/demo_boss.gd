extends CharacterBody2D

@export var projecty : PackedScene
@export var pathContainer : Control
var health = 5

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var awake = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var burrito
func projectile(target):
	if not self:
		return null
	
	var newProject = projecty.instantiate()
	await get_tree().create_timer(1).timeout
	get_parent().add_child(newProject)
	
	print('huh huh huh')
	print(get_parent())
	print(newProject)
	print(get_parent().get_node('Projectile'))
	
	burrito = func(): $BodySprite.animation_finished.disconnect(burrito); $BodySprite.stop(); $BodySprite.play("idle")
	
	$BodySprite.stop()
	$BodySprite.play("punch")
	$BodySprite.animation_finished.connect(burrito)
	
	newProject.position = position + $LeftHandMark.position
	newProject.testProp = true
	print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhh !!!!!!!!! ')
	print(newProject.position)
	newProject.get_node('HeatSeeker').body_entered.connect(func (x):
		#explosion whatever
		if x.name == 'Player' and newProject.testProp:
			newProject.testProp = false
			x.changeHealth(1, 'hit by projectile 💀')
			x.impulse(150, newProject.position.x < x.position.x, 10)
			
			var luhT = newProject.create_tween()
			luhT.tween_property(newProject, 'modulate', Color(0, 0, 0, 0), 0.25)
			luhT.tween_callback(newProject.queue_free)
		elif x.name == 'TileMap':
			newProject.testProp = false
			var luhT = newProject.create_tween()
			luhT.tween_property(newProject, 'modulate', Color(0, 0, 0, 0), 1)
			luhT.tween_callback(newProject.queue_free)
	)
	
	print('SKRRT')
	if target != null and newProject != null and get_tree() and newProject.testProp == true:
		print("YOU CAN GET WHATCHU WANT")
		while newProject.get_parent() == get_parent():
			newProject.position += (target.position - newProject.position).normalized() * 5
			
			if not get_tree(): return null
			if not newProject.testProp: return null
			await get_tree().create_timer(0.001).timeout
			print('CHOSPTICK CAME WITH A LARGE LO MEIN')
			if not is_instance_valid(newProject): return null

#zaigzag
var baseVelocity = Vector2(50, 15) * 1.5
var invertX = 1
var invertY = 1

func _physics_process(delta):
	if not awake or not get_parent(): return null
	
	velocity = baseVelocity * Vector2(invertX, invertY)
	
	if position.x <= pathContainer.get_node('ZigzagGuideL').position.x or position.x >= pathContainer.get_node('ZigzagGuideR').position.x:
		position += Vector2(-2 * invertX, 0)
		invertX *= -1
	
	if position.y <= pathContainer.get_node('ZigzagGuideT').position.y or position.y >= pathContainer.get_node('ZigzagGuideB').position.y:
		position += Vector2(0, -4 * invertY)
		invertY *= -1
	
	move_and_slide()

func _ready():
	await get_tree().create_timer(0.5).timeout
	
	while get_tree() and get_owner() != null:
		await get_tree().create_timer(5).timeout
		
		if get_owner().get_parent() == null: return null
		projectile(get_owner().get_parent().get_node('Player'))
	queue_free()

var healthDebounce = false
func change_health(change):
	if not healthDebounce:
		healthDebounce = true
		health -= change
		
		if health <= 0:
			queue_free()
			#end of the game lmao
		
		await get_tree().create_timer(1).timeout
		healthDebounce = false
