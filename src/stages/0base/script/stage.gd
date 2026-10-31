class_name Stage
extends Node2D

@onready var fighterSpawners = $FighterSpawners
@onready var stageCamera : StageCamera = $StageCamera
@onready var icons: HBoxContainer = $CanvasLayer/Icons

func _hide_all_icons():
	for icon in icons.get_children():
		icon.visible = false

func _spawn_dead_player(_playerID: int):
	var fighterSpawner: FighterSpawner = fighterSpawners.get_node("-1")
	var fighterNode = fighterSpawner._spawn_fighter(_playerID)
	fighterNode.fighterIcon = icons.get_child(_playerID)
	fighterNode.percent = 0

func _ready() -> void:
	MatchGlobal._start_match()
	_hide_all_icons()
	for fighterSpawner: FighterSpawner in fighterSpawners.get_children():
		if fighterSpawner.playerID != -1:
			var fighterNode = fighterSpawner._spawn_fighter()
			fighterNode.fighterIcon = icons.get_child(fighterSpawner.playerID)
			fighterNode.percent = 0
			icons.get_child(fighterSpawner.playerID).visible = true
			icons.get_child(fighterSpawner.playerID)._set_player(fighterSpawner.playerID+1)
			icons.get_child(fighterSpawner.playerID)._set_lives(fighterSpawner.playerID)
		
