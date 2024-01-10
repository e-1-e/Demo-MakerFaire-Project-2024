extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print('fuc')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_tutorial_door_body_entered(body):
	print(body)
	$Player/ColorRect.color = Color(0, 1, 1, 1)


func _on_game_door_body_entered(body):
	print(body)
	$Player/ColorRect.color = Color(1, 1, 0, 1)


func _on_game_door_body_exited(body):
	if body == $Player:
		$Player/ColorRect.color = Color(0.949, 0, 0.467, 1)
