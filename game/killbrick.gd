extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print('VAMP ANThEM!')
	print("VV" + body.name + "3")
	
	if body.name == 'Player':
		print('yeuh!')
		body.changeHealth(9999999, 's p i k e')
		body.death.emit()
