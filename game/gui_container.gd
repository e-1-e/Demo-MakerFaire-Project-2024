'''
-------------------------------------------HOW TO USE TYPEWRITER--------------------------------------

Use the 'speak' function to begin typewriter.

The 'speak' function accepts two parameters:
	talker : a string containing the speaker's name
	talk : a string containing the speaker's message

-------------------------------------------HOW TO FORMAT THE MSG--------------------------------------

There really aren't any formatting requirements other than...
	- Use brackets to enter a pause, and put a number in between to define how long the pause will be (in seconds)
		* For example, "I'm gonna pause now. [1]Done."
'''

extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#speak('YEAH', 'went to the bank today they said ya [0.45]LOADED')
	pass

var isTalking = false
var skip = false

signal doneTalking

func speak(talker : String, talk : String):
	if isTalking: return
	get_parent().move_child(self, -1)
	isTalking = true
	eHide(true)
	
	var checker = RegEx.new()
	checker.compile(r'\[[0-9]+\.?[0-9]*\]') #RegExps are suprisingly easy to make lol
	
	$SpeakerBox/TextLabel.text = '[center]' + talker
	
	$DialogueBox/TextLabel.text = ''
	
	var iteration = 0
	var skipTo = -1
	for i in talk:
		if skipTo != -1 and iteration < skipTo:
			iteration += 1
			continue
			
		if i == '[':
			var newMatch = checker.search(talk, iteration)
			if newMatch:
				await get_tree().create_timer(float(talk.substr(newMatch.get_start() + 1, len(newMatch.get_string()) - 1))).timeout
				skipTo = newMatch.get_end() - 1
				continue
				
		await get_tree().create_timer(0.03).timeout
		$DialogueBox/TextLabel.text += i
		
		if skip:
			skip = false
			break
		
		iteration += 1
		skipTo = -1
		
	$DialogueBox/TextLabel.text = checker.sub(talk, '', true)
	isTalking = false
	doneTalking.emit()
	return
	
func eHide(mode = false):
	$DialogueBox.visible = mode
	$SpeakerBox.visible = mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
