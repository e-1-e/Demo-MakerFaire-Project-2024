extends Node

@export var boss : Node2D

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
	['To begin,[0.4] press WASD to move around.'],
	['Press SPACE to jump.'],
	['Finally,[0.4] press SPACE to jump off walls while touching a wall.'],
	['Around the map, there are several things to find.'],
	['You may find a treasure chest (filled with weapons)[0.4], but you may also find other enemies around,[0.1] or you may even find the boss room!'],
	['If you do find an enemy,[0.4] jump on their head to hurt them.'],
	['Alright player,[0.4] good luck!']
]

func wake():
	await get_tree().create_timer(0.1).timeout
	
	if tutorialEnabled and get_parent().get_node('GUI').get_node('GuiContainer'):
		get_parent().get_node('Player').anchored = true
		get_parent().get_node('GUI').get_node('GuiContainer').eHide(true)
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('HeartGrid').visible = false
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('TimeLabel').visible = false
		
		get_parent().get_node('GUI').get_node('GuiContainer').get_node('DialogueBox').get_node('Skipper').pressed.connect(func():
			if not get_parent():
				return
			get_parent().get_node('GUI').get_node('GuiContainer').skip = true
		)
		
		for i in tutorial:
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
