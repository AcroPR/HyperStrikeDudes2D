class_name Stage
extends Node2D

@onready var fighterSpawners = $FighterSpawners

func _spawn_dead_player(_playerID: int):
	var fighterSpawner: FighterSpawner = fighterSpawners.get_node("-1")
	fighterSpawner._spawn_fighter(_playerID)

func _ready() -> void:
	for fighterSpawner: FighterSpawner in fighterSpawners.get_children():
		if fighterSpawner.playerID != -1:
			fighterSpawner._spawn_fighter()
