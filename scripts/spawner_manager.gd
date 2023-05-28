class_name SpawnerManager
extends Node3D


@export var player : Player

var spawners := []

func _ready():
	for child in get_children():
		if child is Spawner:
			child.timer.timeout.connect(func (): child.spawn(player))
