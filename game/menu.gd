extends Node
var currentDoor = null

@onready
var menu = $Menu

@export var TutorialLevel : PackedScene
@export var GameLevel : PackedScene
@export var inMenu = true

var doorDebounce = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print('NEVA TOO MUCH!!!! NEVA TOO MUCH!!!! NEVA TOO MUCH!!!! NEVA TOO MUCH!!!')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up") and inMenu:
		print('yeah yeah yeah eyah')
		print(currentDoor)
		if currentDoor == 'tutorial' and not doorDebounce:
			doorDebounce = true
			await get_tree().create_timer(1).timeout
			var newScee = TutorialLevel.instantiate()
			remove_child(menu)
			add_child(newScee)
			$Player.position = newScee.get_node('PlayerSpawn').position
			
			newScee.wake()
			
			newScee.get_node('gameAudio1').play()
			
			inMenu = false
			doorDebounce = false
			
		if currentDoor == 'game' and not doorDebounce:
			doorDebounce = true
			await get_tree().create_timer(1).timeout
			var newScee = GameLevel.instantiate()
			remove_child(menu)
			add_child(newScee)
			$Player.position = newScee.get_node('PlayerSpawn').position
			
			newScee.get_node('gameAudio1').play() #WILL CHANGE LATER. LMK WHEN U WANNA ADD AUDIO.
			
			inMenu = false
			doorDebounce = false
			
			



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
		get_tree().call_group('enemy', 'queue_free')
		get_tree().call_group('audio', 'queue_free')
		remove_child($GameMapNode)
		add_child(menu)
		inMenu = true
