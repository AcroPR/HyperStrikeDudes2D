class_name Stage
extends Node2D

@onready var fighterSpawners = $FighterSpawners
@onready var stageCamera : StageCamera = $StageCamera
@onready var icons: HBoxContainer = $CanvasLayer/Icons

func _check_active_players():
	var playerCount: int = 0
	for playerLives in MatchGlobal.playerLives:
		if playerLives > 0: playerCount += 1
	playerCount -= (MatchGlobal.MAX_PLAYERS - MatchGlobal.currentPlayers)
	if playerCount <= 1:
		Engine.time_scale = 0.5
		SceneLoader._load_scene("res://src/ui/fighter_select/fighter_select.tscn")

func _hide_all_icons():
	for icon in icons.get_children():
		icon.visible = false

func _ready() -> void:
	MatchGlobal._start_match()
	_hide_all_icons()
	for fighterSpawner: FighterSpawner in fighterSpawners.get_children():
		if fighterSpawner.playerID != -1:
			var fighterNode = fighterSpawner._spawn_fighter()
			fighterNode.fighterIcon = icons.get_child(fighterSpawner.playerID)
			icons.get_child(fighterSpawner.playerID)._set_icon(fighterSpawner.playerID)
			fighterNode.percent = 0
			icons.get_child(fighterSpawner.playerID).visible = true
			icons.get_child(fighterSpawner.playerID)._set_player(fighterSpawner.playerID+1)
			icons.get_child(fighterSpawner.playerID)._set_lives(fighterSpawner.playerID)
			fighterNode.fighterIcon.enableShake = true
