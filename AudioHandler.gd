extends Node

var chaos = 1
var wonder = -2
var decay = 3

var nextPlay = 20
var randomness = 0
var counter = 0

var masterPitch = 1

var fifths = [masterPitch * 0.66666, masterPitch, masterPitch * 1.5, masterPitch * 1.125, masterPitch * 1.6875]
var fourths = [masterPitch * 0.75, masterPitch, masterPitch * 1.3333, masterPitch * 1.7777, masterPitch * 1.18518]
#1.265625, 1.8984375
var randPitchSelection
var newPitch = 0
var volumeWonder = -14

var growthCycle = true

var minusThree = load("res://audio/minusThree.wav")
var minusTwo = load("res://audio/minusTwo.wav")
var minusOne = load("res://audio/minusOne.wav")
var neutral = load("res://audio/neutral.wav")
var plusOne = load("res://audio/plusOne.wav")
var plusTwo = load("res://audio/plusTwo.wav")
var plusThree = load("res://audio/plusThree.wav")

var ambientSounds = [minusThree, minusTwo, minusOne, neutral, plusOne, plusTwo, plusThree]
var ambientSelector = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	counter = 0;
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if (growthCycle):
		_orderChaos() # increases or decreases randomness of note spacing and adds lo-fi distortion
		_traditionWonder() # manipulates audio effects
		counter = counter + 1
		if (counter > nextPlay + randomness): #defines the space between notes
			_playNextMelodyNote()
	
	if (!growthCycle):
		counter = 0
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _orderChaos():
	var normalizedChaos = (chaos + 3.00) / 6.00
	var topRange = (chaos + 3) * 1200
	var bottomRange = -(chaos + 3) * 4
	randomness = rand_range(bottomRange, topRange) #notes will be more or less randomly spaced based on chaos/order
	#AudioServer.get_bus_effect(1,3).set_pre_gain(normalizedChaos * 0.5)
	

func _traditionWonder():
	var normalizedWonder = (wonder + 3.00) / 6.00
	#CHORUS (bus 1 effect 0)
	AudioServer.get_bus_effect(1,0).set_wet(normalizedWonder * 0.5)
	#REVERB (bus 1 effect 3)
	AudioServer.get_bus_effect(1,3).set_room_size(normalizedWonder)
	AudioServer.get_bus_effect(1,3).set_damping(1-normalizedWonder)
	
	
	
func _growthDecay():
	var normalizedDecay = (decay + 3.00) / 6.00
	
	#NOTE RULES
	if (decay == -3):
		randPitchSelection = round(rand_range(0, fourths.size()-1))
	if (decay == -2):
		randPitchSelection = round(rand_range(0, 3))
	if (decay == -1):
		randPitchSelection = round(rand_range(0, 1))
	if (decay == 0):
		randPitchSelection = 0
	if (decay == 1):
		randPitchSelection = round(rand_range(0, 1))
	if (decay == 2):
		randPitchSelection = round(rand_range(0, 3))

	if (decay == 3):
		randPitchSelection = round(rand_range(0, fifths.size()-1))

	
	if (decay >=0):
		newPitch = fifths[randPitchSelection]
	if (decay < 0):
		newPitch = fourths[randPitchSelection]
		
	#PITCH SHIFT (bus 1 effect 1)
	AudioServer.get_bus_effect(2,0).pitch_scale = newPitch
	
	#DISTORTION (bus 1 effect 2)
	AudioServer.get_bus_effect(1,2).set_drive(1-normalizedDecay)
	
	pass
	
func _playNextMelodyNote():
	volumeWonder = rand_range((wonder-26), (wonder - 16))
	get_node("cellSonification").set_volume_db(volumeWonder)
	_growthDecay() # decides which note array to choose from — growth moves in augmentation (5ths), decay moves in diminuition (4ths)
	get_node("cellSonification").play(0)
	counter = 0
	
func _resetPitch():
	fifths = [masterPitch * 0.66666, masterPitch, masterPitch * 1.5, masterPitch * 1.125, masterPitch * 1.6875]
	fourths = [masterPitch * 0.75, masterPitch, masterPitch * 1.3333, masterPitch * 1.7777, masterPitch * 1.18518]
	get_node("ambience").set_pitch_scale(masterPitch)

func _playAmbience():
	
	ambientSelector = decay + 3
	get_node("ambience").stream = ambientSounds[ambientSelector]
	get_node("ambience").play(0)
	