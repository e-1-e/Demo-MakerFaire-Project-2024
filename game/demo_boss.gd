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

#attack functions
func projectile(target = null, lefty = true, god = false):
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
	if not god:
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
	if target == null:
		return newProject
	elif target != null and newProject != null and get_tree() and newProject.testProp == true:
		print("YOU CAN GET WHATCHU WANT")
		var currentDirec = (target.position - newProject.position).normalized() * 5
		while newProject.get_parent() == get_parent():
			newProject.position += currentDirec * 4.5/maxProjectileDebounce
			
			if not get_tree(): return null
			if not newProject.testProp: return null
			await get_tree().create_timer(0.001).timeout
			print('CHOSPTICK CAME WITH A LARGE LO MEIN')
			if not is_instance_valid(newProject): return null

var isUsingBeam = false

func projectyDirected(direction):
	var newProjec = await projectile(null, true, true)
	isUsingBeam = true
	
	newProjec.get_node('HeatSeeker').body_entered.connect(func (x):
		#explosion whatever
		if x.name == 'Player' and newProjec.testProp:
			newProjec.testProp = false
			x.changeHealth(1, 'hit by projectile 💀')
			x.impulse(150, newProjec.position.x < x.position.x, 10)
			
			var luhT = newProjec.create_tween()
			luhT.tween_property(newProjec, 'modulate', Color(0, 0, 0, 0), 0.075)
			luhT.tween_callback(newProjec.queue_free)
	)
	
	var currentCount = 0
	while is_instance_valid(newProjec):
		newProjec.position += direction
		await get_tree().create_timer(0.01).timeout
		currentCount += 0.01
		if currentCount >= 1 and is_instance_valid(newProjec):
			newProjec.testProp = false
			var luhT = newProjec.create_tween()
			luhT.tween_property(newProjec, 'modulate', Color(0, 0, 0, 0), 0.25)
			luhT.tween_callback(newProjec.queue_free)
	isUsingBeam = false
			

func downwardsBeam():
	for i in 20:
		for y in 45:
			projectyDirected(Vector2(randf() * 20 - 10, 10))
			await get_tree().create_timer(0.005).timeout
		await get_tree().create_timer(0.01).timeout
		
func daBom():
	anchored = true
	var myTween1 = create_tween()
	myTween1.tween_property(self, 'position', Vector2(8820, -4062), 3)
	
	await myTween1.finished
	
	var newProjec = await projectile(null, true, true)
	newProjec.scale *= 25
	
	newProjec.get_node('HeatSeeker').body_shape_entered.connect(func(rid: RID, body: Node2D, bodyShapeIndex: int, localShapeIndex: int):
		if body.name == 'TileMap':
			var tile = body.get_coords_for_body_rid(rid)
			if tile:
				body.set_cell(0, tile)
	)
	for i in 300:
		await get_tree().create_timer(0.01).timeout
		newProjec.position += Vector2(0, 20)
	newProjec.queue_free()
	anchored = false

#zaigzagu
func storeInitPositions():
	for i in get_children():
		storeInitPos[i.name] = i.position

func partOffset(offset):
	if not storeInitPos.keys().has('LegSprite'): return null
	
	for i in get_children():
		i.position = storeInitPos[i.name] + offset

func pathContainerTranslate(v : Vector2):
	return pathContainer.position + v
	
var anchored = false

var Loffset = Vector2(0, 0)
var invertX = 2
var invertY = 0

var Poffset = Vector2(0, 0)
var pInvertX = 1

var walkSpeed = 300

func _physics_process(delta):
	if not awake or not get_parent(): return null
	
	if (get_owner().get_parent().get_node('Player').position - position).length() > 4000:
		return null
	
	velocity = (get_owner().get_parent().get_node('Player').position - position).normalized() * walkSpeed
	if isUsingBeam == true and velocity.y > 0:
		velocity *= Vector2(1, -1)
	
	Loffset += Vector2(invertX, invertY)
	partOffset(Loffset)
	
	#to avoid the 9000 triggers per second check position AND invert(axis). genius!!!!!!!!!!
	if (Loffset.x <= -50 and invertX < 0) or (Loffset.x >= 50 and invertX > 0):
		invertX *= -1
		
	if (Loffset.y <= 150 and invertY < 0) or (Loffset.y >= -150 and invertY > 0):
		invertY *= -1
	
	if not anchored:
		move_and_slide()
	
var maxProjectileDebounce = 4

func _ready():
	awake = false
	await get_tree().create_timer(0.5).timeout
	awake = true
	
	storeInitPositions()
	while get_tree() and get_owner() != null:
		await get_tree().create_timer(randf() * maxProjectileDebounce).timeout
		
		if get_owner().get_parent() == null: return null
		if anchored: continue
		projectile(get_owner().get_parent().get_node('Player'))
	queue_free()

#health
var healthDebounce = false
func change_health(change):
	if not healthDebounce:
		healthDebounce = true
		health -= change
		
		if health == 8:
			invertX *= 1.2
			walkSpeed *= 1.5
			maxProjectileDebounce *= 0.8
			downwardsBeam()
		elif health == 5:
			invertX *= 2
			walkSpeed *= 2.25
			maxProjectileDebounce *= 0.5
		elif health == 2:
			invertX *= 4
			walkSpeed *= 2
			maxProjectileDebounce *= 0.3
			daBom()
		
		if health <= 0:
			get_parent().get_parent().get_parent().gameWin.emit()
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

'''
ok planning the next feature!!!!!!!!!! yay

feature: i give up lmfaooooooooooooooooooooo
'''
