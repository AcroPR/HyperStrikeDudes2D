extends Node

signal progress_change(progress)
signal load_finished

var loadingScreen: PackedScene = preload("res://src/core/scene_manager/loadingScreen.tscn")
var loadedResource: PackedScene
var scenePath: String
var progress: Array = []
var useSubThreads: bool = true

func _ready() -> void:
	set_process(false)

func _load_scene(_scenePath: String) -> void:
	scenePath = _scenePath
	
	var newLoadScreen = loadingScreen.instantiate()
	add_child(newLoadScreen)
	progress_change.connect(newLoadScreen._on_progress_changed)
	load_finished.connect(newLoadScreen._on_load_finished)
	
	await newLoadScreen.loading_screen_ready
	
	_start_load()

func _start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scenePath, "", useSubThreads)
	if state == OK:
		set_process(true)

func _process(_delta: float) -> void:
	var loadStatus = ResourceLoader.load_threaded_get_status(scenePath, progress)
	progress_change.emit(progress[0])
	match loadStatus:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loadedResource = ResourceLoader.load_threaded_get(scenePath)
			var instance = loadedResource.instantiate()
			get_tree().current_scene._load_scene(instance)
			load_finished.emit()
