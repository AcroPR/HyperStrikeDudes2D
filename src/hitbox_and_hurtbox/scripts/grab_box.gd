class_name GrabBox
extends Area2D

@export var parent: Fighter

@onready var grabMarker = $GrabMarker

var grabbedFighter: Fighter

func _monitor_off() -> bool:
	return !monitoring and !monitorable

func _in_pummel() -> bool:
	return parent.stateMachine._get_current_state_name() == "Pummel"

func _process(_delta: float) -> void:
	if parent.stateMachine._get_current_state_name() != "Grab" and !_monitor_off():
		monitoring = false
		monitorable = false
	if grabbedFighter == null and _in_pummel():
		parent.stateMachine.change_state(parent.idleState)
