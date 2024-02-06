extends Node
var currentDoor = null

@onready
var menu = $Menu

@export var TutorialLevel : PackedScene
@export var GameLevel : PackedScene
@export var inMenu = true

var timeSnapshot = 0


var doorDebounce = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print('NEVA TOO MUCH!!!! NEVA TOO MUCH!!!! NEVA TOO MUCH!!!! NEVA TOO MUCH!!!')
	
func start_game():
	remove_child(menu)
	$Player.freezeCam = false
	$GuiContainer.visible = true
	timeSnapshot = Time.get_ticks_msec()
	
	print("THIS THAT UZI MIXTAPEEEEEEEEEEEEE")
	
	var altTimer = 300
	while $GuiContainer.visible:
		await get_tree().create_timer(1).timeout
		$GuiContainer/TimeLabel.text = "%d:%02d" % [1, 3]
		altTimer -= 1
		'''
		[time in mins]:[time in secs]
		[seconds/60]:[seconds%60]
		
		("%d:%05d" % (seconds//60, seconds%60))[3:]
		("%d:%02d" % (seconds//60, seconds))
		
		("%d:%02d" % (altTimer//60, altTimer%60))
		'''

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up") and inMenu:
		print('yeah yeah yeah eyah')
		print(currentDoor)
		if currentDoor == 'tutorial' and not doorDebounce:
			doorDebounce = true
			await get_tree().create_timer(1).timeout
			var newScee = TutorialLevel.instantiate()
			add_child(newScee)
			$Player.position = newScee.get_node('PlayerSpawn').position
			start_game()
			
			newScee.wake()
			
			newScee.get_node('gameAudio1').play()
			
			inMenu = false
			doorDebounce = false
			
		if currentDoor == 'game' and not doorDebounce:
			doorDebounce = true
			await get_tree().create_timer(1).timeout
			var newScee = GameLevel.instantiate()
			add_child(newScee)
			$Player.position = newScee.get_node('PlayerSpawn').position
			start_game()
			
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
		$GuiContainer.visible = false
		add_child(menu)
		move_child($LoseScreen, -1)
		$LoseScreen.visible = true
		$LoseScreen/TimeLabel.text = '[center]You lasted ' + str((Time.get_ticks_msec() - timeSnapshot)/1000) + ' seconds.'
		$LoseScreen/DeathCause.text = '[center]Cause of death: ' + str($Player.lastDmgReason)
		
		$Player.anchored = true
		$Player.freezeCam = true
		$Camera2D.position = Vector2(960, 540)
		$LoseScreen.position = Vector2(0, 0)

		#$LoseScreen/ReturnBtn.grab_focus()
		await $LoseScreen/ReturnBtn.pressed
		$Player.anchored = false
		$LoseScreen.visible = false
		inMenu = true
