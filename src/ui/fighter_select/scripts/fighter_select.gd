class_name FighterSelect
extends Control

@onready var livesLabel: Label = $RuleButtons/Lives/Label
@onready var timeLabel: Label = $RuleButtons/Time/Label

func _ready() -> void:
	livesLabel.text = "Lives: " + str(MatchGlobal.startingLives)
	timeLabel.text = str(MatchGlobal.startingMinutes) + " Minutes"

func _on_button_pressed() -> void:
	match MatchGlobal.selectedGameMode:
		MatchGlobal.gameModes.STOCK_BATTLE:
			SceneLoader._load_scene("res://src/ui/stage_select/stage_select.tscn")

func _on_exit_label_pressed() -> void:
	get_tree().quit()

func _on_less_lives__pressed() -> void:
	if MatchGlobal.MIN_LIVES < MatchGlobal.startingLives:
		MatchGlobal.startingLives -= 1
	else:
		MatchGlobal.startingLives = MatchGlobal.MIN_LIVES
	livesLabel.text = "Lives: " + str(MatchGlobal.startingLives)

func _on_more_lives_pressed() -> void:
	if MatchGlobal.MAX_LIVES > MatchGlobal.startingLives:
		MatchGlobal.startingLives += 1
	else:
		MatchGlobal.startingLives = MatchGlobal.MAX_LIVES
	livesLabel.text = "Lives: " + str(MatchGlobal.startingLives)

func _on_less_time_pressed() -> void:
	if MatchGlobal.MIN_MINUTES < MatchGlobal.startingMinutes:
		MatchGlobal.startingMinutes -= 1
	else:
		MatchGlobal.startingMinutes = MatchGlobal.MIN_MINUTES
	if MatchGlobal.startingMinutes == MatchGlobal.MIN_MINUTES:
		timeLabel.text = "Timer Off"
	else:
		timeLabel.text = str(MatchGlobal.startingMinutes) + " Minutes"
	

func _on_more_time_pressed() -> void:
	if MatchGlobal.MAX_MINUTES > MatchGlobal.startingMinutes:
		MatchGlobal.startingMinutes += 1
	else:
		MatchGlobal.startingMinutes = MatchGlobal.MAX_MINUTES
	timeLabel.text = str(MatchGlobal.startingMinutes) + " Minutes"
