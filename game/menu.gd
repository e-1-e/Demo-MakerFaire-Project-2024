extends Node
var currentDoor = null

signal gameWin

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
	
func game_time():
	$GUI/GuiContainer/TimeLabel.text = "[center]5:00"
	print("THIS THAT UZI MIXTAPEEEEEEEEEEEEE")
	
	var altTimer = 300
	while $GUI/GuiContainer.visible:
		await get_tree().create_timer(1).timeout
		altTimer -= 1
		$GUI/GuiContainer/TimeLabel.text = "[center]" + "%d:%02d" % [altTimer/60, altTimer%60]
		if altTimer <= 0:
			$Player.changeHealth(999, 'time\'s up!')
		'''
		[time in mins]:[time in secs]
		[seconds/60]:[seconds%60]
		
		("%d:%05d" % (seconds//60, seconds%60))[3:]
		("%d:%02d" % (seconds//60, seconds))
		
		("%d:%02d" % (altTimer//60, altTimer%60))
		'''
	
func start_game():
	remove_child(menu)
	$Player.freezeCam = false
	$GUI/GuiContainer.visible = true
	timeSnapshot = Time.get_ticks_msec()
	$GUI/GuiContainer/TimeLabel.text = "[center]5:00"
	


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
			
			newScee.wake()
			
			newScee.get_node('gameAudio1').play() #WILL CHANGE LATER. LMK WHEN U WANNA ADD AUDIO.
			
			inMenu = false
			doorDebounce = false
			
			



func _on_tutorial_door_body_entered(body):
	currentDoor = 'tutorial'
	$Player/ColorRect.color = Color(0, 1, 1, 1)


func _on_game_door_body_entered(body):
	currentDoor = 'tutorial'
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
		$GUI/GuiContainer.visible = false
		add_child(menu)
		move_child($GUI/LoseScreen, -1)
		$GUI/LoseScreen.visible = true
		$GUI/LoseScreen/RichTextLabel.text = '[center]death :('
		$GUI/LoseScreen/RichTextLabel.remove_theme_color_override('default_color')
		$GUI/LoseScreen/RichTextLabel.add_theme_color_override('default_color', Color('#ff4545'))
		
		$GUI/LoseScreen/TimeLabel.text = '[center]You lasted ' + str((Time.get_ticks_msec() - timeSnapshot)/1000) + ' seconds.'
		$GUI/LoseScreen/TimeLabel.remove_theme_color_override('default_color')
		$GUI/LoseScreen/TimeLabel.add_theme_color_override('default_color', Color('#ff4545'))
		
		$GUI/LoseScreen/DeathCause.text = '[center]Cause of death: ' + str($Player.lastDmgReason)
		
		$Player.anchored = true
		$Player.freezeCam = true
		$Camera2D.position = Vector2(960, 540)
		$GUI/LoseScreen.position = Vector2(0, 0)

		#$GUI/LoseScreen/ReturnBtn.grab_focus()
		await $GUI/LoseScreen/ReturnBtn.pressed
		$Player.anchored = false
		$GUI/LoseScreen.visible = false
		inMenu = true


func _on_game_win():
	if ($GameMapNode):
		get_tree().call_group('enemy', 'queue_free')
		get_tree().call_group('audio', 'queue_free')
		remove_child($GameMapNode)
		$GUI/GuiContainer.visible = false
		add_child(menu)
		move_child($GUI/LoseScreen, -1)
		$GUI/LoseScreen.visible = true
		$GUI/LoseScreen/RichTextLabel.text = '[center]game over!'
		$GUI/LoseScreen/RichTextLabel.remove_theme_color_override('default_color')
		$GUI/LoseScreen/RichTextLabel.add_theme_color_override('default_color', Color('#00FF00'))
		
		$GUI/LoseScreen/TimeLabel.text = '[center]You spent ' + str((Time.get_ticks_msec() - timeSnapshot)/1000) + ' seconds.'
		$GUI/LoseScreen/TimeLabel.remove_theme_color_override('default_color')
		$GUI/LoseScreen/TimeLabel.add_theme_color_override('default_color', Color('#00FF00'))
		
		$GUI/LoseScreen/DeathCause.text = ''
		
		$Player.anchored = true
		$Player.freezeCam = true
		$Camera2D.position = Vector2(960, 540)
		$GUI/LoseScreen.position = Vector2(0, 0)

		#$GUI/LoseScreen/ReturnBtn.grab_focus()
		await $GUI/LoseScreen/ReturnBtn.pressed
		$Player.anchored = false
		$GUI/LoseScreen.visible = false
		inMenu = true
