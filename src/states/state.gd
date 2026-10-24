class_name State
extends Node

# Parent Node
var parent: Fighter
var model: Node2D
var inputComponent: InputComponent

var frames = 0

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
