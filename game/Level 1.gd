extends Node

@export var projecty : PackedScene

var projectileBlocks = []
func wake():
	#Detect up projectile tiles using tile at atlas coord (2, 3).
	for i in $TileMap.get_used_cells(0):
		if $TileMap.get_cell_atlas_coords(0, i) == Vector2i(2, 3):
			projectileBlocks.push_front(i)
	print(projectileBlocks)
	
	#Next, add the functionality for the projectile tiles.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
