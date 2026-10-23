class_name InputComponent
extends Node

const BUFFER_FRAMES := 6

var controllerID: int = 0

var inputBuffer = {
	"move_up": 0,
	"move_down": 0,
	"move_left": 0,
	"move_right": 0,
	"attack": 0,
	"special": 0,
	"heavy": 0,
	"attack_up": 0,
	"attack_down": 0,
	"attack_left": 0,
	"attack_right": 0,
	"jump": 0,
	"block": 0,
	"grab": 0,
	"emote": 0,
	"walk": 0
}

func _physics_process(_delta: float) -> void:
	for action in inputBuffer.keys():
		var inputAction = action+"_"+str(controllerID)
		if Input.is_action_just_pressed(inputAction):
			inputBuffer[action] = BUFFER_FRAMES

		if inputBuffer[action] > 0:
			inputBuffer[action] -= 1

func _just_pressed(action: String) -> bool:
	return inputBuffer[action] > 0

func _pressed(action: String) -> bool:
	var inputAction = action+"_"+str(controllerID)
	return Input.is_action_pressed(inputAction)

func _just_released(action: String) -> bool:
	var inputAction = action+"_"+str(controllerID)
	return Input.is_action_just_released(inputAction)

func _get_strength(action: String) -> float:
	var inputAction = action+"_"+str(controllerID)
	return Input.get_action_strength(inputAction)
