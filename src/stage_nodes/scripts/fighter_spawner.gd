class_name FighterSpawner
extends Node2D

@export var stage: Stage
@export_range(-1,3) var playerID: int = -1
@export var facingRight: bool = true

func _on_dead_fighter(_playerID: int):
	for fighter in get_children():
		if fighter is Fighter: 
			stage.stageCamera._remove_target(fighter)
			MatchGlobal.playerLives[_playerID] -= 1
			fighter.fighterIcon._set_lives(_playerID)
			fighter.queue_free()
	stage.call_deferred("_spawn_dead_player", _playerID)

func _spawn_fighter(_playerID: int = 0) -> Fighter:
	var fighter = preload("res://src/fighters/0base/fighter.tscn")
	var fighterInstance: Fighter = fighter.instantiate()
	fighterInstance.dead_fighter.connect(_on_dead_fighter)
	if playerID == -1:
		fighterInstance.playerID = _playerID
	else:
		fighterInstance.playerID = playerID
	fighterInstance.facingRight = facingRight
	stage.stageCamera._add_target(fighterInstance)
	add_child(fighterInstance)
	return fighterInstance

func _ready() -> void:
	$Sprite2D.visible = false
