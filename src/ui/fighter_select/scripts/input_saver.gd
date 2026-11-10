class_name InputSaver
extends Node

func _load_new_inputs(controllerID: int) -> void:
	match controllerID:
		0:
			Controls._add_actions(Controls.playOneInputsA, 0)
			Controls._add_actions(Controls.playOneInputsB, 0)
		1:
			Controls._add_actions(Controls.playTwoInputsA, 0)
			Controls._add_actions(Controls.playTwoInputsB, 0)
		2:
			Controls._add_actions(Controls.playThreeInputsA, 0)
			Controls._add_actions(Controls.playThreeInputsB, 0)
		3:
			Controls._add_actions(Controls.playFourInputsA, 0)
			Controls._add_actions(Controls.playFourInputsB, 0)
		_:
			pass

func _set_a_input(event: InputEvent, controllerID: int, actionName: String) -> void:
	match controllerID:
		0:
			if event is InputEventJoypadButton:
				Controls.playOneInputsA[actionName] = [false, event.button_index]
			else:
				Controls.playOneInputsA[actionName] = [true, event.axis, 1.0]
		1:
			if event is InputEventJoypadButton:
				Controls.playTwoInputsA[actionName] = [false, event.button_index]
			else:
				Controls.playTwoInputsA[actionName] = [true, event.axis, 1.0]
		2:
			if event is InputEventJoypadButton:
				Controls.playThreeInputsA[actionName] = [false, event.button_index]
			else:
				Controls.playThreeInputsA[actionName] = [true, event.axis, 1.0]
		3:
			if event is InputEventJoypadButton:
				Controls.playFourInputsA[actionName] = [false, event.button_index]
			else:
				Controls.playFourInputsA[actionName] = [true, event.axis, 1.0]
		_:
			pass

func _set_b_input(event: InputEvent, controllerID: int, actionName: String) -> void:
	match controllerID:
		0:
			if event is InputEventJoypadButton:
				Controls.playOneInputsB[actionName] = [false, event.button_index]
			else:
				Controls.playOneInputsB[actionName] = [true, event.axis, 1.0]
		1:
			if event is InputEventJoypadButton:
				Controls.playTwoInputsB[actionName] = [false, event.button_index]
			else:
				Controls.playTwoInputsB[actionName] = [true, event.axis, 1.0]
		2:
			if event is InputEventJoypadButton:
				Controls.playThreeInputsB[actionName] = [false, event.button_index]
			else:
				Controls.playThreeInputsB[actionName] = [true, event.axis, 1.0]
		3:
			if event is InputEventJoypadButton:
				Controls.playFourInputsB[actionName] = [false, event.button_index]
			else:
				Controls.playFourInputsB[actionName] = [true, event.axis, 1.0]
		_:
			pass

func _set_input(event: InputEvent, controllerID: int, actionName: String, isAVersion: bool) -> void:
	match isAVersion:
		true:
			_set_a_input(event, controllerID, actionName)
		false:
			_set_b_input(event, controllerID, actionName)
	Controls._save_input(controllerID)
	var inputAction = actionName + "_" + str(controllerID)
	InputMap.action_erase_events(inputAction)
	_load_new_inputs(controllerID)
