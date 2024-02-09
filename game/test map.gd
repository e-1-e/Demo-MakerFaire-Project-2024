extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var tutorialEnabled = true
var tutorial = []

func wake():
	await get_tree().create_timer(0.1).timeout
	
	if tutorialEnabled:
		pass
	
	await get_tree().create_timer(0.1).timeout
	get_parent().game_time()
	$DemoBoss.awake = true
