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
	print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhh !!!!!!!!! ')
	print(newProject.position)
	newProject.get_node('HeatSeeker').body_entered.connect(func (x):
		#explosion whatever
		if x.name == 'Player':
			newProject.queue_free()
			x.changeHealth(1)
	)
	
	print('SKRRT')
	if target != null and newProject != null and self != null:
		print("YOU CAN GET WHATCHU WANT")
		while newProject.get_parent() == get_parent():
			newProject.position += (target.position - newProject.position).normalized() * 5
			
			await get_tree().create_timer(0.001).timeout
			print('CHOSPTICK CAME WITH A LARGE LO MEIN')

func _physics_process(delta):
	if not awake: return null
	

	move_and_slide()

func _ready():
	await get_tree().create_timer(0.5).timeout
	print(get_owner().get_parent())
	print('I REMEMBER SHE SAID F ME NOW THAT GIRL WANNA')
	projectile(get_owner().get_parent().get_node('Player'))
