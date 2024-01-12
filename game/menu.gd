extends Node
var currentDoor = null

@onready
var menu = $Menu

@export var doodoo : PackedScene
@export var inMenu = true

# Called when the node enters the scene tree for the first time.
func _ready():
	print('NEVA TOO MUCH!!!! NEVA TOO MUCH!!!! NEVA TOO MUCH!!!! NEVA TOO MUCH!!!')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up") and inMenu:
		print('yeah yeah yeah eyah')
		print(currentDoor)
		if currentDoor == 'tutorial':
			await get_tree().create_timer(1).timeout
			var newScee = doodoo.instantiate()
			remove_child(menu)
			add_child(newScee)
			$Player.position = Vector2(60, 10)
			
			inMenu = false
			
			



func _on_tutorial_door_body_entered(body):
	currentDoor = 'tutorial'
	$Player/ColorRect.color = Color(0, 1, 1, 1)


func _on_game_door_body_entered(body):
	currentDoor = 'game'
	$Player/ColorRect.color = Color(1, 1, 0, 1)


func _on_game_door_body_exited(body):
	if body == $Player:
		currentDoor = ''
		$Player/ColorRect.color = Color(0.949, 0, 0.467, 1)


func _on_player_death():
	if ($GameMapNode):
		remove_child($GameMapNode)
		add_child(menu)
		inMenu = true
