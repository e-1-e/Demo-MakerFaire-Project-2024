extends Node

@export var projecty : PackedScene

var projectileBlocks = []
var gameRadio = [
	'res://assets/audio/Level 1/simple.ogg'
]

func wake():
	#Detect the TileMap tiles using tile at atlas coord (2, 3).
	for i in $TileMap.get_used_cells(0):
		if $TileMap.get_cell_atlas_coords(0, i) == Vector2i(2, 3):
			projectileBlocks.push_front(i)
	print(projectileBlocks)
	
	#Next, add the functionality for the projectile tiles.
	while true:
		for i in projectileBlocks:
			var newProject = projecty.instantiate()
			add_child(newProject)
			
			newProject.position = $TileMap.to_global($TileMap.map_to_local(i)) + Vector2(0, 70)
			newProject.testProp = true
			newProject.constantTravel(Vector2(0, 10))
		if not get_tree(): return null
		await get_tree().create_timer(1).timeout
		

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	get_parent().game_time()
	while true:
		for i in gameRadio:
			$gameAudio1.stream = AudioStreamOggVorbis.load_from_file(i)
			$gameAudio1.play()
			await $gameAudio1.finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_audio_1_ready():
	pass # Replace with function body.
