class_name Ledge
extends Area2D

@export var facingRight: bool = true

var onLedge: Fighter = null

func _set_ledge_grab(fighter: Fighter) -> void:
	if onLedge != null and fighter != null:
		onLedge._off_ledge()
	onLedge = fighter
