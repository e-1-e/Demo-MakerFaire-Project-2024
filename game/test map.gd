extends Node

@export var boss : Node2D
@export var projecty : PackedScene

var gameRadio = [
	'res://assets/audio/Level 1/simple.ogg'
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var tutorialEnabled = true
var tutorial = [
	['Welcome, player.'],
	['This is the tutorial for STERF!'],
	['In this game, your objective is to defeat the boss.'],
	['To begin,[0.4] press A and D to move around.'],
	['Press SPACE to jump.'],
	['Finally,[0.4] press SPACE to jump off walls while touching a wall.'],
	['Around the map, there are several things to find.'],
	['You may find important tools and potions (currently not available)[0.4], but you may also find other enemies around,[0.1] or you may even find the boss room!'],
	['If you do find an enemy,[0.4] jump on their head to hurt them.'],
	['Alright player,[0.4] good luck!']
]

var uSkip = false

var projectileBlocks = []

func wake():
	await get_tree().create_timer(0.1).timeout
	
	
	
	if tutorialEnabled and get_parent().get_node('GUI').get_node('GuiContainer'):
		get_parent().get_node('Player').anchored = true
		get_parent().get_node('GUI').get_node('GuiContainer').eHide(true)
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('HeartGrid').visible = false
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('TimeLabel').visible = false
		
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('Skipper2').pressed.connect(func():
			print('Different Dayyyyyy')
			uSkip = true
		, 4)
		
		
		
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('DialogueBox').get_node('Skipper').pressed.connect(func():
			if not get_parent():
				return
			get_parent().get_node('GUI').get_node('GuiContainer').skip = true
		)
		
		for i in tutorial:
			print(uSkip)
			if uSkip == true:
				print('U WAS JUS ASKIN FOR SUM CHANGE NOW U CHANGED')
				uSkip = false
				break
				
			get_parent().get_node('GUI').get_node('GuiContainer').speak('weirdo', i[0])
			await get_parent().get_node('GUI').get_node('GuiContainer').doneTalking
			await get_tree().create_timer(1.5).timeout
			continue
		get_parent().get_node('GUI').get_node('GuiContainer').eHide()
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('HeartGrid').visible = true
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('TimeLabel').visible = true
		get_parent().get_node('Player').anchored = false
	
	get_parent().get_node('GUI').get_node('GuiContainer').eHide()
	await get_tree().create_timer(0.1).timeout
	get_parent().game_time()
	boss.awake = true
	
	for i in $TileMap.get_used_cells(0):
		if $TileMap.get_cell_atlas_coords(0, i) == Vector2i(2, 3) and $TileMap.get_cell_source_id(0, i) == 1:
			projectileBlocks.push_front(i)
	
	while true:
		for i in projectileBlocks:
			var newProject = projecty.instantiate()
			add_child(newProject)
			
			newProject.position = $TileMap.to_global($TileMap.map_to_local(i)) + Vector2(0, 70)
			newProject.testProp = true
			newProject.constantTravel(Vector2(0, 10))
		if not get_tree(): return null
		await get_tree().create_timer(1).timeout


func _on_game_audio_1_ready():
	while true:
		for i in gameRadio:
			$gameAudio1.stream = AudioStreamOggVorbis.load_from_file(i)
			$gameAudio1.play()
			await $gameAudio1.finished
