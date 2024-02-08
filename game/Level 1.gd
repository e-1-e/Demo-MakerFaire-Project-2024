extends Node

@export var projecty : PackedScene

var projectileBlocks = []
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
		await get_tree().create_timer(5).timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
