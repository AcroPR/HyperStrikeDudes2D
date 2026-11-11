class_name SceneManager
extends Node

func _ready() -> void:
	#SceneLoader._load_scene("res://src/ui/fighter_select/fighter_select.tscn")
	SceneLoader._load_scene("res://src/stages/0base/stage.tscn")

func _load_scene(instance: Node) -> void:
	Engine.time_scale = 1.0
	for child in get_children():
		child.queue_free()
	add_child(instance)
