extends Node

const MAX_PLAYERS = 4
const MIN_PLAYERS = 2
const MAX_LIVES = 99
const MIN_LIVES = 1

# How many lives the players start with 
var startingLives = 4

var timer = true

var playerValues = {
	"Fighter": 0,
	"Color": 0,
	"Team": 0,
	"Controller_Index": 0,
}

var players = []

#Array of how many players are on what team
var currentPlayers = 2

#Int Array That Holds The Number Of Lives Of Each Player
var playerLives = [0,0,0,0]

func _ready():
	var playerCount = MAX_PLAYERS
	
	for i in range(playerCount):
		var newPlayer = playerValues.duplicate()
		newPlayer["Controller_Index"] = i
		newPlayer["Team"] = i
		players.append(newPlayer)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _start_match():
	for index in playerLives.size():
		playerLives[index] = startingLives
