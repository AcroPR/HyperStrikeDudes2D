class_name FighterSpawner
extends Node2D

const EXPLOSION = preload("uid://bk1r5yy5s2t6m")

@export var stage: Stage
@export var neutralFighterSpawner: FighterSpawner
@export_range(-1,3) var playerID: int = -1
@export var facingRight: bool = true

func _on_dead_fighter(_playerID: int):
	for fighter in get_children():
		if fighter is not Fighter: continue
		if fighter.playerID == _playerID:
			
			MatchGlobal.playerLives[_playerID] -= 1
			fighter.fighterIcon._set_lives(_playerID)
			_set_explosion(fighter)
			fighter._set_dead()
		if MatchGlobal.playerLives[_playerID] < 1:
			stage.stageCamera._remove_target(fighter)
		fighter.percent = 0
	stage.call_deferred("_check_active_players")

func _on_respawn_fighter():
	for fighter in get_children():
		if fighter is not Fighter: continue
		fighter.global_position = neutralFighterSpawner.global_position
		fighter._ready()

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
	fighterInstance.respawn_fighter.connect(_on_respawn_fighter)
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
