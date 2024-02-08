extends Control

@export var testProp = false

#Only use if you just want the projectile travelling a certain direction. lmao
func constantTravel(direction):
	self.get_node('HeatSeeker').body_entered.connect(func (x):
		#explosion whatever
		if x.name == 'Player' and self.testProp:
			self.testProp = false
			x.changeHealth(1, 'hit by projectile 💀')
			x.impulse(150, self.position.x < x.position.x, 10)
			
			var luhT = self.create_tween()
			luhT.tween_property(self, 'modulate', Color(0, 0, 0, 0), 0.25)
			luhT.tween_callback(self.queue_free)
		elif x.name == 'TileMap':
			self.testProp = false
			var luhT = self.create_tween()
			luhT.tween_property(self, 'modulate', Color(0, 0, 0, 0), 1)
			luhT.tween_callback(self.queue_free)
	)
	
	if self != null and get_tree() and self.testProp == true:
		print("YOU CAN GET WHATCHU WANT")
		while self:
			self.position += direction
			
			if not get_tree(): return null
			if not self.testProp: return null
			await get_tree().create_timer(0.001).timeout
			print('CHOSPTICK CAME WITH A LARGE LO MEIN')
			if not is_instance_valid(self): return null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
