class_name FighterSpawner
extends Node2D

@export var stage: Stage
@export_range(-1,3) var playerID: int = -1

func _on_dead_fighter(_playerID: int):
	MatchGlobal.playerLives[_playerID] -= 1
	stage.call_deferred("_spawn_dead_player", _playerID)

func _spawn_fighter(_playerID: int = 0):
	var fighter = preload("res://src/fighters/0base/fighter.tscn")
	var fighterInstance: Fighter = fighter.instantiate()
	fighterInstance.dead_fighter.connect(_on_dead_fighter)
	if playerID == -1:
		fighterInstance.playerID = _playerID
	else:
		fighterInstance.playerID = playerID
	add_child(fighterInstance)

func _ready() -> void:
	$Sprite2D.visible = false
