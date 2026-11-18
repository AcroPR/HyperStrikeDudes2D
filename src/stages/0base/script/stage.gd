class_name Stage
extends Node2D

@onready var fighterSpawners = $FighterSpawners
@onready var gameTimer: Label = $CanvasLayer/GameTimer
@onready var stageCamera : StageCamera = $StageCamera
@onready var icons: HBoxContainer = $CanvasLayer/Icons

var inSuddenDeath: bool

func _check_active_players():
	var playerCount: int = 0
	for playerLives in MatchGlobal.playerLives:
		if playerLives > 0: playerCount += 1
	playerCount -= (MatchGlobal.MAX_PLAYERS - MatchGlobal.currentPlayers)
	if playerCount <= 1:
		gameTimer.runTimer = false
		gameTimer.text = "GAME!"
		Engine.time_scale = 0.25
		SceneLoader._load_scene("res://src/ui/fighter_select/fighter_select.tscn")

func _hide_all_icons():
	for icon in icons.get_children():
		icon.visible = false

func _ready() -> void:
	inSuddenDeath = false
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


func _on_game_timer_timer_end() -> void:
	# Max Lives, Min %, Num of Players with that number of lives
	var winner = [0,9999,0]
	for icon : FighterIcon in icons.get_children():
		if !icon.visible: continue
		if icon._get_lives() > winner[0]:
			winner = [icon._get_lives(), icon._get_percent(), 1]
		elif icon._get_lives() == winner[0]:
			if icon._get_percent() < winner[1]:
				winner = [icon._get_lives(), icon._get_percent(), 1]
			elif icon._get_percent() == winner[1]:
				winner[2] += 1
	if winner[2] > 1:
		gameTimer.text = "SUDDEN DEATH"
		inSuddenDeath = true
	else:
		gameTimer.text = "GAME!"
		Engine.time_scale = 0.25
		SceneLoader._load_scene("res://src/ui/fighter_select/fighter_select.tscn")

func _damage_taken() -> void:
	if inSuddenDeath:
		_on_game_timer_timer_end()

func _live_taken() -> void:
	if inSuddenDeath:
		_on_game_timer_timer_end()
