class_name FighterSelect
extends Control


func _on_button_pressed() -> void:
	match MatchGlobal.selectedGameMode:
		MatchGlobal.gameModes.STOCK_BATTLE:
			SceneLoader._load_scene("res://src/ui/stage_select/stage_select.tscn")
