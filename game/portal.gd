extends Node2D

@export var destination : Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_detect_body_entered(body):
	if body in get_tree().get_nodes_in_group('teleportable') and destination:
		body.position = destination.position
