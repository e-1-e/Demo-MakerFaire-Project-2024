extends CharacterBody2D

@export var projecty : PackedScene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var awake = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	newProject.position = position + $LeftHandMark.position
	newProject.testProp = true
	print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhh !!!!!!!!! ')
	print(newProject.position)
	newProject.get_node('HeatSeeker').body_entered.connect(func (x):
		#explosion whatever
		if x.name == 'Player' and newProject.testProp:
			newProject.testProp = false
			x.changeHealth(1)
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

func _physics_process(delta):
	if not awake: return null
	

	move_and_slide()

func _ready():
	await get_tree().create_timer(0.5).timeout
	
	while get_tree() and get_owner() != null:
		await get_tree().create_timer(5).timeout
		
		if get_owner().get_parent() == null: return null
		projectile(get_owner().get_parent().get_node('Player'))
	queue_free()
