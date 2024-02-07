extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#speak('YEAH', 'went to the bank today they said ya LOADED')
	pass

var isTalking = false
var skip = false
func speak(talker : String, talk : String):
	if isTalking: return
	isTalking = true
	eHide()
	
	$SpeakerBox/TextLabel.text = '[center]' + talker
	
	$DialogueBox/TextLabel.text = ''
	for i in talk:
		await get_tree().create_timer(0.03).timeout
		$DialogueBox/TextLabel.text += i
		
		if skip:
			skip = false
			break
	$DialogueBox/TextLabel.text = talk
	isTalking = false
	
func eHide(mode = false):
	$DialogueBox.visible = mode
	$SpeakerBox.visible = mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
