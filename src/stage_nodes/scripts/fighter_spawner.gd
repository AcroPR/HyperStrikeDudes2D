class_name FighterSpawner
extends Node2D

const EXPLOSION = preload("uid://bk1r5yy5s2t6m")

@export var stage: Stage
@export_range(-1,3) var playerID: int = -1
@export var facingRight: bool = true

func _on_dead_fighter(_playerID: int):
	for fighter in get_children():
		if fighter is not Fighter: continue
		if fighter.playerID == _playerID:
			stage.stageCamera._remove_target(fighter)
			MatchGlobal.playerLives[_playerID] -= 1
			fighter.fighterIcon._set_lives(_playerID)
			_set_explosion(fighter)
			fighter.queue_free()
	if MatchGlobal.playerLives[_playerID] > 0:
		stage.call_deferred("_spawn_dead_player", _playerID)
	else:
		stage.call_deferred("_check_active_players")

func _set_explosion(fighter: Fighter) -> void:
	var explosionInstance = EXPLOSION.instantiate()
	explosionInstance.global_position = fighter.global_position
	explosionInstance.xVelocity = fighter.global_position.x
	explosionInstance.yVelocity = fighter.global_position.y
	add_child(explosionInstance)

func _spawn_fighter(_playerID: int = 0) -> Fighter:
	var filePath: String = "res://src/fighters/"+MatchGlobal.players[_playerID].Fighter+"/fighter.tscn"
	var fighter = load(filePath)
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
	$Sprite2D.queue_free()
