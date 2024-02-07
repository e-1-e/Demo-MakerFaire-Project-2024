extends CharacterBody2D

@export var projecty : PackedScene
@export var pathContainer : Control
@export var health = 5

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var awake = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var burrito

var storeInitPos = {'w' : 3}

func storeInitPositions():
	for i in get_children():
		storeInitPos[i.name] = i.position

func partOffset(offset):
	if not storeInitPos.keys().has('LegSprite'): return null
	
	for i in get_children():
		i.position = storeInitPos[i.name] + offset

func pathContainerTranslate(v : Vector2):
	return pathContainer.position + v

func projectile(target, lefty = true):
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
		var currentDirec = (target.position - newProject.position).normalized() * 5
		while newProject.get_parent() == get_parent():
			newProject.position += currentDirec
			
			if not get_tree(): return null
			if not newProject.testProp: return null
			await get_tree().create_timer(0.001).timeout
			print('CHOSPTICK CAME WITH A LARGE LO MEIN')
			if not is_instance_valid(newProject): return null

#zaigzag
var Loffset = Vector2(0, 0)
var invertX = 2
var invertY = 0

var Poffset = Vector2(0, 0)
var pInvertX = 1

func _physics_process(delta):
	if not awake or not get_parent(): return null
	
	'''
	velocity = baseVelocity * Vector2(invertX, invertY)
	
	if position.x <= pathContainerTranslate(pathContainer.get_node('ZigzagGuideL').position).x or position.x >= pathContainerTranslate(pathContainer.get_node('ZigzagGuideR').position).x:
		position += Vector2(-25 * invertX, 0)
		invertX *= -1
	
	if position.y <= pathContainerTranslate(pathContainer.get_node('ZigzagGuideT').position).y or position.y >= pathContainerTranslate(pathContainer.get_node('ZigzagGuideB').position).y:
		position += Vector2(0, -25 * invertY)
		invertY *= -1
	'''
	
	if (get_owner().get_parent().get_node('Player').position - position).length() > 4000:
		return null
	
	velocity = (get_owner().get_parent().get_node('Player').position - position).normalized() * 300
	
	Loffset += Vector2(invertX, invertY)
	partOffset(Loffset)
	
	#to avoid the 9000 triggers per second check position AND invert(axis). genius!!!!!!!!!!
	if (Loffset.x <= -50 and invertX < 0) or (Loffset.x >= 50 and invertX > 0):
		invertX *= -1
		
	if (Loffset.y <= 150 and invertY < 0) or (Loffset.y >= -150 and invertY > 0):
		invertY *= -1
	
	move_and_slide()

func _ready():
	awake = false
	await get_tree().create_timer(0.5).timeout
	awake = true
	
	storeInitPositions()
	while get_tree() and get_owner() != null:
		await get_tree().create_timer(randf() * 4).timeout
		
		if get_owner().get_parent() == null: return null
		projectile(get_owner().get_parent().get_node('Player'))
	queue_free()

var healthDebounce = false
func change_health(change):
	if not healthDebounce:
		healthDebounce = true
		health -= change
		
		if health <= 0:
			get_parent().get_parent().gameWin.emit()
			queue_free()
			return
			#end of the game lmao
		
		await get_tree().create_timer(1).timeout
		healthDebounce = false
		
		
'''
bryce  come on man this darn thing is giving me anxiety bro why ask for this so close to the end 
its so goddamn complex fr

ok fr im tryna plan....

to achieve the lil zig zag effect while the boss is chasing the player...
	- move the boss root node to actual pos
	- offset the sprites and collision box using the zigzag function
	
	- ASSUMING the root node will rely on the offsetted collision box for collisions
		- when the boss hits a tile, the boss will bounce. 

to achieve the helix, do the same thing lmfaooooooooo
	- instantiate two projectiles
		- their root nodes will move towards the player, no zigzag bs
		- offset sprites and hitbox using luh zigzag funky

'''
